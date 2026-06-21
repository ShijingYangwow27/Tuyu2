import SwiftUI

@MainActor
public class TemplateDetailViewModel: ObservableObject {
    @Published public var template: Template
    @Published public var isFavorited: Bool = false
    @Published public var showFullImage: Bool = false

    public init(template: Template) {
        self.template = template
    }

    public func toggleFavorite() {
        isFavorited.toggle()
        HapticFeedback.light()
    }
}

public struct TemplateDetailView: View {
    @StateObject private var viewModel: TemplateDetailViewModel
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss

    public init(template: Template) {
        _viewModel = StateObject(wrappedValue: TemplateDetailViewModel(template: template))
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            TuyuColors.bg.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: TuyuSpacing.s4) {
                    // 大封面
                    ZStack(alignment: .topTrailing) {
                        LinearGradient(
                            colors: gradientColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .aspectRatio(16.0/9.0, contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .clipped()

                        Button(action: {
                            viewModel.toggleFavorite()
                        }) {
                            Image(systemName: viewModel.isFavorited ? "heart.fill" : "heart")
                                .font(.system(size: 22))
                                .foregroundColor(viewModel.isFavorited ? Color.red : .white)
                                .padding(TuyuSpacing.s3)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                        .padding(TuyuSpacing.s4)
                    }

                    // 标题与标签
                    VStack(alignment: .leading, spacing: TuyuSpacing.s3) {
                        HStack {
                            Text(viewModel.template.name)
                                .font(TuyuTypography.xxl)
                                .foregroundColor(TuyuColors.fg)

                            Spacer()

                            HStack(spacing: 4) {
                                Circle()
                                    .fill(Color(hex: viewModel.template.difficulty.color))
                                    .frame(width: 6, height: 6)
                                Text(viewModel.template.difficulty.label)
                                    .font(TuyuTypography.sm)
                                    .foregroundColor(TuyuColors.muted)
                            }
                        }

                        Text(viewModel.template.description)
                            .font(TuyuTypography.md)
                            .foregroundColor(TuyuColors.fg)

                        if !viewModel.template.tags.isEmpty {
                            HStack(spacing: TuyuSpacing.s2) {
                                ForEach(viewModel.template.tags, id: \.self) { tag in
                                    Text("#\(tag)")
                                        .font(TuyuTypography.sm)
                                        .foregroundColor(TuyuColors.accent)
                                        .padding(.horizontal, TuyuSpacing.s3)
                                        .padding(.vertical, 4)
                                        .background(TuyuColors.accent.opacity(0.1))
                                        .clipShape(Capsule())
                                }
                            }
                        }
                    }
                    .padding(.horizontal, TuyuSpacing.s4)

                    // 效果说明
                    VStack(alignment: .leading, spacing: TuyuSpacing.s2) {
                        Text("效果说明")
                            .font(TuyuTypography.lg)
                            .foregroundColor(TuyuColors.fg)
                        Text(viewModel.template.effect)
                            .font(TuyuTypography.md)
                            .foregroundColor(TuyuColors.muted)
                    }
                    .padding(TuyuSpacing.s4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(TuyuColors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: TuyuRadius.lg))
                    .padding(.horizontal, TuyuSpacing.s4)

                    // 算子信息
                    VStack(alignment: .leading, spacing: TuyuSpacing.s2) {
                        Text("算子组合")
                            .font(TuyuTypography.lg)
                            .foregroundColor(TuyuColors.fg)
                        HStack(spacing: TuyuSpacing.s2) {
                            ForEach(viewModel.template.operators, id: \.self) { op in
                                Text(op)
                                    .font(TuyuTypography.sm)
                                    .foregroundColor(TuyuColors.muted)
                                    .padding(.horizontal, TuyuSpacing.s3)
                                    .padding(.vertical, 4)
                                    .background(TuyuColors.bg)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(TuyuSpacing.s4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(TuyuColors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: TuyuRadius.lg))
                    .padding(.horizontal, TuyuSpacing.s4)

                    // 预计耗时
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(TuyuColors.accent)
                        Text("预计耗时：\(viewModel.template.estimatedTime.durationFormatted)")
                            .font(TuyuTypography.md)
                            .foregroundColor(TuyuColors.fg)
                    }
                    .padding(.horizontal, TuyuSpacing.s4)

                    // 底部留白
                    Color.clear.frame(height: 80)
                }
            }

            // 底部按钮
            VStack(spacing: 0) {
                Rectangle()
                    .fill(TuyuColors.surface)
                    .frame(height: 1)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, y: -2)

                TuyuButton(
                    type: .primary,
                    size: .large,
                    text: "立即生成",
                    fullWidth: false
                ) {
                    appState.navigateHome(.upload(viewModel.template))
                }
                .padding(TuyuSpacing.s4)
                .background(TuyuColors.surface)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(TuyuColors.fg)
                }
            }
        }
    }

    private var gradientColors: [Color] {
        switch viewModel.template.category.id {
        case "portrait": return [Color(red: 0.39, green: 0.40, blue: 0.95), Color(red: 0.55, green: 0.36, blue: 0.96)]
        case "product": return [Color(red: 0.06, green: 0.73, blue: 0.51), Color(red: 0.02, green: 0.59, blue: 0.41)]
        case "scene": return [Color(red: 0.06, green: 0.71, blue: 0.83), Color(red: 0.01, green: 0.45, blue: 0.65)]
        case "festival": return [Color(red: 0.93, green: 0.27, blue: 0.60), Color(red: 0.86, green: 0.21, blue: 0.27)]
        case "id": return [Color(red: 0.20, green: 0.60, blue: 0.86), Color(red: 0.10, green: 0.40, blue: 0.66)]
        case "repair": return [Color(red: 0.96, green: 0.62, blue: 0.04), Color(red: 0.83, green: 0.32, blue: 0.07)]
        default: return [.gray, .black]
        }
    }
}
