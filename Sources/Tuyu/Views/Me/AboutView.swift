import SwiftUI

public struct AboutView: View {
    @Environment(\.dismiss) private var dismiss

    public init() {}

    public var body: some View {
        ZStack {
            TuyuColors.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                TuyuTopBar(
                    title: "关于图语",
                    left: .back,
                    onBack: { dismiss() }
                )

                ScrollView {
                    VStack(spacing: TuyuSpacing.s6) {
                        // Logo 区
                        VStack(spacing: TuyuSpacing.s4) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(LinearGradient(
                                        colors: [TuyuColors.accent, TuyuColors.accent2],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ))
                                    .frame(width: 96, height: 96)
                                    .tuyuShadow(TuyuShadow.lg)

                                Image(systemName: "sparkles")
                                    .font(.system(size: 44, weight: .bold))
                                    .foregroundColor(.white)
                            }

                            Text("图语")
                                .font(TuyuTypography.xxxl)
                                .foregroundColor(TuyuColors.fg)

                            Text("让每一张照片都更出彩")
                                .font(TuyuTypography.md)
                                .foregroundColor(TuyuColors.muted)
                        }
                        .padding(.top, TuyuSpacing.s6)

                        // 版本信息
                        TuyuCard {
                            VStack(spacing: 0) {
                                infoRow(label: "版本", value: "1.0.0 (Build 1)")
                                divider()
                                infoRow(label: "发布日期", value: "2026-06-21")
                                divider()
                                infoRow(label: "开发者", value: "图语工作室")
                                divider()
                                infoRow(label: "技术栈", value: "SwiftUI + AI Pipeline")
                            }
                        }
                        .padding(.horizontal, TuyuSpacing.s4)

                        // 功能介绍
                        TuyuCard {
                            VStack(alignment: .leading, spacing: TuyuSpacing.s3) {
                                Text("产品介绍")
                                    .font(TuyuTypography.lg)
                                    .foregroundColor(TuyuColors.fg)

                                Text("图语是一款轻量级 AI 图片处理工具，覆盖人像、商品、风景、节日、证件、修复六大场景，56 款精选模板，3 秒出片。")
                                    .font(TuyuTypography.md)
                                    .foregroundColor(TuyuColors.muted)
                                    .lineSpacing(4)
                            }
                        }
                        .padding(.horizontal, TuyuSpacing.s4)

                        // 团队
                        TuyuCard {
                            VStack(alignment: .leading, spacing: TuyuSpacing.s3) {
                                Text("团队")
                                    .font(TuyuTypography.lg)
                                    .foregroundColor(TuyuColors.fg)

                                Text("产品 · 设计 · 算法 · 客户端 · 服务端 · 测试")
                                    .font(TuyuTypography.md)
                                    .foregroundColor(TuyuColors.muted)
                            }
                        }
                        .padding(.horizontal, TuyuSpacing.s4)

                        // 版权
                        Text("© 2026 图语工作室 · All rights reserved")
                            .font(TuyuTypography.sm)
                            .foregroundColor(TuyuColors.muted)
                            .padding(.bottom, TuyuSpacing.s6)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(TuyuTypography.md)
                .foregroundColor(TuyuColors.muted)
            Spacer()
            Text(value)
                .font(TuyuTypography.md)
                .foregroundColor(TuyuColors.fg)
        }
        .padding(.vertical, TuyuSpacing.s3)
    }

    private func divider() -> some View {
        Rectangle()
            .fill(TuyuColors.border)
            .frame(height: 0.5)
    }
}
