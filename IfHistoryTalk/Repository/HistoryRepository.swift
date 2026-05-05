import Foundation

protocol HistoryRepository {
    func fetchPosts() async throws -> [Post]
    func fetchComments(for postId: String) async throws -> [Comment]
}

class DefaultHistoryRepository: HistoryRepository {
    @Injected private var networkService: NetworkService
    
    func fetchPosts() async throws -> [Post] {
        return try await networkService.request(HistoryEndpoint.getPosts)
    }
    
    func fetchComments(for postId: String) async throws -> [Comment] {
        return try await networkService.request(HistoryEndpoint.getComments(postId: postId))
    }
}
