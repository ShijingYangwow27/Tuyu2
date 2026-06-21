import SwiftUI

public struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss

    @State private var saveOriginalToAlbum = true
    @State private var autoSaveToAlbum = false
    @State private var hdQuality = true
    @State private var showClearCacheAlert = false

    public init() {}

    public var body: some View {
        ZStack {
            TuyuColors.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                TuyuTopBar(
                    title: "设置",
                    left: .back,
                    onBack: { dismiss() }
                )

                ScrollView {
                    VStack(spacing: TuyuSpacing.s4) {
                        // 生成质量
                        section(title: "生成质量") {
                            toggleRow(
                                icon: "wand.and.stars",
                                title: "高清生成",
                                subtitle: "输出更高分辨率，耗时更长",
                                isOn: $hdQuality
                            )
                        }

                        // 相册
                        section(title: "相册与存储") {
                            toggleRow(
                                icon: "photo.on.rectangle",
                                title: "原图保存到相册",
                                subtitle: "生成前自动备份原图",
                                isOn: $saveOriginalToAlbum
                            )
                            divider()
                            toggleRow(
                                icon: "square.and.arrow.down",
                                title: "生成后自动保存",
                                subtitle: "成片直接存入系统相册",
                                isOn: $autoSaveToAlbum
                            )
                            divider()
                            actionRow(icon: "trash", title: "清除缓存", subtitle: "当前缓存 0 B", tint: TuyuColors.error) {
                                showClearCacheAlert = true
                            }
                        }

                        // 通知
                        section(title: "通知") {
                            actionRow(icon: "bell.badge", title: "推送通知", subtitle: "开启新品模板、活动提醒") {
                                // TODO: 跳转系统设置
                            }
                        }

                        // 关于
                        section(title: "关于") {
                            actionRow(icon: "star", title: "去 App Store 评价") {
                                // TODO: SKStoreReviewController
                            }
                            divider()
                            actionRow(icon: "doc.text", title: "服务条款") { }
                            divider()
                            actionRow(icon: "lock", title: "隐私政策") {
                                appState.navigateMe(.privacy)
                            }
                            divider()
                            actionRow(icon: "info.circle", title: "关于图语", subtitle: "v1.0.0") {
                                appState.navigateMe(.about)
                            }
                        }

                        Spacer(minLength: 40)
                    }
                    .padding(.top, TuyuSpacing.s3)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .overlay(
            TuyuModal(
                type: .confirm,
                visible: $showClearCacheAlert,
                title: "确认清除缓存？",
                content: "清除后已下载的模板封面将重新加载",
                confirmText: "清除",
                onConfirm: {
                    HapticFeedback.success()
                }
            )
        )
    }

    // MARK: - 通用组件

    @ViewBuilder
    private func section<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: TuyuSpacing.s2) {
            Text(title)
                .font(TuyuTypography.sm)
                .foregroundColor(TuyuColors.muted)
                .padding(.horizontal, TuyuSpacing.s6)

            VStack(spacing: 0) {
                content()
            }
            .background(TuyuColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: TuyuRadius.lg))
            .padding(.horizontal, TuyuSpacing.s4)
        }
    }

    private func toggleRow(icon: String, title: String, subtitle: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: TuyuSpacing.s3) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(TuyuColors.accent)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(TuyuTypography.md)
                    .foregroundColor(TuyuColors.fg)
                Text(subtitle)
                    .font(TuyuTypography.xs)
                    .foregroundColor(TuyuColors.muted)
            }
            Spacer()
            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(TuyuColors.accent)
        }
        .padding(TuyuSpacing.s4)
    }

    private func actionRow(icon: String, title: String, subtitle: String? = nil, tint: Color = TuyuColors.accent, action: @escaping () -> Void) -> some View {
        Button(action: {
            HapticFeedback.light()
            action()
        }) {
            HStack(spacing: TuyuSpacing.s3) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(tint)
                    .frame(width: 24)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(TuyuTypography.md)
                        .foregroundColor(tint == TuyuColors.error ? TuyuColors.error : TuyuColors.fg)
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(TuyuTypography.xs)
                            .foregroundColor(TuyuColors.muted)
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(TuyuColors.muted)
            }
            .padding(TuyuSpacing.s4)
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func divider() -> some View {
        Rectangle()
            .fill(TuyuColors.border)
            .frame(height: 0.5)
            .padding(.leading, TuyuSpacing.s4 + 24 + TuyuSpacing.s3)
    }
}
