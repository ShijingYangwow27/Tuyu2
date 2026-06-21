import SwiftUI
import UIKit

@MainActor
public class ResultViewModel: ObservableObject {
    @Published public var work: Work
    @Published public var showShareSheet: Bool = false
    @Published public var showSaveSuccess: Bool = false

    public init(work: Work) {
        self.work = work
    }

    public func saveToAlbum() {
        // V1: 实际接入需请求相册权限
        HapticFeedback.success()
        showSaveSuccess = true
    }

    public func share() {
        showShareSheet = true
    }
}

public struct ResultView: View {
    @StateObject private var viewModel: ResultViewModel
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var showSaveToast = false

    public init(work: Work) {
        _viewModel = StateObject(wrappedValue: ResultViewModel(work: work))
    }

    public var body: some View {
        ZStack {
            TuyuColors.bg.ignoresSafeArea()

            VStack(spacing: TuyuSpacing.s4) {
                TuyuTopBar(
                    title: "生成完成",
                    left: .back,
                    onBack: { dismiss() }
                )

                ScrollView {
                    VStack(spacing: TuyuSpacing.s4) {
                        // 成片展示
                        TuyuCard(variant: .elevated) {
                            VStack(spacing: TuyuSpacing.s3) {
                                Rectangle()
                                    .fill(LinearGradient(
                                        colors: [Color(red: 0.99, green: 0.85, blue: 0.70), Color(red: 0.95, green: 0.65, blue: 0.50)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ))
                                    .aspectRatio(3.0/4.0, contentMode: .fit)
                                    .clipShape(RoundedRectangle(cornerRadius: TuyuRadius.md))
                                    .overlay(
                                        VStack {
                                            Image(systemName: "checkmark.seal.fill")
                                                .font(.system(size: 40))
                                                .foregroundColor(.white.opacity(0.9))
                                            Text("生成成功")
                                                .font(TuyuTypography.lg)
                                                .foregroundColor(.white)
                                        }
                                    )

                                HStack {
                                    Text("模板：\(viewModel.work.templateName)")
                                        .font(TuyuTypography.sm)
                                        .foregroundColor(TuyuColors.muted)
                                    Spacer()
                                    Text(viewModel.work.createdAt.relativeTime)
                                        .font(TuyuTypography.sm)
                                        .foregroundColor(TuyuColors.muted)
                                }
                            }
                        }
                        .padding(.horizontal, TuyuSpacing.s4)

                        // 操作按钮
                        VStack(spacing: TuyuSpacing.s3) {
                            TuyuButton(type: .primary, size: .large, text: "保存到相册", fullWidth: true) {
                                viewModel.saveToAlbum()
                                showSaveToast = true
                            }

                            HStack(spacing: TuyuSpacing.s3) {
                                TuyuButton(type: .secondary, size: .medium, text: "分享", fullWidth: true) {
                                    viewModel.share()
                                }
                                TuyuButton(type: .secondary, size: .medium, text: "再来一张", fullWidth: true) {
                                    appState.popHomeToRoot()
                                }
                            }
                        }
                        .padding(.horizontal, TuyuSpacing.s4)
                    }
                    .padding(.top, TuyuSpacing.s4)
                }
            }

            if showSaveToast {
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
                .transition(.opacity)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: showSaveToast) { newValue in
            if newValue {
                Task {
                    try? await Task.sleep(nanoseconds: 1_500_000_000)
                    await MainActor.run {
                        showSaveToast = false
                    }
                }
            }
        }
    }
}

#Preview {
    let work = Work(
        id: "preview-001",
        imageUrl: "preview",
        thumbnailUrl: "preview",
        templateId: "P-01",
        templateName: "韩系证件棚",
        createdAt: Date()
    )
    return NavigationStack {
        ResultView(work: work)
            .environmentObject(AppState())
    }
}
