// Modularizing RecipeEquipmentSection from RecipeDetailView.swift
import SwiftUI

struct RecipeEquipmentSection: View {
    let allEquipmentNeeded: [String]
    let columns: [GridItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "wrench.and.screwdriver.fill")
                    .foregroundColor(.accentColor)
                Text("Equipment Needed")
                    .font(.title3.bold())
            }
            HStack {
                LazyVGrid(columns: columns) {
                    ForEach(allEquipmentNeeded, id: \.self) { equipment in
                        EquipmentChipView(equipment: equipment)
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
