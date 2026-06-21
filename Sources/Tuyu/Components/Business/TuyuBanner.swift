import SwiftUI

public struct TuyuBanner: View {
    public let title: String
    public let subtitle: String?
    public let onPress: (() -> Void)?

    public init(title: String, subtitle: String? = nil, onPress: (() -> Void)? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.onPress = onPress
    }

    public var body: some View {
        Button(action: {
            HapticFeedback.light()
            onPress?()
        }) {
            ZStack(alignment: .leading) {
                LinearGradient(
                    colors: [TuyuColors.accent, TuyuColors.accent2],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                // 装饰
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 100, height: 100)
                    .offset(x: 250, y: -20)

                Circle()
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 60, height: 60)
                    .offset(x: 280, y: 40)

                VStack(alignment: .leading, spacing: TuyuSpacing.s2) {
                    Text(title)
                        .font(TuyuTypography.xlBold)
                        .foregroundColor(.white)
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(TuyuTypography.sm)
                            .foregroundColor(.white.opacity(0.85))
                    }
                }
                .padding(TuyuSpacing.s5)

                // 右侧装饰
                HStack {
                    Spacer()
                    Image(systemName: "sparkles")
                        .font(.system(size: 40))
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding()
            }
            .frame(height: 160)
            .clipShape(RoundedRectangle(cornerRadius: TuyuRadius.md))
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, TuyuSpacing.s4)
    }
}
