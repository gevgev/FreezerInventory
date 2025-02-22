import Foundation

@MainActor
class AuthenticationManager: ObservableObject {
    static let shared = AuthenticationManager()
    
    private let tokenKey = "authToken"
    private let userKey = "currentUser"
    
    @Published private(set) var currentUser: User?
    @Published var isAuthenticated = false
    
    init() {
        loadSavedSession()
    }
    
    var token: String? {
        get { UserDefaults.standard.string(forKey: tokenKey) }
        set {
            if let token = newValue {
                UserDefaults.standard.set(token, forKey: tokenKey)
                isAuthenticated = true
            } else {
                UserDefaults.standard.removeObject(forKey: tokenKey)
                isAuthenticated = false
            }
        }
    }
    
    func saveUserSession(token: String, user: User) {
        self.token = token
        self.currentUser = user
        self.isAuthenticated = true
        if let userData = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(userData, forKey: userKey)
        }
    }
    
    func clearSession() {
        self.token = nil
        self.currentUser = nil
        self.isAuthenticated = false
        UserDefaults.standard.removeObject(forKey: userKey)
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
    
    func loadSavedSession() {
        if let token = token,
           let userData = UserDefaults.standard.data(forKey: userKey),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            self.currentUser = user
            self.isAuthenticated = true
        } else {
            clearSession()
        }
    }
    
    func handleUnauthorized() {
        clearSession()
    }
} 
