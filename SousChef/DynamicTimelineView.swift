import SwiftUI

struct TimelineSegment {
  let duration: TimeInterval   // in seconds
  let color: Color
}

struct DynamicTimelineView: View {
  let recipe: Recipe
  
  // Calculate startTime from recipe.createdAt
  private var startTime: Date {
    recipe.createdAt
  }
  
  // Calculate segments from recipe.activeTimeMinutes and recipe.passiveTimeMinutes
  private var segments: [TimelineSegment] {
    [
      TimelineSegment(duration: TimeInterval(recipe.activeTimeMinutes * 60), color: .blue),
      TimelineSegment(duration: TimeInterval(recipe.passiveTimeMinutes * 60), color: .purple)
    ]
  }
  
  // total duration in seconds
  private var totalDuration: TimeInterval {
    segments.reduce(0) { $0 + $1.duration }
  }
  
  // computed end time
  private var endTime: Date {
    startTime.addingTimeInterval(totalDuration)
  }
  
  // markerTime is startTime + activeTime duration
  private var markerTime: Date {
    startTime.addingTimeInterval(TimeInterval(recipe.activeTimeMinutes * 60))
  }
  
  // rewardPoints (set to 3 as before)
  private var rewardPoints: Int? {
    3
  }
  
  // DateFormatter for “h:mm a”
  private static let timeFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "h:mm a"
    df.timeZone = .current
    return df
  }()
  
  var body: some View {
    VStack(spacing: 16) {
      if segments.count == 2 {
        HStack {
          Text("Active (\(Int(segments[0].duration / 60)) min)")
            .font(.caption.weight(.semibold))
            .foregroundColor(segments[0].color)
          Spacer()
          Text("Rest (\(Int(segments[1].duration / 60)) min)")
            .font(.caption.weight(.semibold))
            .foregroundColor(segments[1].color)
        }
      }
      
      Text("Total Time: \(Int(totalDuration / 60)) min")
        .font(.caption.weight(.semibold))
        .foregroundColor(.secondary)
      
      // — timeline bar + marker overlay —
      GeometryReader { geo in
        ZStack {
          // 1) Base pill
          Capsule()
            .fill(Color(.systemGray6))
            .frame(height: 24)
          
          // 2) Colored segments
          HStack(spacing: 0) {
            ForEach(Array(segments.enumerated()), id: \.offset) { idx, seg in
              let fraction = seg.duration / totalDuration
              seg.color
                .frame(width: geo.size.width * fraction, height: 24)
            }
          }
          .clipShape(Capsule())
          
          // 3) Vertical marker line
          let markerOffset = CGFloat(markerTime.timeIntervalSince(startTime) / totalDuration) * geo.size.width
          Path { path in
            path.move(to: CGPoint(x: markerOffset, y: 0))
            path.addLine(to: CGPoint(x: markerOffset, y: 24))
          }
          .stroke(style: StrokeStyle(lineWidth: 2, dash: [4,4]))
          .foregroundColor(.blue)
          
          // 4) Marker “thumb”
          Circle()
            .fill(.blue)
            .frame(width: 8, height: 8)
            .position(x: markerOffset, y: 12)
        }
      }
      .frame(height: 24)
      
      // — time labels under bar —
      HStack {
        Text("Now: \(Self.timeFormatter.string(from: Date()))")
        Spacer()
        Text("End: \(Self.timeFormatter.string(from: endTime))")
      }
      .font(.caption.monospaced())
      .foregroundColor(.secondary)
      
      // — dashed divider —
      Divider()
        .background(.secondary)
        .overlay(
          // dash overlay
          GeometryReader { geo in
            Path { path in
              path.move(to: .zero)
              path.addLine(to: CGPoint(x: geo.size.width, y: 0))
            }
            .stroke(style: StrokeStyle(lineWidth: 1, dash: [4,4]))
            .foregroundColor(.secondary)
          }
        )
        .frame(height: 1)
      
      // — optional reward row —
      Text("Difficulty: \(recipe.metadata.difficultyLevel)")
        .font(.subheadline.weight(.medium))
    }
    .padding()
  }
}
