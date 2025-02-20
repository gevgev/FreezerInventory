import Foundation

enum APIError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
    case unauthorized
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to process the server response"
        case .serverError(let message):
            return message
        case .unauthorized:
            return "Please log in again"
        }
    }
}

class APIClient {
    static let shared = APIClient()
    private let baseURL = "http://localhost:8080"
    
    func request<T: Codable>(endpoint: String,
                            method: String = "GET",
                            body: Data? = nil) async throws -> T {
        print("Making request to: \(baseURL)\(endpoint)")  // Debug print
        
        guard let url = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = await AuthenticationManager.shared.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = body
            // Debug print the request body
            if let jsonString = String(data: body, encoding: .utf8) {
                print("Request body: \(jsonString)")
            }
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Debug print the response
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Response: \(jsonString)")
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.serverError("Invalid response")
        }
        
        print("Response status code: \(httpResponse.statusCode)")  // Debug print
        
        switch httpResponse.statusCode {
        case 200...299:
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .useDefaultKeys // or .convertFromSnakeCase if needed
                return try decoder.decode(T.self, from: data)
            } catch {
                print("Decoding error: \(error)")
                print("Failed to decode: \(String(describing: try? JSONSerialization.jsonObject(with: data)))")
                throw APIError.decodingError
            }
        case 401:
            await MainActor.run {
                AuthenticationManager.shared.clearSession()
            }
            throw APIError.unauthorized
        case 404:
            throw APIError.serverError("Resource not found")
        default:
            throw APIError.serverError("Server error: \(httpResponse.statusCode)")
        }
    }
} 
