import Foundation

struct URLValidator {
    static let supportedDomains = [
        "allrecipes.com",
        "foodnetwork.com",
        "delish.com",
        "epicurious.com",
        "bonappetitmag.com",
        "seriouseats.com",
        "recipetins.com",
        "tasteofhome.com",
        "bbcgoodfood.com",
        "budgetbytes.com"
    ]
    
    static func isValidURL(_ urlString: String) -> (isValid: Bool, error: String?) {
        let trimmedURL = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedURL.isEmpty else {
            return (false, "URL cannot be empty")
        }
        
        guard let url = URL(string: trimmedURL), URLComponents(string: trimmedURL) != nil else {
            return (false, "Invalid URL format")
        }
        
        guard url.scheme != nil && (url.scheme == "http" || url.scheme == "https") else {
            return (false, "URL must start with http:// or https://")
        }
        
        guard let host = url.host else {
            return (false, "URL must have a valid domain")
        }
        
        return (true, nil)
    }
}
