import SwiftUI

public struct TuyuTopBar: View {
    public let title: String?
    public let left: TuyuTopBarLeft
    public let right: TuyuTopBarRight?
    public let onBack: (() -> Void)?
    public let onSearch: (() -> Void)?
    public let onMessage: (() -> Void)?

    public enum TuyuTopBarLeft {
        case none, back, logo

        var icon: String? {
            switch self {
            case .none: return nil
            case .back: return "chevron.left"
            case .logo: return nil  // 用 Image 渲染
            }
        }
    }

    public enum TuyuTopBarRight {
        case search, message, custom(icon: String, action: () -> Void)

        var icon: String {
            switch self {
            case .search: return "magnifyingglass"
            case .message: return "bell"
            case .custom(let icon, _): return icon
            }
        }
    }

    public init(
        title: String? = nil,
        left: TuyuTopBarLeft = .none,
        right: TuyuTopBarRight? = nil,
        onBack: (() -> Void)? = nil,
        onSearch: (() -> Void)? = nil,
        onMessage: (() -> Void)? = nil
    ) {
        self.title = title
        self.left = left
        self.right = right
        self.onBack = onBack
        self.onSearch = onSearch
        self.onMessage = onMessage
    }

    public var body: some View {
        HStack(spacing: TuyuSpacing.s3) {
            // 左侧
            leftView

            Spacer()

            // 中间标题
            if let title = title {
                Text(title)
                    .font(TuyuTypography.lg)
                    .foregroundColor(TuyuColors.fg)
                    .lineLimit(1)
            }

            Spacer()

            // 右侧
            rightView
        }
        .frame(height: 44)
        .padding(.horizontal, TuyuSpacing.s4)
        .background(TuyuColors.surface)
        .overlay(
            Rectangle()
                .fill(TuyuColors.border)
                .frame(height: 0.5),
            alignment: .bottom
        )
    }

    @ViewBuilder
    private var leftView: some View {
        switch left {
        case .none:
            Color.clear.frame(width: 24, height: 24)
        case .back:
            Button(action: {
                HapticFeedback.light()
                onBack?()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(TuyuColors.fg)
                    .frame(width: 24, height: 24)
            }
        case .logo:
            HStack(spacing: TuyuSpacing.s2) {
                Image(systemName: "sparkles")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(TuyuColors.accent)
                Text("图语")
                    .font(TuyuTypography.xlBold)
                    .foregroundColor(TuyuColors.fg)
            }
        }
    }

    @ViewBuilder
    private var rightView: some View {
        if let right = right {
            HStack(spacing: TuyuSpacing.s4) {
                switch right {
                case .search:
                    Button(action: {
                        HapticFeedback.light()
                        onSearch?()
                    }) {
                        Image(systemName: right.icon)
                            .font(.system(size: 18))
                            .foregroundColor(TuyuColors.fg)
                            .frame(width: 24, height: 24)
                    }
                case .message:
                    Button(action: {
                        HapticFeedback.light()
                        onMessage?()
                    }) {
                        Image(systemName: right.icon)
                            .font(.system(size: 18))
                            .foregroundColor(TuyuColors.fg)
                            .frame(width: 24, height: 24)
                    }
                case .custom(_, let action):
                    Button(action: {
                        HapticFeedback.light()
                        action()
                    }) {
                        Image(systemName: right.icon)
                            .font(.system(size: 18))
                            .foregroundColor(TuyuColors.fg)
                            .frame(width: 24, height: 24)
                    }
                }
            }
        } else {
            Color.clear.frame(width: 24, height: 24)
        }
    }
}
