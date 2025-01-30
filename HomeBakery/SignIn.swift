import SwiftUI

struct SignIn: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var users: [User] = []
    @State private var errorMessage: String?
    @State private var isLoading: Bool = false
    @AppStorage("username") private var username: String = ""
    @AppStorage("isAuthenticated") private var isAuthenticated: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Sign In")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email").font(.headline)
                    TextField("Enter your email", text: $email)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(.systemGray4), lineWidth: 1))
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Password").font(.headline)
                    HStack {
                        if isPasswordVisible {
                            TextField("Enter your password", text: $password).padding()
                        } else {
                            SecureField("Enter your password", text: $password).padding()
                        }
                        Button(action: { isPasswordVisible.toggle() }) {
                            Image(systemName: isPasswordVisible ? "eye" : "eye.slash").foregroundColor(.gray)
                        }.padding(.trailing, 10)
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(.systemGray4), lineWidth: 1))
                }
                
                if let errorMessage = errorMessage {
                    Text(errorMessage).foregroundColor(.red).font(.subheadline)
                }
                
                if isLoading {
                    ProgressView().padding()
                }
                
                Button("Sign in") {
                    Task { await signIn() }
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.primary1)
                .cornerRadius(12)
                .padding(.top)
                .disabled(email.isEmpty || password.isEmpty)
            }
            .padding()
            .task { await loadUsers() }
        }
    }
    
    func loadUsers() async {
        guard let url = URL(string: "https://api.airtable.com/v0/appXMW3ZsAddTpClm/user") else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(UserAPIResponse.self, from: data)
            self.users = response.records.map { $0.fields }
        } catch {
            print("Error fetching users: \(error)")
        }
    }
    
    func signIn() async {
        guard !users.isEmpty else {
            errorMessage = "Unable to fetch users. Please try again."
            return
        }
        
        if let user = users.first(where: { $0.email == email && $0.password == password }) {
            username = user.name
            isAuthenticated = true
            dismiss()
        } else {
            errorMessage = "Invalid email or password. Please try again."
        }
    }
}

#Preview {
    SignIn()
}
