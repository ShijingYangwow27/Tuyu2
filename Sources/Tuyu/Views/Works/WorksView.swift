import SwiftUI

@MainActor
public class WorksViewModel: ObservableObject {
    @Published public var works: [Work] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?

    public init() {
        loadMockWorks()
    }

    public func loadMockWorks() {
        isLoading = true
        Task {
            try? await Task.sleep(nanoseconds: 500_000_000)

            await MainActor.run {
                self.works = (1...12).map { i in
                    Work(
                        id: "work_\(i)",
                        imageUrl: "https://cdn.tuyu.com/works/\(i).jpg",
                        thumbnailUrl: "https://cdn.tuyu.com/works/\(i)_thumb.jpg",
                        templateId: "P-0\((i % 18) + 1)",
                        templateName: TemplateData.template(id: "P-0\((i % 18) + 1)")?.name ?? "未知",
                        createdAt: Date().addingTimeInterval(-Double(i * 3600))
                    )
                }
                self.isLoading = false
            }
        }
    }

    public func deleteWork(_ work: Work) {
        works.removeAll(where: { $0.id == work.id })
    }
}

public struct WorksView: View {
    @StateObject private var viewModel = WorksViewModel()
    @EnvironmentObject var appState: AppState
    @State private var showDeleteModal = false
    @State private var workToDelete: Work?

    private let columns = [
        GridItem(.flexible(), spacing: TuyuSpacing.s2),
        GridItem(.flexible(), spacing: TuyuSpacing.s2),
        GridItem(.flexible(), spacing: TuyuSpacing.s2)
    ]

    public init() {}

    public var body: some View {
        ZStack {
            TuyuColors.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                TuyuTopBar(
                    title: "我的作品",
                    left: .none,
                    right: nil
                )

                if viewModel.works.isEmpty && !viewModel.isLoading {
                    emptyState
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: TuyuSpacing.s2) {
                            ForEach(viewModel.works) { work in
                                TuyuWorkCard(work: work) {
                                    appState.navigateWorks(.workDetail(work))
                                }
                                .contextMenu {
                                    Button(role: .destructive) {
                                        workToDelete = work
                                        showDeleteModal = true
                                    } label: {
                                        Label("删除", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .padding(TuyuSpacing.s3)
                    }
                }
            }
        }
        .overlay(
            TuyuModal(
                type: .confirm,
                visible: $showDeleteModal,
                title: "确认删除？",
                content: "删除后将无法恢复",
                confirmText: "删除",
                onConfirm: {
                    if let work = workToDelete {
                        viewModel.deleteWork(work)
                    }
                    workToDelete = nil
                }
            )
        )
    }

    private var emptyState: some View {
        VStack(spacing: TuyuSpacing.s4) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 60))
                .foregroundColor(TuyuColors.muted)
            Text("还没有作品")
                .font(TuyuTypography.lg)
                .foregroundColor(TuyuColors.fg)
            Text("去生成你的第一张作品吧")
                .font(TuyuTypography.md)
                .foregroundColor(TuyuColors.muted)
            TuyuButton(type: .primary, size: .medium, text: "去生成", fullWidth: false) {
                appState.currentTab = .home
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    WorksView()
        .environmentObject(AppState())
}
