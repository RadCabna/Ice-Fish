import SwiftUI

struct CatchFormView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = CatchFormViewModel()
    let onSave: (CatchRecord) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: screenHeight * 0.024) {
                header

                VStack(spacing: screenHeight * 0.02) {
                    AppTextField(
                        title: "Species",
                        placeholder: "e.g. Perch, Pike",
                        text: $viewModel.species
                    )

                    AppTextField(
                        title: "Weight",
                        placeholder: "e.g. 1.2 kg",
                        text: $viewModel.weight,
                        keyboardType: .decimalPad
                    )

                    AppTextField(
                        title: "Location",
                        placeholder: "e.g. North Bay",
                        text: $viewModel.location
                    )
                }
            }
            .padding(.horizontal, screenWidth * 0.051)
            .padding(.top, screenHeight * 0.02)
            .padding(.bottom, screenHeight * 0.04)
        }
        .navigationTitle("New Catch")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
                .font(.system(size: screenHeight * 0.02))
            }

            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    save()
                }
                .font(.system(size: screenHeight * 0.02, weight: .semibold))
                .disabled(!viewModel.canSave)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.009) {
            Text("Catch Details")
                .font(.system(size: screenHeight * 0.026, weight: .semibold))

            Text("Required fields are marked by validation on save.")
                .font(.system(size: screenHeight * 0.018))
                .foregroundStyle(.secondary)
        }
        .padding(.bottom, screenHeight * 0.008)
    }

    private func save() {
        guard let record = viewModel.makeRecord() else { return }
        onSave(record)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        CatchFormView { _ in }
    }
}
