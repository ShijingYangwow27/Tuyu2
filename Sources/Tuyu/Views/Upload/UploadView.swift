import SwiftUI

@MainActor
public class UploadViewModel: ObservableObject {
    @Published public var image: UIImage?
    @Published public var isUploading: Bool = false
    @Published public var errorMessage: String?

    public let template: Template

    public init(template: Template) {
        self.template = template
    }

    public var canGenerate: Bool {
        image != nil && !isUploading
    }

    public func startGenerate(completion: @escaping (String) -> Void) {
        guard let image = image else { return }
        isUploading = true

        Task {
            // 模拟上传
            try? await Task.sleep(nanoseconds: 1_000_000_000)

            // 模拟创建任务
            try? await Task.sleep(nanoseconds: 500_000_000)

            await MainActor.run {
                isUploading = false
                completion("task_mock_\(Int(Date().timeIntervalSince1970))")
            }
        }
    }
}

public struct UploadView: View {
    @StateObject private var viewModel: UploadViewModel
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss

    public init(template: Template) {
        _viewModel = StateObject(wrappedValue: UploadViewModel(template: template))
    }

    public var body: some View {
        ZStack {
            TuyuColors.bg.ignoresSafeArea()

            VStack(spacing: TuyuSpacing.s4) {
                TuyuTopBar(
                    title: "上传图片",
                    left: .back,
                    onBack: { dismiss() }
                )

                ScrollView {
                    VStack(spacing: TuyuSpacing.s4) {
                        TuyuUploadArea(
                            image: $viewModel.image,
                            maxSizeMB: 10
                        ) { error in
                            viewModel.errorMessage = error
                        }

                        if let error = viewModel.errorMessage {
                            HStack(spacing: TuyuSpacing.s2) {
                                Image(systemName: "exclamationmark.circle.fill")
                                Text(error)
                            }
                            .font(TuyuTypography.sm)
                            .foregroundColor(TuyuColors.error)
                            .padding(TuyuSpacing.s3)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(TuyuColors.error.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: TuyuRadius.md))
                            .padding(.horizontal, TuyuSpacing.s4)
                        }

                        // 模板信息
                        TuyuCard {
                            HStack(spacing: TuyuSpacing.s3) {
                                LinearGradient(
                                    colors: [.indigo, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: TuyuRadius.sm))

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(viewModel.template.name)
                                        .font(TuyuTypography.md)
                                        .foregroundColor(TuyuColors.fg)
                                    Text(viewModel.template.effect)
                                        .font(TuyuTypography.sm)
                                        .foregroundColor(TuyuColors.muted)
                                        .lineLimit(2)
                                }

                                Spacer()
                            }
                        }
                        .padding(.horizontal, TuyuSpacing.s4)
                    }
                    .padding(.top, TuyuSpacing.s4)
                }

                TuyuButton(
                    type: .primary,
                    size: .large,
                    text: "下一步",
                    disabled: !viewModel.canGenerate,
                    loading: viewModel.isUploading
                ) {
                    viewModel.startGenerate { taskId in
                        appState.navigateHome(.generating(taskId: taskId, template: viewModel.template))
                    }
                }
                .padding(TuyuSpacing.s4)
                .background(TuyuColors.surface)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
