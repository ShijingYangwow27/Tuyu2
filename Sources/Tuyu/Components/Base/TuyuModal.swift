import SwiftUI

public enum TuyuModalType {
    case alert, confirm, sheet
}

public struct TuyuModal: View {
    public let type: TuyuModalType
    @Binding public var visible: Bool
    public let title: String?
    public let content: String?
    public let confirmText: String
    public let cancelText: String
    public let onConfirm: (() -> Void)?
    public let onCancel: (() -> Void)?

    public init(
        type: TuyuModalType = .alert,
        visible: Binding<Bool>,
        title: String? = nil,
        content: String? = nil,
        confirmText: String = "确认",
        cancelText: String = "取消",
        onConfirm: (() -> Void)? = nil,
        onCancel: (() -> Void)? = nil
    ) {
        self.type = type
        self._visible = visible
        self.title = title
        self.content = content
        self.confirmText = confirmText
        self.cancelText = cancelText
        self.onConfirm = onConfirm
        self.onCancel = onCancel
    }

    public var body: some View {
        ZStack {
            if visible {
                TuyuColors.overlay
                    .ignoresSafeArea()
                    .onTapGesture { dismiss() }
                    .transition(.opacity)

                Group {
                    switch type {
                    case .alert, .confirm:
                        alertBody
                    case .sheet:
                        sheetBody
                    }
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: visible)
    }

    private var alertBody: some View {
        VStack(spacing: TuyuSpacing.s4) {
            if let title = title {
                Text(title)
                    .font(TuyuTypography.xl)
                    .foregroundColor(TuyuColors.fg)
                    .multilineTextAlignment(.center)
            }

            if let content = content {
                Text(content)
                    .font(TuyuTypography.md)
                    .foregroundColor(TuyuColors.muted)
                    .multilineTextAlignment(.center)
            }

            HStack(spacing: TuyuSpacing.s3) {
                if type == .confirm {
                    TuyuButton(
                        type: .secondary,
                        size: .medium,
                        text: cancelText
                    ) {
                        dismiss()
                        onCancel?()
                    }
                }

                TuyuButton(
                    type: .primary,
                    size: .medium,
                    text: confirmText
                ) {
                    dismiss()
                    onConfirm?()
                }
            }
        }
        .padding(TuyuSpacing.s6)
        .frame(maxWidth: 320)
        .background(TuyuColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: TuyuRadius.lg))
        .tuyuShadow(TuyuShadow.lg)
    }

    private var sheetBody: some View {
        VStack(spacing: TuyuSpacing.s4) {
            Capsule()
                .fill(TuyuColors.border)
                .frame(width: 40, height: 4)
                .padding(.top, TuyuSpacing.s2)

            if let title = title {
                Text(title)
                    .font(TuyuTypography.xl)
                    .foregroundColor(TuyuColors.fg)
            }

            if let content = content {
                Text(content)
                    .font(TuyuTypography.md)
                    .foregroundColor(TuyuColors.muted)
            }

            Spacer()
        }
        .padding(TuyuSpacing.s4)
        .frame(maxWidth: .infinity)
        .frame(height: 280)
        .background(TuyuColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: TuyuRadius.lg))
        .frame(maxHeight: .infinity, alignment: .bottom)
    }

    private func dismiss() {
        visible = false
    }
}
