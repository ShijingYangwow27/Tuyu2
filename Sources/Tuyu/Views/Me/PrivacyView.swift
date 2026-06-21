import SwiftUI

public struct PrivacyView: View {
    @Environment(\.dismiss) private var dismiss

    public init() {}

    public var body: some View {
        ZStack {
            TuyuColors.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                TuyuTopBar(
                    title: "隐私政策",
                    left: .back,
                    onBack: { dismiss() }
                )

                ScrollView {
                    VStack(alignment: .leading, spacing: TuyuSpacing.s4) {
                        Text("最后更新：2026-06-21")
                            .font(TuyuTypography.sm)
                            .foregroundColor(TuyuColors.muted)

                        privacySection(
                            title: "1. 我们收集的信息",
                            body: """
                            • 设备信息：设备型号、操作系统版本、设备标识
                            • 使用信息：您访问的功能、生成的模板、操作时间
                            • 图片内容：您主动上传的待处理图片
                            • 账户信息：设备本地保存的 UID（不收集个人身份信息）
                            """
                        )

                        privacySection(
                            title: "2. 信息使用方式",
                            body: """
                            • 用于执行 AI 图像处理（上传、抠图、风格迁移等算子）
                            • 用于改善模板效果与服务质量
                            • 用于故障排查与安全审计
                            """
                        )

                        privacySection(
                            title: "3. 信息存储与保护",
                            body: """
                            • 上传图片仅用于本次生成，处理完成后 24 小时内自动删除
                            • 生成的成片由您自行选择是否保存到本地相册
                            • 所有传输使用 HTTPS 加密
                            • 不向任何第三方共享您的图片与个人信息
                            """
                        )

                        privacySection(
                            title: "4. 您的权利",
                            body: """
                            • 您可随时删除本地作品
                            • 您可在「设置」中清除缓存
                            • 您可拒绝相册权限，仅影响保存功能，不影响主流程
                            """
                        )

                        privacySection(
                            title: "5. 联系方式",
                            body: "如有任何疑问，请通过应用内「设置 - 关于图语」反馈。\n我们将在 3 个工作日内回复。"
                        )

                        Spacer(minLength: 40)
                    }
                    .padding(TuyuSpacing.s4)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func privacySection(title: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: TuyuSpacing.s2) {
            Text(title)
                .font(TuyuTypography.lg)
                .foregroundColor(TuyuColors.fg)
            Text(body)
                .font(TuyuTypography.md)
                .foregroundColor(TuyuColors.muted)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(TuyuSpacing.s4)
        .background(TuyuColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: TuyuRadius.lg))
    }
}
