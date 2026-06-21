import SwiftUI

public struct TuyuWorkCard: View {
    public let work: Work
    public let onPress: () -> Void
    public var showTemplate: Bool = true

    @State private var image: UIImage?

    public init(work: Work, onPress: @escaping () -> Void, showTemplate: Bool = true) {
        self.work = work
        self.onPress = onPress
        self.showTemplate = showTemplate
    }

    public var body: some View {
        Button(action: {
            HapticFeedback.light()
            onPress()
        }) {
            ZStack {
                // 图片
                Group {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Rectangle()
                            .fill(LinearGradient(
                                colors: [TuyuColors.muted.opacity(0.3), TuyuColors.muted.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                    }
                }
                .frame(maxWidth: .infinity)
                .aspectRatio(1.0, contentMode: .fit)
                .clipped()

                if showTemplate {
                    VStack {
                        HStack {
                            Spacer()
                            Text(work.templateName)
                                .font(TuyuTypography.xs)
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(TuyuColors.accent.opacity(0.9))
                                .clipShape(Capsule())
                        }
                        Spacer()
                    }
                    .padding(4)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: TuyuRadius.md))
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            // V1: 暂时用占位图（实际接入 ImageLoader）
            image = generatePlaceholder()
        }
    }

    private func generatePlaceholder() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 300, height: 300))
        return renderer.image { context in
            let colors = [
                UIColor(red: 0.99, green: 0.85, blue: 0.70, alpha: 1),
                UIColor(red: 0.95, green: 0.65, blue: 0.50, alpha: 1)
            ]
            let cgColors = colors.map { $0.cgColor } as CFArray
            let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: cgColors,
                locations: [0, 1]
            )!
            context.cgContext.drawLinearGradient(
                gradient,
                start: .zero,
                end: CGPoint(x: 300, y: 300),
                options: []
            )
        }
    }
}
