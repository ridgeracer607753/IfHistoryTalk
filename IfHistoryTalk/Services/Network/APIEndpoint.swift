import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol APIEndpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
    
    func asURLRequest() throws -> URLRequest
}

extension APIEndpoint {
    func asURLRequest() throws -> URLRequest {
        guard var urlComponents = URLComponents(string: baseURL + path) else {
            throw NetworkError.invalidURL
        }
        
        if method == .get, let parameters = parameters {
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let headers = headers {
            headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        }
        
        if method != .get, let parameters = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
}

// Sample Endpoint
enum HistoryEndpoint: APIEndpoint {
    case getPosts
    case getComments(postId: String)
    
    var baseURL: String {
        return "https://api.ifhistorytalk.com/v1" // Dummy URL
    }
    
    var path: String {
        switch self {
        case .getPosts: return "/posts"
        case .getComments(let postId): return "/posts/\(postId)/comments"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String: String]? {
        return ["Accept": "application/json"]
    }
    
    var parameters: [String: Any]? {
        return nil
    }
}
