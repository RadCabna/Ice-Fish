import SwiftUI

struct JournalFilterBar: View {
    @Binding var selectedFilter: JournalFilter

    private let activeFill = Color(red: 0.18, green: 0.62, blue: 0.88)
    private let activeGlow = Color(red: 0.35, green: 0.88, blue: 1.0)

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: screenWidth * 0.028) {
                ForEach(JournalFilter.allCases) { filter in
                    filterButton(for: filter)
                }
            }
            .padding(.horizontal, screenWidth * 0.05)
        }
    }

    private func filterButton(for filter: JournalFilter) -> some View {
        let isSelected = selectedFilter == filter

        return Button {
            selectedFilter = filter
        } label: {
            Text(filter.title)
                .font(.system(size: screenHeight * 0.015, weight: .medium))
                .foregroundStyle(.white.opacity(isSelected ? 1 : 0.75))
                .padding(.horizontal, screenWidth * 0.05)
                .padding(.vertical, screenHeight * 0.011)
                .background {
                    Capsule(style: .continuous)
                        .fill(isSelected ? activeFill : Color.white.opacity(0.08))
                }
                .overlay {
                    Capsule(style: .continuous)
                        .stroke(
                            isSelected ? activeGlow.opacity(0.85) : Color.white.opacity(0.14),
                            lineWidth: isSelected ? screenHeight * 0.0018 : screenHeight * 0.0012
                        )
                }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    @Previewable @State var filter: JournalFilter = .all

    JournalFilterBar(selectedFilter: $filter)
        .mainBackground()
}
