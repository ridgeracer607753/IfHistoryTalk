import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var opacity = 0.5
    @State private var size = 0.8
    
    var body: some View {
        ZStack {
            AppColor.background.ignoresSafeArea()
            
            VStack {
                Image(systemName: "scroll.fill")
                    .font(.system(size: 80))
                    .foregroundColor(AppColor.primary)
                
                Text("If History Talk")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(AppColor.textPrimary)
                    .padding(.top, 10)
            }
            .scaleEffect(size)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeIn(duration: 1.2)) {
                    self.size = 0.9
                    self.opacity = 1.0
                }
            }
        }
    }
}

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.2).ignoresSafeArea()
            
            VStack(spacing: 12) {
                ProgressView()
                    .scaleEffect(1.5)
                Text("Loading...")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(30)
            .background(AppColor.surface)
            .cornerRadius(15)
            .shadow(radius: 10)
        }
    }
}

struct ErrorView: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Retry") {
                retryAction()
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.horizontal, 40)
        }
    }
}
