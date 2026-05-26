import SwiftUI

struct AppConfirmationAlert: View {
    let title: String
    let message: String
    let confirmTitle: String
    let cancelTitle: String
    let isDestructive: Bool
    let onConfirm: () -> Void
    let onCancel: () -> Void

    init(
        title: String,
        message: String,
        confirmTitle: String = "Delete",
        cancelTitle: String = "Cancel",
        isDestructive: Bool = true,
        onConfirm: @escaping () -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.confirmTitle = confirmTitle
        self.cancelTitle = cancelTitle
        self.isDestructive = isDestructive
        self.onConfirm = onConfirm
        self.onCancel = onCancel
    }

    private var cornerRadius: CGFloat {
        screenHeight * 0.02
    }

    private var buttonCornerRadius: CGFloat {
        screenHeight * 0.014
    }

    private var confirmButtonFill: AnyShapeStyle {
        if isDestructive {
            return AnyShapeStyle(Color(red: 0.55, green: 0.14, blue: 0.18))
        }
        return AnyShapeStyle(
            LinearGradient(
                colors: [Color("buttonColor_1"), Color("buttonColor_2")],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
    }

    var body: some View {
        ZStack {
            Color(red: 0.02, green: 0.05, blue: 0.12).opacity(0.72)
                .ignoresSafeArea()
                .onTapGesture(perform: onCancel)

            alertCard
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .colorScheme(.dark)
        .preferredColorScheme(.dark)
        .accessibilityAddTraits(.isModal)
    }

    private var alertCard: some View {
        VStack(spacing: screenHeight * 0.02) {
            Text(title)
                .font(.system(size: screenHeight * 0.022, weight: .semibold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            Text(message)
                .font(.system(size: screenHeight * 0.016))
                .foregroundStyle(Color.white.opacity(0.6))
                .multilineTextAlignment(.center)

            HStack(spacing: screenWidth * 0.03) {
                Button(action: onCancel) {
                    Text(cancelTitle)
                        .font(.system(size: screenHeight * 0.017, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: screenHeight * 0.052)
                        .roundedPanel(
                            cornerRadius: buttonCornerRadius,
                            fill: SurfaceStyle.subtleFill,
                            stroke: Color.white.opacity(0.18),
                            lineWidth: screenHeight * 0.0012
                        )
                }
                .buttonStyle(.plain)

                Button(action: onConfirm) {
                    Text(confirmTitle)
                        .font(.system(size: screenHeight * 0.017, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: screenHeight * 0.052)
                        .background {
                            RoundedRectangle(cornerRadius: buttonCornerRadius, style: .continuous)
                                .fill(confirmButtonFill)
                        }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, screenWidth * 0.055)
        .padding(.vertical, screenHeight * 0.024)
        .frame(maxWidth: screenWidth * 0.84)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(SessionMetricStyle.fill)
        )
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(SessionMetricStyle.stroke, lineWidth: SessionMetricStyle.borderWidth)
        )
    }
}

extension View {
    func appConfirmationAlert(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        confirmTitle: String = "Delete",
        cancelTitle: String = "Cancel",
        isDestructive: Bool = true,
        onConfirm: @escaping () -> Void
    ) -> some View {
        ZStack {
            self

            if isPresented.wrappedValue {
                AppConfirmationAlert(
                    title: title,
                    message: message,
                    confirmTitle: confirmTitle,
                    cancelTitle: cancelTitle,
                    isDestructive: isDestructive,
                    onConfirm: {
                        isPresented.wrappedValue = false
                        onConfirm()
                    },
                    onCancel: {
                        isPresented.wrappedValue = false
                    }
                )
                .zIndex(999)
            }
        }
    }
}

#Preview {
    ZStack {
        MainBackground()
        Text("Journal")
            .foregroundStyle(.white)
    }
    .appConfirmationAlert(
        isPresented: .constant(true),
        title: "Delete Session?",
        message: "This session will be removed from your journal.",
        onConfirm: {}
    )
}
