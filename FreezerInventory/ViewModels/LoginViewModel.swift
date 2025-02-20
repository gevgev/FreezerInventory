import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isLoggedIn = false
    
    private var validationPublisher: AnyPublisher<ValidationState, Never> {
        Publishers.CombineLatest($email, $password)
            .map { email, password in
                if email.isEmpty || password.isEmpty {
                    return .invalid("Please fill in all fields")
                }
                if !email.isValidEmail {
                    return .invalid("Please enter a valid email")
                }
                if !password.isValidPassword {
                    return .invalid("Password must be at least 8 characters with 1 uppercase, 1 number, and 1 special character")
                }
                return .valid
            }
            .eraseToAnyPublisher()
    }
    
    enum ValidationState {
        case valid
        case invalid(String)
    }
    
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
            
            DispatchQueue.main.async {
                AuthenticationManager.shared.saveUserSession(token: response.token, user: response.user)
                self.isLoggedIn = true
                self.isLoading = false
            }
            
        } catch let error as APIError {
            DispatchQueue.main.async {
                switch error {
                case .unauthorized:
                    self.errorMessage = "Invalid email or password"
                case .serverError(let message):
                    self.errorMessage = "Server error: \(message)"
                default:
                    self.errorMessage = "An error occurred. Please try again."
                }
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}

// Email validation extension
extension String {
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$&*])(?=.*[a-z]).{8,}$"
        let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: self)
    }
}

struct AuthResponse: Codable {
    let token: String
    let user: User
} 