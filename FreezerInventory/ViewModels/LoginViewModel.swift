import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func login() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let loginData = try JSONEncoder().encode([
                "email": email,
                "password": password
            ])
            
            let response: AuthResponse = try await APIClient.shared.request(
                endpoint: "/auth/login",
                method: "POST",
                body: loginData
            )
            
            APIClient.shared.setAuthToken(response.token)
            // Handle successful login - will add navigation logic later
            
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            }
        }
        
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
}

struct AuthResponse: Codable {
    let token: String
    let user: User
} 