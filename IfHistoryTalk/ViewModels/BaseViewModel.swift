import Foundation
import Combine

@MainActor
class BaseViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // 취소 가능한 작업들을 관리하여 메모리 누수 방지
    private var tasks: [Task<Void, Never>] = []
    
    @MainActor
    func showLoading() {
        isLoading = true
    }
    
    @MainActor
    func hideLoading() {
        isLoading = false
    }
    
    @MainActor
    func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        HapticManager.shared.play(.error)
    }
    
    func addTask(_ task: Task<Void, Never>) {
        tasks.append(task)
    }
    
    func cancelAllTasks() {
        tasks.forEach { $0.cancel() }
        tasks.removeAll()
    }
    
    deinit {
        cancelAllTasks()
    }
}
