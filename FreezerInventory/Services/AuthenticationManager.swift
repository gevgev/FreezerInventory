import Foundation

@MainActor
class AuthenticationManager: ObservableObject {
    static let shared = AuthenticationManager()
    
    private let tokenKey = "authToken"
    private let userKey = "currentUser"
    
    @Published private(set) var currentUser: User?
    
    var token: String? {
        get { UserDefaults.standard.string(forKey: tokenKey) }
        set {
            if let token = newValue {
                UserDefaults.standard.set(token, forKey: tokenKey)
            } else {
                UserDefaults.standard.removeObject(forKey: tokenKey)
            }
        }
    }
    
    func saveUserSession(token: String, user: User) {
        self.token = token
        self.currentUser = user
        if let userData = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(userData, forKey: userKey)
        }
    }
    
    func clearSession() {
        self.token = nil
        self.currentUser = nil
        UserDefaults.standard.removeObject(forKey: userKey)
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
    
    func loadSavedSession() {
        if let userData = UserDefaults.standard.data(forKey: userKey),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            self.currentUser = user
        }
    }
} 
