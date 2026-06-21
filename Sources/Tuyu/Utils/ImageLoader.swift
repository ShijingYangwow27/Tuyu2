import Foundation
import UIKit

public enum ImageLoader {
    /// 加载远程图片（异步、缓存）
    public static func load(_ urlString: String) async -> UIImage? {
        // 1. 内存缓存
        if let cached = memoryCache.object(forKey: urlString as NSString) {
            return cached
        }

        // 2. 沙盒缓存
        if let diskImage = loadFromDisk(urlString: urlString) {
            memoryCache.setObject(diskImage, forKey: urlString as NSString)
            return diskImage
        }

        // 3. 网络请求
        guard let url = URL(string: urlString) else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }

            memoryCache.setObject(image, forKey: urlString as NSString)
            saveToDisk(data: data, urlString: urlString)
            return image
        } catch {
            return nil
        }
    }

    private static let memoryCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 200
        cache.totalCostLimit = 100 * 1024 * 1024  // 100MB
        return cache
    }()

    private static func diskCacheURL(for urlString: String) -> URL? {
        let hash = urlString.data(using: .utf8)?.base64EncodedString() ?? urlString
        return cacheDirectory()?.appendingPathComponent(hash.replacingOccurrences(of: "/", with: "_"))
    }

    private static func cacheDirectory() -> URL? {
        try? FileManager.default.url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
    }

    private static func loadFromDisk(urlString: String) -> UIImage? {
        guard let url = diskCacheURL(for: urlString),
              let data = try? Data(contentsOf: url) else {
            return nil
        }
        return UIImage(data: data)
    }

    private static func saveToDisk(data: Data, urlString: String) {
        guard let url = diskCacheURL(for: urlString) else { return }
        try? data.write(to: url)
    }
}

public extension UIImage {
    /// 生成本地占位图（带文字的彩色卡片）
    static func placeholder(template: Template, size: CGSize = CGSize(width: 300, height: 400)) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            // 背景渐变
            let colors = gradientColors(for: template.category.id)
            let cgColors = colors.map { $0.cgColor } as CFArray
            let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: cgColors,
                locations: [0, 1]
            )!

            context.cgContext.drawLinearGradient(
                gradient,
                start: .zero,
                end: CGPoint(x: size.width, y: size.height),
                options: []
            )

            // 文字
            let text = template.name
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 24),
                .foregroundColor: UIColor.white
            ]
            let textSize = text.size(withAttributes: attrs)
            let textRect = CGRect(
                x: (size.width - textSize.width) / 2,
                y: (size.height - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )
            text.draw(in: textRect, withAttributes: attrs)
        }
    }

    private static func gradientColors(for categoryId: String) -> [UIColor] {
        switch categoryId {
        case "portrait": return [UIColor(red: 0.39, green: 0.40, blue: 0.95, alpha: 1), UIColor(red: 0.55, green: 0.36, blue: 0.96, alpha: 1)]
        case "product": return [UIColor(red: 0.06, green: 0.73, blue: 0.51, alpha: 1), UIColor(red: 0.02, green: 0.59, blue: 0.41, alpha: 1)]
        case "scene": return [UIColor(red: 0.06, green: 0.71, blue: 0.83, alpha: 1), UIColor(red: 0.01, green: 0.45, blue: 0.65, alpha: 1)]
        case "festival": return [UIColor(red: 0.93, green: 0.27, blue: 0.60, alpha: 1), UIColor(red: 0.86, green: 0.21, blue: 0.27, alpha: 1)]
        case "id": return [UIColor(red: 0.20, green: 0.60, blue: 0.86, alpha: 1), UIColor(red: 0.10, green: 0.40, blue: 0.66, alpha: 1)]
        case "repair": return [UIColor(red: 0.96, green: 0.62, blue: 0.04, alpha: 1), UIColor(red: 0.83, green: 0.32, blue: 0.07, alpha: 1)]
        default: return [UIColor.gray, UIColor.darkGray]
        }
    }
}
