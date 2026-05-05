import SwiftUI
import Combine

@MainActor
class ContentViewModel: BaseViewModel {
    @Injected private var repository: HistoryRepository
    @Published var posts: [Post] = []
    
    func fetchPosts() {
        addTask(Task {
            showLoading()
            do {
                posts = try await repository.fetchPosts()
            } catch {
                handleError(error)
            }
            hideLoading()
        })
    }
}

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        ZStack {
            List(viewModel.posts) { post in
                VStack(alignment: .leading) {
                    Text(post.title)
                        .font(.headline)
                    Text(post.content)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .onTapGesture {
                    router.push(.detail(postId: post.id))
                    HapticManager.shared.play(.selection)
                }
            }
            .navigationTitle("If History Talk")
            .toolbar {
                Button("Refresh") {
                    viewModel.fetchPosts()
                }
            }
            
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .onAppear {
            viewModel.fetchPosts()
        }
        .alert("Error", isPresented: .init(
            get: { viewModel.errorMessage != nil },
            set: { _ in viewModel.errorMessage = nil }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}
