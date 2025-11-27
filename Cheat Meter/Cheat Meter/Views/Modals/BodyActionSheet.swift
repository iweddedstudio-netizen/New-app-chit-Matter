import SwiftUI

struct BodyActionSheet: View {
    @Binding var isPresented: Bool
    let onRecordWeight: () -> Void
    let onRecordMeasurements: () -> Void

    var body: some View {
        ZStack {
            // Backdrop
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeOut(duration: AppAnimation.fast)) {
                        isPresented = false
                    }
                }

            // Bottom Sheet
            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: AppSpacing.md) {
                    // Handle
                    RoundedRectangle(cornerRadius: 2.5)
                        .fill(Color(white: 0.4))
                        .frame(width: 40, height: 5)
                        .padding(.top, AppSpacing.sm)

                    // Title
                    Text("What do you want to record?")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.top, AppSpacing.xs)

                    // Options
                    VStack(spacing: AppSpacing.sm) {
                        ActionRowButton(
                            icon: "scalemass.fill",
                            title: "Record Weight",
                            iconColor: AppColors.accent
                        ) {
                            withAnimation(.easeOut(duration: AppAnimation.fast)) {
                                isPresented = false
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                onRecordWeight()
                            }
                        }

                        ActionRowButton(
                            icon: "ruler.fill",
                            title: "Record Measurements",
                            iconColor: AppColors.accent
                        ) {
                            withAnimation(.easeOut(duration: AppAnimation.fast)) {
                                isPresented = false
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                onRecordMeasurements()
                            }
                        }
                    }
                    .padding(.horizontal, AppSpacing.lg)

                    // Cancel
                    Button {
                        withAnimation(.easeOut(duration: AppAnimation.fast)) {
                            isPresented = false
                        }
                    } label: {
                        Text("Cancel")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                            .padding(.vertical, AppSpacing.sm)
                    }
                    .padding(.bottom, AppSpacing.xs)
                }
                .frame(maxWidth: .infinity)
                .background(AppColors.secondaryBackground)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.xxl))
                .padding(.horizontal, AppSpacing.xs)
                .padding(.bottom, AppSpacing.xs)
            }
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }
}

#Preview {
    ZStack {
        AppColors.background
            .ignoresSafeArea()

        BodyActionSheet(
            isPresented: .constant(true),
            onRecordWeight: {},
            onRecordMeasurements: {}
        )
    }
    .preferredColorScheme(.dark)
}
