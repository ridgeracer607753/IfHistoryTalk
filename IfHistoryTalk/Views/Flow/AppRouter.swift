import SwiftUI
import Combine

enum AppRoute: Hashable {
    case splash
    case home
    case detail(postId: String)
}

class AppRouter: ObservableObject {
    @Published var path = NavigationPath()
    
    func push(_ route: AppRoute) {
        path.append(route)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}
