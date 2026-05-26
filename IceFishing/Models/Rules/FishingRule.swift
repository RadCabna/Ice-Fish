import SwiftUI

struct FishingRule: Identifiable {
    let id: String
    let iconName: String
    let iconColor: Color
    let title: String
    let description: String

    static let winterRules: [FishingRule] = [
        FishingRule(
            id: "protect",
            iconName: "protectIcon",
            iconColor: Color(red: 0.35, green: 0.65, blue: 1.0),
            title: "Protect The Bank",
            description: "Always set a stop-loss before drilling. Never fish without limits."
        ),
        FishingRule(
            id: "tooLong",
            iconName: "tooLongIcon",
            iconColor: Color(red: 1.0, green: 0.55, blue: 0.2),
            title: "Don't Stay Too Long",
            description: "Sessions over 30 minutes reduce focus. Take breaks between fishing trips."
        ),
        FishingRule(
            id: "change",
            iconName: "changeIcon",
            iconColor: Color(red: 0.35, green: 0.75, blue: 1.0),
            title: "Change The Hole",
            description: "If frost reaches 80%, end your session. A frozen mind makes poor decisions."
        ),
        FishingRule(
            id: "losses",
            iconName: "lossesIcon",
            iconColor: Color(red: 1.0, green: 0.35, blue: 0.35),
            title: "Don't Chase Losses",
            description: "Accept the loss and walk away. Tomorrow's ice will be clearer."
        ),
        FishingRule(
            id: "secure",
            iconName: "secureIcon",
            iconColor: Color(red: 0.35, green: 0.9, blue: 0.55),
            title: "Secure Your Catch",
            description: "Hit your take-profit goal? Reel out and celebrate responsibly."
        )
    ]
}

struct ResponsiblePlayItem: Identifiable {
    let id: String
    let label: String
    let text: String

    static let items: [ResponsiblePlayItem] = [
        ResponsiblePlayItem(
            id: "gambling",
            label: "Gambling Risk Warning:",
            text: "Gambling involves financial risk. Only fish with money you can afford to lose."
        ),
        ResponsiblePlayItem(
            id: "loss",
            label: "Loss Warning:",
            text: "The majority of sessions may result in losses. This is a session tracker, not a guarantee of profit."
        ),
        ResponsiblePlayItem(
            id: "emotional",
            label: "Emotional Control:",
            text: "If you feel frustrated, anxious, or compelled to keep fishing despite losses, stop immediately."
        ),
        ResponsiblePlayItem(
            id: "breaks",
            label: "Break Recommendations:",
            text: "Take at least a 10-minute break between sessions. Long continuous play increases risk."
        ),
        ResponsiblePlayItem(
            id: "support",
            label: "Support Resources:",
            text: "If you need help with gambling issues, contact support organizations in your region."
        )
    ]
}

struct RulesNotificationItem: Identifiable {
    let id: String
    let title: String
    let subtitle: String

    static let items: [RulesNotificationItem] = [
        RulesNotificationItem(
            id: "sessionReminders",
            title: "Session Reminders",
            subtitle: "Remind when approaching limits"
        ),
        RulesNotificationItem(
            id: "breakReminders",
            title: "Break Reminders",
            subtitle: "Suggest breaks after sessions"
        ),
        RulesNotificationItem(
            id: "responsibleQuotes",
            title: "Responsible Play Quotes",
            subtitle: "Daily mindful fishing reminders"
        )
    ]
}
