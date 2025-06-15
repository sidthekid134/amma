// Modularizing RecipeEquipmentSection from RecipeDetailView.swift
import SwiftUI

struct RecipeEquipmentSection: View {
    let allEquipmentNeeded: [String]
    let columns: [GridItem]
    @State private var isExpanded = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button(action: { isExpanded.toggle() }) {
                HStack(spacing: 8) {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .foregroundColor(.accentColor)
                        .imageScale(.medium)
                    Text("Equipment Needed")
                        .font(.title3.bold())
                        .foregroundColor(.accentColor)
                    Spacer()
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            if isExpanded {
                HStack {
                    LazyVGrid(columns: columns) {
                        ForEach(allEquipmentNeeded, id: \.self) { equipment in
                            EquipmentChipView(equipment: equipment)
                        }
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }
}
