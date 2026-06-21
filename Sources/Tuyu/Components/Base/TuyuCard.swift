import SwiftUI

public enum TuyuCardVariant {
    case `default`, elevated, outlined
}

public struct TuyuCard<Content: View>: View {
    public let variant: TuyuCardVariant
    public let onPress: (() -> Void)?
    public let content: () -> Content

    public init(
        variant: TuyuCardVariant = .default,
        onPress: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.variant = variant
        self.onPress = onPress
        self.content = content
    }

    public var body: some View {
        let card = content()
            .padding(TuyuSpacing.s4)
            .background(TuyuColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: TuyuRadius.lg))
            .modifier(CardModifier(variant: variant))

        if let onPress = onPress {
            Button(action: onPress) {
                card
            }
            .buttonStyle(PlainButtonStyle())
        } else {
            card
        }
    }
}

private struct CardModifier: ViewModifier {
    let variant: TuyuCardVariant

    func body(content: Content) -> some View {
        switch variant {
        case .default:
            content
        case .elevated:
            content.tuyuShadow(TuyuShadow.md)
        case .outlined:
            content.overlay(
                RoundedRectangle(cornerRadius: TuyuRadius.lg)
                    .stroke(TuyuColors.border, lineWidth: 1)
            )
        }
    }
}
