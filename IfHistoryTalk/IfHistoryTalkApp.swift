import SwiftUI

@main
struct IfHistoryTalkApp: App {
    @StateObject private var appState = AppStateManager()
    @StateObject private var router = AppRouter()
    
    init() {
        DIContainer.shared.setup()
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch appState.currentState {
                case .splash:
                    SplashView()
                        .task {
                            await appState.checkVersionAndTransition()
                        }
                case .main:
                    NavigationStack(path: $router.path) {
                        ContentView()
                            .navigationDestination(for: AppRoute.self) { route in
                                switch route {
                                case .splash: SplashView()
                                case .home: ContentView()
                                case .detail(let postId): 
                                    Text("Post Detail: \(postId)") // Placeholder
                                }
                            }
                    }
                    .environmentObject(router)
                    .environmentObject(appState)
                case .updateRequired(let minVersion):
                    VStack(spacing: 20) {
                        Image(systemName: "arrow.clockwise.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        Text("Update Required")
                            .font(.title)
                            .bold()
                        Text("Please update to at least version \(minVersion) to continue using the app.")
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        Button("Go to App Store") {
                            // URL schemes to app store
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .padding(.horizontal, 40)
                    }
                case .onboarding:
                    Text("Onboarding")
                }
            }
        }
    }
}
