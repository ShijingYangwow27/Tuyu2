import SwiftUI

@MainActor
public class HomeViewModel: ObservableObject {
    @Published public var categories: [Category] = TemplateData.categories
    @Published public var currentCategory: String = "recommend"
    @Published public var templates: [Template] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?

    public init() {
        loadTemplates()
    }

    public func selectCategory(_ id: String) {
        currentCategory = id
        loadTemplates()
    }

    public func loadTemplates() {
        isLoading = true
        errorMessage = nil

        Task {
            // V1: 使用本地数据
            let list = TemplateData.templates(category: currentCategory)
            // 模拟网络延迟
            try? await Task.sleep(nanoseconds: 300_000_000)

            await MainActor.run {
                self.templates = list
                self.isLoading = false
            }
        }
    }

    public func refresh() async {
        loadTemplates()
        try? await Task.sleep(nanoseconds: 500_000_000)
    }
}

public struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject var appState: AppState

    public init() {}

    private let columns = [
        GridItem(.flexible(), spacing: TuyuSpacing.s3),
        GridItem(.flexible(), spacing: TuyuSpacing.s3)
    ]

    public var body: some View {
        ZStack(alignment: .top) {
            TuyuColors.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                TuyuTopBar(
                    left: .logo,
                    right: .search,
                    onSearch: { /* TODO: 搜索页 */ }
                )

                ScrollView {
                    VStack(spacing: TuyuSpacing.s4) {
                        TuyuBanner(
                            title: "AI 一键生成",
                            subtitle: "56 款模板，3 秒出片"
                        )

                        TuyuCategoryTabs(
                            categories: viewModel.categories,
                            current: $viewModel.currentCategory,
                            onChange: { viewModel.selectCategory($0) }
                        )
                        .background(TuyuColors.bg)

                        if viewModel.isLoading && viewModel.templates.isEmpty {
                            VStack(spacing: TuyuSpacing.s3) {
                                ForEach(0..<4, id: \.self) { _ in
                                    TuyuLoader(type: .skeleton)
                                        .frame(height: 200)
                                }
                            }
                            .padding()
                        } else if let error = viewModel.errorMessage {
                            VStack(spacing: TuyuSpacing.s3) {
                                Image(systemName: "exclamationmark.circle")
                                    .font(.system(size: 40))
                                    .foregroundColor(TuyuColors.error)
                                Text(error)
                                    .font(TuyuTypography.md)
                                    .foregroundColor(TuyuColors.muted)
                                TuyuButton(type: .primary, size: .medium, text: "重试") {
                                    viewModel.loadTemplates()
                                }
                            }
                            .padding(.top, 60)
                        } else {
                            LazyVGrid(columns: columns, spacing: TuyuSpacing.s3) {
                                ForEach(viewModel.templates) { template in
                                    TuyuTemplateCard(template: template) {
                                        appState.navigateHome(.templateDetail(template))
                                    }
                                }
                            }
                            .padding(.horizontal, TuyuSpacing.s4)
                            .padding(.bottom, 100)
                        }
                    }
                }
                .refreshable {
                    await viewModel.refresh()
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AppState())
}
