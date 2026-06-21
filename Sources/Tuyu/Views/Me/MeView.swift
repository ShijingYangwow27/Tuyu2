import SwiftUI

public struct MeView: View {
    @EnvironmentObject var appState: AppState

    public init() {}

    public var body: some View {
        ZStack {
            TuyuColors.bg.ignoresSafeArea()

            ScrollView {
                VStack(spacing: TuyuSpacing.s4) {
                    TuyuTopBar(
                        title: "我的",
                        left: .none,
                        right: nil
                    )

                    // 用户信息
                    VStack(spacing: TuyuSpacing.s3) {
                        Circle()
                            .fill(LinearGradient(
                                colors: [TuyuColors.accent, TuyuColors.accent2],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                            )

                        Text("图语用户")
                            .font(TuyuTypography.xl)
                            .foregroundColor(TuyuColors.fg)

                        Text("UID: 100001")
                            .font(TuyuTypography.sm)
                            .foregroundColor(TuyuColors.muted)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, TuyuSpacing.s6)

                    // 数据统计
                    HStack(spacing: TuyuSpacing.s3) {
                        statCard(value: "12", label: "作品数")
                        statCard(value: "5", label: "收藏数")
                        statCard(value: "0", label: "获赞数")
                    }
                    .padding(.horizontal, TuyuSpacing.s4)

                    // 菜单
                    VStack(spacing: 0) {
                        menuRow(icon: "heart.fill", title: "我的收藏") { }
                        divider()
                        menuRow(icon: "clock.fill", title: "历史记录") { }
                        divider()
                        menuRow(icon: "gear", title: "设置") {
                            appState.navigateMe(.settings)
                        }
                        divider()
                        menuRow(icon: "info.circle", title: "关于图语") {
                            appState.navigateMe(.about)
                        }
                        divider()
                        menuRow(icon: "lock", title: "隐私政策") {
                            appState.navigateMe(.privacy)
                        }
                    }
                    .background(TuyuColors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: TuyuRadius.lg))
                    .padding(.horizontal, TuyuSpacing.s4)

                    Spacer(minLength: 100)
                }
            }
        }
    }

    private func statCard(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(TuyuTypography.xxl)
                .foregroundColor(TuyuColors.fg)
            Text(label)
                .font(TuyuTypography.sm)
                .foregroundColor(TuyuColors.muted)
        }
        .frame(maxWidth: .infinity)
        .padding(TuyuSpacing.s4)
        .background(TuyuColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: TuyuRadius.lg))
    }

    private func menuRow(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: {
            HapticFeedback.light()
            action()
        }) {
            HStack(spacing: TuyuSpacing.s3) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(TuyuColors.accent)
                    .frame(width: 24)
                Text(title)
                    .font(TuyuTypography.md)
                    .foregroundColor(TuyuColors.fg)
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

#Preview {
    MeView()
        .environmentObject(AppState())
}
