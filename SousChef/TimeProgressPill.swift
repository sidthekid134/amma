import SwiftUI

@available(iOS 26.0, *)
struct TimeProgressPill: View {
    let active: Int
    let passive: Int
    var total: Int { active + passive }
    var activeRatio: CGFloat { total > 0 ? CGFloat(active) / CGFloat(total) : 0 }
    var passiveRatio: CGFloat { total > 0 ? CGFloat(passive) / CGFloat(total) : 0 }
    var body: some View {
        HStack(spacing: 0) {
            Capsule()
                .fill(Color.blue)
                .frame(width: activeRatio == 0 ? 0 : max(8, activeRatio * 220), height: 18)
                .overlay(
                    activeRatio > 0.15 ?
                      Text("Active")
                        .font(.caption2).bold()
                        .foregroundColor(.white)
                        .padding(.leading, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                      : nil
                )
            Capsule()
                .fill(Color.purple)
                .frame(width: passiveRatio == 0 ? 0 : max(8, passiveRatio * 220), height: 18)
                .overlay(
                    passiveRatio > 0.15 ?
                        Text("Passive")
                            .font(.caption2).bold()
                            .foregroundColor(.white)
                            .padding(.trailing, 8)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        : nil
                )
        }
        .frame(width: 220, height: 18)
        .background(Capsule().fill(Color(.systemGray6)))
        .overlay(
            Capsule().stroke(Color.accentColor.opacity(0.14), lineWidth: 1.1)
        )
        .shadow(color: .black.opacity(0.05), radius: 1, y: 1)
        .accessibilityLabel("Active: \(active) minutes. Passive: \(passive) minutes.")
    }
}
