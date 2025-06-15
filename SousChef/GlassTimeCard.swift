import SwiftUI

@available(iOS 26.0, *)
struct GlassTimeCard: View {
    let icon: String
    let label: String
    let minutes: Int
    let color: Color
    var large: Bool = false
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: large ? 22 : 16, weight: .semibold))
            Text(label)
                .font(.caption2).bold()
                .foregroundColor(.secondary)
            Text("\(minutes) min")
                .font(large ? .headline.bold() : .subheadline.bold())
                .foregroundColor(.primary)
        }
        .padding(.horizontal, large ? 16 : 10)
        .padding(.vertical, large ? 10 : 6)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: color.opacity(0.19), radius: large ? 8 : 4, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(color.opacity(0.10), lineWidth: 1.2)
        )
        .scaleEffect(large ? 1.05 : 1.0)
    }
}
