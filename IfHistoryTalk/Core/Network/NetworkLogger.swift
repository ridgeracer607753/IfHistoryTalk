import Foundation
import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    static let network = Logger(subsystem: subsystem, category: "Network")
    static let debug = Logger(subsystem: subsystem, category: "Debug")
    static let error = Logger(subsystem: subsystem, category: "Error")
}

struct NetworkLogger {
    static func log(request: URLRequest) {
        let url = request.url?.absoluteString ?? "Unknown URL"
        let method = request.httpMethod ?? "GET"
        let headers = request.allHTTPHeaderFields ?? [:]
        
        var bodyString = ""
        if let body = request.httpBody, let string = String(data: body, encoding: .utf8) {
            bodyString = "-d '\(string)'"
        }
        
        let headerString = headers.map { "-H '\($0): \($1)'" }.joined(separator: " ")
        let curl = "curl -v -X \(method) \(headerString) \(bodyString) '\(url)'"
        
        Logger.network.debug("🚀 [REQUEST] \(method) \(url)")
        Logger.network.debug("💻 [cURL] \(curl)")
    }
    
    static func log(response: URLResponse, data: Data?) {
        guard let httpResponse = response as? HTTPURLResponse else { return }
        let statusCode = httpResponse.statusCode
        let url = httpResponse.url?.absoluteString ?? "Unknown URL"
        
        Logger.network.debug("✅ [RESPONSE] \(statusCode) \(url)")
        
        if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []),
           let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            Logger.network.debug("📦 [DATA] \n\(prettyString)")
        }
    }
    
    static func log(error: Error, url: URL?) {
        Logger.network.error("❌ [ERROR] \(url?.absoluteString ?? "Unknown URL"): \(error.localizedDescription)")
    }
}
