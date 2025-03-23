import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                
                // アプリロゴ
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                
                Text("TODOアプリ")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
                
                // 入力フォーム
                VStack(spacing: 15) {
                    TextField("メールアドレス", text: $email)
                        .disableAutocorrection(true)
                        #if os(iOS)
                        .textInputAutocapitalization(.never)
                        #endif
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    
                    SecureField("パスワード", text: $password)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    
                    // ログイン/登録ボタン
                    Button(action: {
                        if isSignUp {
                            authViewModel.signUp(email: email, password: password)
                        } else {
                            authViewModel.signIn(email: email, password: password)
                        }
                    }) {
                        Text(isSignUp ? "アカウント登録" : "ログイン")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .disabled(email.isEmpty || password.isEmpty)
                    .opacity(email.isEmpty || password.isEmpty ? 0.6 : 1)
                }
                .padding(.horizontal)
                
                // 切り替えボタン
                Button(action: {
                    isSignUp.toggle()
                }) {
                    Text(isSignUp ? "アカウントをお持ちの方はこちら" : "アカウントをお持ちでない方はこちら")
                        .foregroundColor(.blue)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("TODOアプリ")
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("エラー"),
                    message: Text(authViewModel.errorMessage ?? "不明なエラーが発生しました"),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onChange(of: authViewModel.errorMessage) { newValue in
                showAlert = newValue != nil
            }
        }
    }
}
