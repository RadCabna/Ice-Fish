import SwiftUI

struct CatchRowView: View {
    let record: CatchRecord

    var body: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.005) {
            Text(record.species)
                .font(.system(size: screenHeight * 0.02, weight: .semibold))

            if !record.weight.isEmpty {
                Text(record.weight)
                    .font(.system(size: screenHeight * 0.018))
                    .foregroundStyle(.secondary)
            }

            if !record.location.isEmpty {
                Label(record.location, systemImage: "mappin.and.ellipse")
                    .font(.system(size: screenHeight * 0.014))
                    .foregroundStyle(.secondary)
            }

            Text(record.date, format: .dateTime.day().month().year())
                .font(.system(size: screenHeight * 0.013))
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, screenHeight * 0.005)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    List {
        CatchRowView(
            record: CatchRecord(
                species: "Perch",
                weight: "1.2 kg",
                location: "Lake Baikal"
            )
        )
    }
}
