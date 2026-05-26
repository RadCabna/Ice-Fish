import Foundation

enum SessionRoute: Hashable {
    case live
    case complete(SessionSummary)
}
