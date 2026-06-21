import SwiftUI

public enum TuyuButtonType {
    case primary, secondary, text
}

public enum TuyuButtonSize {
    case large, medium, small

    var height: CGFloat {
        switch self {
        case .large: return 48
        case .medium: return 40
        case .small: return 32
        }
    }

    var font: Font {
        switch self {
        case .large: return TuyuTypography.button
        case .medium: return TuyuTypography.button
        case .small: return TuyuTypography.buttonSmall
        }
    }

    var padding: CGFloat {
        switch self {
        case .large: return 24
        case .medium: return 20
        case .small: return 16
        }
    }
}

public struct TuyuButton: View {
    public let type: TuyuButtonType
    public let size: TuyuButtonSize
    public let text: String
    public var disabled: Bool = false
    public var loading: Bool = false
    public var fullWidth: Bool = true
    public let action: () -> Void

    @State private var isPressed = false

    public init(
        type: TuyuButtonType = .primary,
        size: TuyuButtonSize = .large,
        text: String,
        disabled: Bool = false,
        loading: Bool = false,
        fullWidth: Bool = true,
        action: @escaping () -> Void
    ) {
        self.type = type
        self.size = size
        self.text = text
        self.disabled = disabled
        self.loading = loading
        self.fullWidth = fullWidth
        self.action = action
    }

    public var body: some View {
        Button(action: {
            guard !disabled, !loading else { return }
            HapticFeedback.light()
            action()
        }) {
            HStack(spacing: TuyuSpacing.s2) {
                if loading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: textColor))
                        .scaleEffect(0.8)
                }
                if !loading {
                    Text(text)
                        .font(size.font)
                        .foregroundColor(textColor)
                }
            }
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .frame(height: size.height)
            .padding(.horizontal, size.padding)
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: TuyuRadius.md)
                    .stroke(borderColor, lineWidth: type == .secondary ? 1 : 0)
            )
            .clipShape(RoundedRectangle(cornerRadius: TuyuRadius.md))
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(PressableButtonStyle(isPressed: $isPressed))
        .disabled(disabled || loading)
        .opacity(disabled ? 0.5 : 1.0)
    }

    private var backgroundColor: Color {
        if disabled {
            return TuyuColors.muted.opacity(0.5)
        }
        switch type {
        case .primary: return TuyuColors.accent
        case .secondary: return TuyuColors.surface
        case .text: return .clear
        }
    }

    private var textColor: Color {
        switch type {
        case .primary: return .white
        case .secondary: return TuyuColors.fg
        case .text: return TuyuColors.accent
        }
    }

    private var borderColor: Color {
        switch type {
        case .secondary: return TuyuColors.border
        default: return .clear
        }
    }
}

private struct PressableButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { newValue in
                isPressed = newValue
            }
    }
}
