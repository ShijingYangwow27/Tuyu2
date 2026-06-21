import SwiftUI

@MainActor
public class GeneratingViewModel: ObservableObject {
    @Published public var progress: Double = 0
    @Published public var status: GenerationTask.Status = .processing
    @Published public var currentStep: Int = 2
    @Published public var errorMessage: String?
    @Published public var isCancelled: Bool = false

    public let taskId: String
    public let template: Template

    private var timer: Timer?

    public init(taskId: String, template: Template) {
        self.taskId = taskId
        self.template = template
    }

    public func start() {
        // 模拟进度更新
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self = self, !self.isCancelled else { return }

                self.progress += 2
                if self.progress >= 30 && self.currentStep == 2 {
                    self.currentStep = 3
                }
                if self.progress >= 100 {
                    self.progress = 100
                    self.status = .success
                    self.timer?.invalidate()
                }
            }
        }
    }

    public func cancel() {
        isCancelled = true
        timer?.invalidate()
        status = .cancelled
    }

    public func deinitTimer() {
        timer?.invalidate()
    }
}

public struct GeneratingView: View {
    @StateObject private var viewModel: GeneratingViewModel
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var showCancelModal = false

    public init(taskId: String, template: Template) {
        _viewModel = StateObject(wrappedValue: GeneratingViewModel(taskId: taskId, template: template))
    }

    public var body: some View {
        ZStack {
            TuyuColors.bg.ignoresSafeArea()

            VStack(spacing: TuyuSpacing.s6) {
                TuyuTopBar(
                    title: "AI 生成中",
                    left: .none
                )

                Spacer()

                TuyuStepBar(
                    steps: ["上传", "智能识别", "模板生成", "完成"],
                    current: viewModel.currentStep
                )

                Spacer()

                TuyuLoader(type: .spinner, text: "AI 正在努力生成中...")

                TuyuLoader(type: .progress, text: "预计还需 \(Int((100.0 - viewModel.progress) / 100.0 * Double(viewModel.template.estimatedTime))) 秒", progress: viewModel.progress)
                    .padding(.horizontal, TuyuSpacing.s6)

                TuyuCard {
                    HStack(spacing: TuyuSpacing.s3) {
                        LinearGradient(colors: [.indigo, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: TuyuRadius.sm))

                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.template.name)
                                .font(TuyuTypography.md)
                                .foregroundColor(TuyuColors.fg)
                            Text("算子：\(viewModel.template.operators.joined(separator: " + "))")
                                .font(TuyuTypography.xs)
                                .foregroundColor(TuyuColors.muted)
                                .lineLimit(1)
                        }

                        Spacer()
                    }
                }
                .padding(.horizontal, TuyuSpacing.s4)

                Spacer()

                TuyuButton(
                    type: .secondary,
                    size: .medium,
                    text: "取消生成",
                    fullWidth: false
                ) {
                    showCancelModal = true
                }
                .padding(.bottom, TuyuSpacing.s6)
            }

            TuyuModal(
                type: .confirm,
                visible: $showCancelModal,
                title: "确认取消？",
                content: "取消后当前生成将停止，已完成的进度将丢失",
                confirmText: "确认取消",
                cancelText: "继续生成",
                onConfirm: {
                    viewModel.cancel()
                    dismiss()
                }
            )
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.start()
        }
        .onChange(of: viewModel.status) { newStatus in
            if newStatus == .success {
                let mockWork = Work(
                    id: "work_\(Int(Date().timeIntervalSince1970))",
                    imageUrl: "https://cdn.tuyu.com/works/\(viewModel.taskId).jpg",
                    thumbnailUrl: "https://cdn.tuyu.com/works/\(viewModel.taskId)_thumb.jpg",
                    templateId: viewModel.template.id,
                    templateName: viewModel.template.name,
                    createdAt: Date()
                )
                appState.navigateHome(.result(mockWork))
            }
        }
    }
}
