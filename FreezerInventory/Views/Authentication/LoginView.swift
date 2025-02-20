import SwiftUI

struct LoginView: View {
    @StateObject var viewModel: LoginViewModel
    @Environment(\.colorScheme) var colorScheme
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email
        case password
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Spacer()
                        .frame(height: 40)
                    
                    Text("Freezer Inventory")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    VStack(spacing: 15) {
                        TextField("Email", text: $viewModel.email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textContentType(.emailAddress)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .focused($focusedField, equals: .email)
                            .disabled(viewModel.isLoading)
                            .submitLabel(.next)
                        
                        SecureField("Password", text: $viewModel.password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textContentType(.password)
                            .focused($focusedField, equals: .password)
                            .disabled(viewModel.isLoading)
                            .submitLabel(.go)
                    }
                    .padding(.horizontal)
                    
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    Button(action: {
                        Task {
                            await viewModel.login()
                        }
                    }) {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Login")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .disabled(viewModel.isLoading)
                    
                    Spacer()
                        .frame(height: 40)
                }
                .padding()
            }
            .navigationDestination(isPresented: $viewModel.isLoggedIn) {
                InventoryListView(viewModel: InventoryListViewModel())
                    .navigationBarBackButtonHidden(true)
            }
        }
        .navigationBarHidden(true)
        .onSubmit {
            switch focusedField {
            case .email:
                focusedField = .password
            case .password:
                Task {
                    await viewModel.login()
                }
            case .none:
                break
            }
        }
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel())
} 