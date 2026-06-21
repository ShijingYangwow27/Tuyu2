import Foundation

// MARK: - Template
public struct Template: Codable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let category: Category
    public let difficulty: Difficulty
    public let cover: String
    public let description: String
    public let effect: String
    public let operators: [String]
    public let prompt: String
    public let estimatedTime: Int
    public let tags: [String]
    public let isHot: Bool
    public let launchPriority: LaunchPriority
    public let order: Int

    public enum Difficulty: Int, Codable, CaseIterable {
        case easy = 1
        case medium = 2
        case hard = 3

        public var label: String {
            switch self {
            case .easy: return "入门"
            case .medium: return "进阶"
            case .hard: return "高级"
            }
        }

        public var color: String {
            switch self {
            case .easy: return "10B981"     // green
            case .medium: return "F59E0B"   // orange
            case .hard: return "EF4444"     // red
            }
        }
    }

    public enum LaunchPriority: String, Codable {
        case cold_30
        case extended_26
    }
}

// MARK: - Category
public struct Category: Codable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let icon: String
    public let order: Int
    public let count: Int?
}

// MARK: - Work
public struct Work: Codable, Identifiable, Hashable {
    public let id: String
    public let imageUrl: String
    public let thumbnailUrl: String
    public let templateId: String
    public let templateName: String
    public let createdAt: Date
}

// MARK: - Task
public struct GenerationTask: Codable, Identifiable, Hashable {
    public let id: String
    public let templateId: String
    public let imageUrl: String
    public var status: Status
    public var progress: Int
    public var estimatedRemaining: Int?
    public var result: Result?
    public var error: Error?
    public var duration: Double?

    public enum Status: String, Codable {
        case pending, processing, success, failed, cancelled
    }

    public struct Result: Codable, Hashable {
        public let workId: String
        public let imageUrl: String
        public let thumbnailUrl: String
    }

    public struct Error: Codable, Hashable {
        public let code: String
        public let message: String
    }
}

// MARK: - API Response
public struct APIResponse<T: Codable>: Codable {
    public let code: Int
    public let message: String
    public let data: T?
}

// MARK: - Pagination
public struct PaginatedResponse<T: Codable>: Codable {
    public let total: Int
    public let page: Int
    public let size: Int
    public let items: [T]
}

// MARK: - Category List Response
public struct CategoryListData: Codable {
    public let categories: [Category]
}

// MARK: - Template List Response
public struct TemplateListData: Codable {
    public let category: String
    public let total: Int
    public let templates: [Template]
}
