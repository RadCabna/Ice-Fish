import Foundation

struct CatchRecord: Identifiable, Equatable {
    let id: UUID
    var species: String
    var weight: String
    var location: String
    var date: Date

    init(
        id: UUID = UUID(),
        species: String,
        weight: String,
        location: String,
        date: Date = Date()
    ) {
        self.id = id
        self.species = species
        self.weight = weight
        self.location = location
        self.date = date
    }
}
