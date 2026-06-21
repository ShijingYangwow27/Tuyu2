import SwiftUI

public struct TuyuTemplateCard: View {
    public let template: Template
    public let onPress: () -> Void
    public var showHotTag: Bool = true

    @State private var image: UIImage?

    public init(template: Template, onPress: @escaping () -> Void, showHotTag: Bool = true) {
        self.template = template
        self.onPress = onPress
        self.showHotTag = showHotTag
    }

    public var body: some View {
        Button(action: {
            HapticFeedback.light()
            onPress()
        }) {
            ZStack(alignment: .bottomLeading) {
                // 背景图片
                Group {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Rectangle()
                            .fill(LinearGradient(
                                colors: gradientColors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                    }
                }
                .frame(maxWidth: .infinity)
                .aspectRatio(3.0/4.0, contentMode: .fit)
                .clipped()

                // 底部蒙层
                LinearGradient(
                    colors: [Color.black.opacity(0), Color.black.opacity(0.4)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(maxHeight: .infinity, alignment: .bottom)
                .frame(height: 80)
                .frame(maxWidth: .infinity, alignment: .bottom)

                // 热门标签
                if showHotTag && template.isHot {
                    HStack {
                        Spacer()
                        VStack {
                            HStack(spacing: 2) {
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 8))
                                Text("热门")
                                    .font(TuyuTypography.xs)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(
                                LinearGradient(
                                    colors: [Color(red: 1, green: 0.4, blue: 0.4), Color(red: 1, green: 0.2, blue: 0.2)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(Capsule())
                            Spacer()
                        }
                        .padding(TuyuSpacing.s2)
                    }
                }

                // 名称
                Text(template.name)
                    .font(TuyuTypography.md)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(TuyuSpacing.s3)
            }
            .clipShape(RoundedRectangle(cornerRadius: TuyuRadius.md))
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            image = UIImage.placeholder(template: template)
        }
    }

    private var gradientColors: [Color] {
        switch template.category.id {
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
