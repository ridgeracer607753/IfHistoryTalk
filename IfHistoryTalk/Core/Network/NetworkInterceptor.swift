import Foundation

protocol NetworkInterceptor {
    func adapt(_ request: URLRequest) -> URLRequest
    func retry(_ request: URLRequest, dueTo error: Error) async -> Bool
}

class AuthInterceptor: NetworkInterceptor {
    func adapt(_ request: URLRequest) -> URLRequest {
        var request = request
        // TODO: 키체인 등에서 토큰을 가져와 주입
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
    func retry(_ request: URLRequest, dueTo error: Error) async -> Bool {
        if let networkError = error as? NetworkError {
            if case .unauthorized = networkError {
                // TODO: Refresh Token 로직 구현
                return await refreshToken()
            }
        }
        return false
    }
    
    private func refreshToken() async -> Bool {
        // 실제 토큰 갱신 로직 구현부
        return false
    }
}

enum NetworkError: Error {
    case invalidURL
    case badResponse
    case unauthorized
    case decodingError
    case serverError(String)
    case unknown
}
