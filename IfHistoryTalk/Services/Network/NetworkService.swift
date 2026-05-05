import Foundation

protocol NetworkService {
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T
}

class DefaultNetworkService: NetworkService {
    private let session: URLSession
    private let interceptor: NetworkInterceptor?
    
    init(session: URLSession = .shared, interceptor: NetworkInterceptor? = AuthInterceptor()) {
        self.session = session
        self.interceptor = interceptor
    }
    
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        var urlRequest = try endpoint.asURLRequest()
        
        // Intercept & Adapt
        if let interceptor = interceptor {
            urlRequest = interceptor.adapt(urlRequest)
        }
        
        // Log Request
        NetworkLogger.log(request: urlRequest)
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            
            // Log Response
            NetworkLogger.log(response: response, data: data)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.badResponse
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                do {
                    return try JSONDecoder().decode(T.self, from: data)
                } catch {
                    throw NetworkError.decodingError
                }
            case 401:
                throw NetworkError.unauthorized
            default:
                throw NetworkError.serverError("Status Code: \(httpResponse.statusCode)")
            }
        } catch {
            // Log Error
            NetworkLogger.log(error: error, url: urlRequest.url)
            
            // Retry logic
            if let interceptor = interceptor, await interceptor.retry(urlRequest, dueTo: error) {
                return try await request(endpoint)
            }
            
            throw error
        }
    }
}
