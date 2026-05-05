import SwiftUI
import Combine

enum AppState {
    case splash
    case main
    case onboarding
    case updateRequired(minVersion: String)
}

class AppStateManager: ObservableObject {
    @Injected private var versionService: VersionCheckService
    @Published var currentState: AppState = .splash
    
    @MainActor
    func checkVersionAndTransition() async {
        let result = await versionService.checkVersion()
        
        switch result {
        case .updateRequired:
            transition(to: .updateRequired(minVersion: "2.0.0")) // 예시
        case .latest, .updateOptional:
            transition(to: .main)
        }
    }
    
    @MainActor
    func transition(to state: AppState) {
        withAnimation(.easeInOut(duration: 0.5)) {
            currentState = state
        }
    }
}
