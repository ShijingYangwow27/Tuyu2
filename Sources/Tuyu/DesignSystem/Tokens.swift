import SwiftUI

// MARK: - Colors
public enum TuyuColors {
    public static let bg = Color(red: 250/255, green: 250/255, blue: 250/255)        // #FAFAFA
    public static let surface = Color.white                                          // #FFFFFF
    public static let fg = Color(red: 17/255, green: 24/255, blue: 39/255)           // #111827
    public static let muted = Color(red: 107/255, green: 114/255, blue: 128/255)     // #6B7280
    public static let border = Color(red: 229/255, green: 231/255, blue: 235/255)    // #E5E7EB
    public static let accent = Color(red: 99/255, green: 102/255, blue: 241/255)     // #6366F1
    public static let accent2 = Color(red: 139/255, green: 92/255, blue: 246/255)    // #8B5CF6
    public static let success = Color(red: 16/255, green: 185/255, blue: 129/255)    // #10B981
    public static let warning = Color(red: 245/255, green: 158/255, blue: 11/255)    // #F59E0B
    public static let error = Color(red: 239/255, green: 68/255, blue: 68/255)       // #EF4444
    public static let overlay = Color.black.opacity(0.5)
}

// MARK: - Typography
public enum TuyuTypography {
    public static let xs = Font.system(size: 10, weight: .regular)
    public static let sm = Font.system(size: 12, weight: .regular)
    public static let md = Font.system(size: 14, weight: .regular)
    public static let lg = Font.system(size: 16, weight: .regular)
    public static let xl = Font.system(size: 18, weight: .semibold)
    public static let xlBold = Font.system(size: 18, weight: .bold)
    public static let xxl = Font.system(size: 24, weight: .bold)
    public static let xxxl = Font.system(size: 30, weight: .bold)
    public static let button = Font.system(size: 16, weight: .semibold)
    public static let buttonSmall = Font.system(size: 14, weight: .medium)
}

// MARK: - Spacing
public enum TuyuSpacing {
    public static let s1: CGFloat = 4
    public static let s2: CGFloat = 8
    public static let s3: CGFloat = 12
    public static let s4: CGFloat = 16
    public static let s5: CGFloat = 20
    public static let s6: CGFloat = 24
    public static let s8: CGFloat = 32
    public static let s10: CGFloat = 40
}

// MARK: - Radius
public enum TuyuRadius {
    public static let sm: CGFloat = 8
    public static let md: CGFloat = 12
    public static let lg: CGFloat = 16
    public static let full: CGFloat = 9999
}

// MARK: - Shadow
public struct TuyuShadow {
    public let color: Color
    public let radius: CGFloat
    public let x: CGFloat
    public let y: CGFloat

    public static let sm = TuyuShadow(color: .black.opacity(0.04), radius: 1, x: 0, y: 1)
    public static let md = TuyuShadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    public static let lg = TuyuShadow(color: .black.opacity(0.08), radius: 16, x: 0, y: 4)
}

public extension View {
    func tuyuShadow(_ shadow: TuyuShadow) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
}
