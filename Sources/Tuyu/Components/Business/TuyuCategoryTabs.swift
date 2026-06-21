import SwiftUI

public struct TuyuCategoryTabs: View {
    public let categories: [Category]
    @Binding public var current: String
    public let onChange: (String) -> Void

    public init(categories: [Category], current: Binding<String>, onChange: @escaping (String) -> Void) {
        self.categories = categories
        self._current = current
        self.onChange = onChange
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: TuyuSpacing.s6) {
                ForEach(categories) { category in
                    Button(action: {
                        HapticFeedback.light()
                        withAnimation(.easeInOut(duration: 0.2)) {
                            current = category.id
                        }
                        onChange(category.id)
                    }) {
                        VStack(spacing: 6) {
                            Text(category.name)
                                .font(current == category.id ? TuyuTypography.lg : TuyuTypography.md)
                                .fontWeight(current == category.id ? .semibold : .regular)
                                .foregroundColor(current == category.id ? TuyuColors.fg : TuyuColors.muted)

                            Rectangle()
                                .fill(current == category.id ? TuyuColors.accent : Color.clear)
                                .frame(width: 20, height: 2)
                                .clipShape(Capsule())
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, TuyuSpacing.s4)
        }
        .frame(height: 44)
        .background(TuyuColors.bg)
    }
}
