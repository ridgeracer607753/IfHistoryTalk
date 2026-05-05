import SwiftUI

struct LayoutConstants {
    static let horizontalPadding: CGFloat = 20
    static let verticalPadding: CGFloat = 16
    static let cornerRadius: CGFloat = 12
    static let buttonHeight: CGFloat = 54
    static let spacingSmall: CGFloat = 8
    static let spacingMedium: CGFloat = 16
    static let spacingLarge: CGFloat = 24
}

enum AppColor {
    static let primary = Color("PrimaryColor") // Assets에 추가 필요
    static let secondary = Color("SecondaryColor")
    static let background = Color("BackgroundColor")
    static let surface = Color("SurfaceColor")
    static let error = Color.red
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .frame(height: LayoutConstants.buttonHeight)
            .background(AppColor.primary)
            .foregroundColor(.white)
            .cornerRadius(LayoutConstants.cornerRadius)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct RoundedTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(AppColor.surface)
            .cornerRadius(LayoutConstants.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: LayoutConstants.cornerRadius)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
    }
}

extension View {
    func roundedTextField() -> some View {
        self.modifier(RoundedTextFieldModifier())
    }
}
