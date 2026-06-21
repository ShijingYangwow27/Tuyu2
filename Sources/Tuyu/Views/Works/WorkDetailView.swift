import SwiftUI

@MainActor
public class WorkDetailViewModel: ObservableObject {
    @Published public var work: Work
    @Published public var showSaveToast: Bool = false

    public init(work: Work) {
        self.work = work
    }

    public func saveToAlbum() {
        HapticFeedback.success()
        showSaveToast = true
    }
}

public struct WorkDetailView: View {
    @StateObject private var viewModel: WorkDetailViewModel
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss

    public init(work: Work) {
        _viewModel = StateObject(wrappedValue: WorkDetailViewModel(work: work))
    }

    public var body: some View {
        ZStack {
            TuyuColors.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                TuyuTopBar(
                    title: "作品详情",
                    left: .back,
                    onBack: { dismiss() }
                )

                ScrollView {
                    VStack(spacing: TuyuSpacing.s4) {
                        // 大图
                        TuyuCard(variant: .elevated) {
                            Rectangle()
                                .fill(LinearGradient(
                                    colors: [Color(red: 0.99, green: 0.85, blue: 0.70), Color(red: 0.95, green: 0.65, blue: 0.50)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .aspectRatio(3.0/4.0, contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: TuyuRadius.md))
                                .overlay(
                                    VStack(spacing: TuyuSpacing.s2) {
                                        Image(systemName: "photo.fill")
                                            .font(.system(size: 48))
                                            .foregroundColor(.white.opacity(0.85))
                                        Text(viewModel.work.templateName)
                                            .font(TuyuTypography.md)
                                            .foregroundColor(.white)
                                    }
                                )
                        }
                        .padding(.horizontal, TuyuSpacing.s4)

                        // 元数据
                        VStack(alignment: .leading, spacing: TuyuSpacing.s3) {
                            metaRow(icon: "tag.fill", label: "使用模板", value: viewModel.work.templateName)
                            metaRow(icon: "clock.fill", label: "生成时间", value: viewModel.work.createdAt.formatted(date: .abbreviated, time: .shortened))
                            metaRow(icon: "number", label: "作品 ID", value: viewModel.work.id)
                        }
                        .padding(TuyuSpacing.s4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(TuyuColors.surface)
                        .clipShape(RoundedRectangle(cornerRadius: TuyuRadius.lg))
                        .padding(.horizontal, TuyuSpacing.s4)

                        Spacer(minLength: 100)
                    }
                    .padding(.top, TuyuSpacing.s4)
                }
            }

            if viewModel.showSaveToast {
                VStack {
                    Spacer()
                    HStack(spacing: TuyuSpacing.s2) {
                        Image(systemName: "checkmark.circle.fill")
                        Text("已保存到相册")
                    }
                    .font(TuyuTypography.md)
                    .foregroundColor(.white)
                    .padding(TuyuSpacing.s4)
                    .background(Color.black.opacity(0.75))
                    .clipShape(Capsule())
                    .padding(.bottom, 100)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: TuyuSpacing.s3) {
                TuyuButton(type: .secondary, size: .large, text: "分享", fullWidth: true) {
                    HapticFeedback.light()
                }
                TuyuButton(type: .primary, size: .large, text: "保存到相册", fullWidth: true) {
                    viewModel.saveToAlbum()
                }
            }
            .padding(TuyuSpacing.s4)
            .background(TuyuColors.surface)
        }
        .onChange(of: viewModel.showSaveToast) { newValue in
            if newValue {
                Task {
                    try? await Task.sleep(nanoseconds: 1_500_000_000)
                    await MainActor.run {
                        viewModel.showSaveToast = false
                    }
                }
            }
        }
    }

    private func metaRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: TuyuSpacing.s3) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(TuyuColors.accent)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(TuyuTypography.xs)
                    .foregroundColor(TuyuColors.muted)
                Text(value)
                    .font(TuyuTypography.md)
                    .foregroundColor(TuyuColors.fg)
            }
            Spacer()
        }
    }
}
