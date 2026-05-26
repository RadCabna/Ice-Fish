import Foundation

@MainActor
final class CatchFormViewModel: ObservableObject {
    @Published var species = ""
    @Published var weight = ""
    @Published var location = ""

    var canSave: Bool {
        !species.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func makeRecord() -> CatchRecord? {
        let trimmedSpecies = species.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedSpecies.isEmpty else { return nil }
        return CatchRecord(
            species: trimmedSpecies,
            weight: weight.trimmingCharacters(in: .whitespacesAndNewlines),
            location: location.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }
}
