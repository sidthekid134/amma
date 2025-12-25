import Foundation

enum FetchError: LocalizedError {
    case invalidURL
    case networkError(String)
    case timeoutError
    case invalidResponse
    case emptyContent
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL format is invalid. Please check and try again."
        case .networkError(let message):
            return "Network error: \(message). Please check your connection."
        case .timeoutError:
            return "The request took too long. Please try again or paste the content manually."
        case .invalidResponse:
            return "The server response was invalid. Please try another URL."
        case .emptyContent:
            return "No content was found at this URL. Please try another recipe site."
        }
    }
}

actor RecipeContentFetcher {
    private let session: URLSession
    private let timeout: TimeInterval = 10.0
    
    nonisolated private static let shared = RecipeContentFetcher()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    nonisolated static func fetchContent(from urlString: String) async throws -> String {
        return try await shared.fetch(from: urlString)
    }
    
    private func fetch(from urlString: String) async throws -> String {
        guard let url = URL(string: urlString) else {
            throw FetchError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = timeout
        request.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15", forHTTPHeaderField: "User-Agent")
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw FetchError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw FetchError.networkError("HTTP \(httpResponse.statusCode)")
            }
            
            guard let htmlContent = String(data: data, encoding: .utf8), !htmlContent.isEmpty else {
                throw FetchError.emptyContent
            }
            
            return htmlContent
        } catch let error as FetchError {
            throw error
        } catch is CancellationError {
            throw FetchError.timeoutError
        } catch let error as URLError {
            switch error.code {
            case .timedOut:
                throw FetchError.timeoutError
            case .notConnectedToInternet, .networkConnectionLost:
                throw FetchError.networkError("No internet connection")
            default:
                throw FetchError.networkError(error.localizedDescription)
            }
        } catch {
            throw FetchError.networkError(error.localizedDescription)
        }
    }
}
