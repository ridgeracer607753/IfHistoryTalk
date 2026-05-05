import Foundation

struct Post: Codable, Identifiable {
    let id: String
    let title: String
    let content: String
    let author: String
    let createdAt: Date
}

struct Comment: Codable, Identifiable {
    let id: String
    let content: String
    let author: String
    let createdAt: Date
}
