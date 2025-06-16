import Foundation
import SwiftData

@Model
final class SavedImageRecord: Identifiable {
    @Attribute(.unique) var key: String
    var imageData: Data    // Store the image as Data; you could use a file URL if images are large
    var createdAt: Date
    
    init(key: String, imageData: Data, createdAt: Date = Date()) {
        self.key = key
        self.imageData = imageData
        self.createdAt = createdAt
    }
    
    func matchesFuzzy(_ input: String) -> Bool {
        let lowerKey = key.lowercased()
        let lowerInput = input.lowercased()
        if lowerKey.contains(lowerInput) {
            return true
        }
        // Levenshtein distance threshold: 2
        return levenshteinDistance(lowerKey, lowerInput) <= 2
    }
    
    static func fuzzyMatch(in records: [SavedImageRecord], input: String) -> [SavedImageRecord] {
        records.filter { $0.matchesFuzzy(input) }
    }
}

// Classic Levenshtein Distance implementation
func levenshteinDistance(_ lhs: String, _ rhs: String) -> Int {
    let lhs = Array(lhs)
    let rhs = Array(rhs)
    let empty = [Int](repeating: 0, count: rhs.count + 1)
    var last = [Int](0...rhs.count)
    
    for (i, l) in lhs.enumerated() {
        var cur = [i + 1] + empty
        for (j, r) in rhs.enumerated() {
            cur[j + 1] = l == r ? last[j] : min(last[j], last[j + 1], cur[j]) + 1
        }
        last = cur
    }
    return last.last!
}
