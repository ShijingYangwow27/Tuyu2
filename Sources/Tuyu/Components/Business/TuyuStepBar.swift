import SwiftUI

public struct TuyuStepBar: View {
    public let steps: [String]
    public let current: Int

    public init(steps: [String], current: Int) {
        self.steps = steps
        self.current = current
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                stepItem(index: index, label: step)
                if index < steps.count - 1 {
                    Rectangle()
                        .fill(index < current ? TuyuColors.accent : TuyuColors.border)
                        .frame(height: 1)
                }
            }
        }
        .padding(.horizontal, TuyuSpacing.s6)
    }

    private func stepItem(index: Int, label: String) -> some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(index <= current ? TuyuColors.accent : TuyuColors.border)
                    .frame(width: 28, height: 28)

                if index < current {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                } else {
                    Text("\(index + 1)")
                        .font(TuyuTypography.sm)
                        .foregroundColor(index == current ? .white : TuyuColors.muted)
                }
            }

            Text(label)
                .font(TuyuTypography.xs)
                .foregroundColor(index <= current ? TuyuColors.fg : TuyuColors.muted)
        }
    }
}
