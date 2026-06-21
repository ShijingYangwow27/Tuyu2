import SwiftUI

public enum TuyuLoaderType {
    case spinner, progress, skeleton
}

public struct TuyuLoader: View {
    public let type: TuyuLoaderType
    public let text: String?
    public let progress: Double?

    @State private var rotation: Double = 0

    public init(type: TuyuLoaderType = .spinner, text: String? = nil, progress: Double? = nil) {
        self.type = type
        self.text = text
        self.progress = progress
    }

    public var body: some View {
        VStack(spacing: TuyuSpacing.s3) {
            content
            if let text = text {
                Text(text)
                    .font(TuyuTypography.sm)
                    .foregroundColor(TuyuColors.muted)
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch type {
        case .spinner:
            Image(systemName: "arrow.triangle.2.circlepath")
                .font(.system(size: 32))
                .foregroundColor(TuyuColors.accent)
                .rotationEffect(.degrees(rotation))
                .onAppear {
                    withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                        rotation = 360
                    }
                }

        case .progress:
            VStack(spacing: TuyuSpacing.s2) {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(TuyuColors.border)
                            .frame(height: 4)
                        RoundedRectangle(cornerRadius: 2)
                            .fill(TuyuColors.accent)
                            .frame(width: geo.size.width * (progress ?? 0) / 100, height: 4)
                    }
                }
                .frame(height: 4)

                if let progress = progress {
                    Text("\(Int(progress))%")
                        .font(TuyuTypography.xs)
                        .foregroundColor(TuyuColors.muted)
                }
            }

        case .skeleton:
            RoundedRectangle(cornerRadius: TuyuRadius.md)
                .fill(TuyuColors.muted.opacity(0.25))
                .frame(height: 100)
        }
    }
}
