import SwiftUI

@available(iOS 26.0, *)
struct EquipmentChipView: View {
    let equipment: String
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "wrench.and.screwdriver")
                .foregroundColor(.accentColor)
                .font(.system(size: 44))
                .frame(width: 56, height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.accentColor.opacity(0.10))
                )
            Text(equipment)
                .font(.subheadline).bold()
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color(.secondarySystemBackground)))
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(Color.accentColor.opacity(0.13), lineWidth: 1)
        )
        .frame(width: 140, height: 120)
    }
}
