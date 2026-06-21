import Foundation

public enum APIError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case serverError(code: Int, message: String)
    case taskFailed(String)

    public var errorDescription: String? {
        switch self {
        case .invalidURL: return "无效的 URL"
        case .networkError(let error): return "网络错误：\(error.localizedDescription)"
        case .decodingError: return "数据解析失败"
        case .serverError(_, let message): return message
        case .taskFailed(let message): return message
        }
    }
}

public actor APIClient {
    public static let shared = APIClient()

    private let baseURL: URL
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    public init(baseURL: URL = URL(string: "https://api.tuyu.com/v1")!) {
        self.baseURL = baseURL

        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: config)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        self.decoder = decoder

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        self.encoder = encoder
    }

    // MARK: - Generic Request

    private func sendRequest<R: Codable>(
        path: String,
        method: String = "GET",
        body: Data? = nil,
        query: [String: String]? = nil
    ) async throws -> R {
        var components = URLComponents(
            url: baseURL.appendingPathComponent(path),
            resolvingAgainstBaseURL: false
        )!

        if let query = query {
            components.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        }

        guard let url = components.url else {
            throw APIError.invalidURL
        }

        var req = URLRequest(url: url)
        req.httpMethod = method
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("application/json", forHTTPHeaderField: "Accept")

        if let body = body {
            req.httpBody = body
        }

        do {
            let (data, response) = try await session.data(for: req)
            guard let http = response as? HTTPURLResponse else {
                throw APIError.networkError(NSError(domain: "API", code: -1))
            }

            let apiResponse = try decoder.decode(APIResponse<R>.self, from: data)

            if apiResponse.code != 0 {
                throw APIError.serverError(code: apiResponse.code, message: apiResponse.message)
            }

            guard let data = apiResponse.data else {
                throw APIError.taskFailed("Empty response data")
            }
            return data
        } catch let error as APIError {
            throw error
        } catch let error as DecodingError {
            throw APIError.decodingError(error)
        } catch {
            throw APIError.networkError(error)
        }
    }

    // MARK: - Template APIs

    public func getCategories() async throws -> [Category] {
        let data: CategoryListData = try await sendRequest(path: "templates/categories")
        return data.categories
    }

    public func getTemplates(category: String? = nil) async throws -> [Template] {
        var query: [String: String] = [:]
        if let category = category, category != "recommend" {
            query["category"] = category
        }
        let data: TemplateListData = try await sendRequest(
            path: "templates/list",
            query: query.isEmpty ? nil : query
        )
        return data.templates
    }

    public func getTemplate(id: String) async throws -> Template {
        struct Response: Codable { let template: Template }
        let data: Response = try await sendRequest(
            path: "templates/detail",
            query: ["id": id]
        )
        return data.template
    }

    // MARK: - Upload APIs

    public func getUploadToken() async throws -> String {
        struct Response: Codable { let token: String; let expiresAt: Date }
        let data: Response = try await sendRequest(path: "upload/token")
        return data.token
    }

    public func uploadCallback(imageUrl: String) async throws {
        struct Body: Codable { let imageUrl: String }
        struct Response: Codable { let ok: Bool }
        let _: Response = try await sendRequest(
            path: "upload/callback",
            method: "POST",
            body: try encoder.encode(Body(imageUrl: imageUrl))
        )
    }

    // MARK: - Task APIs

    public func createTask(templateId: String, imageUrl: String, options: [String: String] = [:]) async throws -> String {
        struct Body: Codable {
            let templateId: String
            let imageUrl: String
            let options: [String: String]
        }
        struct Response: Codable { let taskId: String; let status: String; let estimatedTime: Int; let createdAt: Date }
        let data: Response = try await sendRequest(
            path: "tasks/create",
            method: "POST",
            body: try encoder.encode(Body(templateId: templateId, imageUrl: imageUrl, options: options))
        )
        return data.taskId
    }

    public func getTaskStatus(taskId: String) async throws -> GenerationTask {
        struct Response: Codable { let task: GenerationTask }
        let data: Response = try await sendRequest(
            path: "tasks/status",
            query: ["task_id": taskId]
        )
        return data.task
    }

    public func cancelTask(taskId: String) async throws {
        struct Body: Codable { let taskId: String }
        let _: EmptyResponse = try await sendRequest(
            path: "tasks/cancel",
            method: "POST",
            body: try encoder.encode(Body(taskId: taskId))
        )
    }

    // MARK: - Work APIs

    public func getWorks(page: Int = 1, size: Int = 20) async throws -> [Work] {
        let data: PaginatedResponse<Work> = try await sendRequest(
            path: "works/list",
            query: ["page": "\(page)", "size": "\(size)"]
        )
        return data.items
    }

    public func getWork(id: String) async throws -> Work {
        struct Response: Codable { let work: Work }
        let data: Response = try await sendRequest(
            path: "works/detail",
            query: ["id": id]
        )
        return data.work
    }

    public func deleteWork(id: String) async throws {
        let _: EmptyResponse = try await sendRequest(
            path: "works/detail",
            method: "DELETE",
            query: ["id": id]
        )
    }

    // MARK: - Favorite APIs

    public func getFavorites() async throws -> [Favorite] {
        struct Response: Codable { let total: Int; let favorites: [Favorite] }
        let data: Response = try await sendRequest(path: "favorites/list")
        return data.favorites
    }

    public func addFavorite(templateId: String) async throws {
        struct Body: Codable { let templateId: String }
        let _: EmptyResponse = try await sendRequest(
            path: "favorites/add",
            method: "POST",
            body: try encoder.encode(Body(templateId: templateId))
        )
    }

    public func removeFavorite(templateId: String) async throws {
        struct Body: Codable { let templateId: String }
        let _: EmptyResponse = try await sendRequest(
            path: "favorites/remove",
            method: "POST",
            body: try encoder.encode(Body(templateId: templateId))
        )
    }
}

public struct EmptyResponse: Codable {}

public struct EmptyBody: Codable {}

public struct Favorite: Codable, Identifiable, Hashable {
    public var id: String { templateId }
    public let templateId: String
    public let templateName: String
    public let templateCover: String
    public let favoritedAt: Date
}
