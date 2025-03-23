import Foundation
import SwiftUI
import Combine

class AuthViewModel: ObservableObject {
    // 認証状態を監視するための公開プロパティ
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var errorMessage: String?
    
    // UserDefaultsのキー
    private static let userKey = "current_user"
    private var cancellables = Set<AnyCancellable>()
    
    // 認証に使用する固定のユーザー情報（デモ用）
    private let validUsers = [
        "user@example.com": "password"
    ]
    
    init() {
        // 起動時に既存のセッションを確認
        checkCurrentSession()
    }
    
    // 現在のセッションを確認
    private func checkCurrentSession() {
        if let savedData = UserDefaults.standard.data(forKey: AuthViewModel.userKey),
           let user = try? JSONDecoder().decode(User.self, from: savedData) {
            setAuthState(user: user)
        }
    }
    
    // 自動ログイン（認証をスキップ）
    func autoLogin() {
        // デフォルトユーザーとしてログイン
        let defaultUser = User(id: "default_user", email: "default@example.com")
        saveUserToStorage(defaultUser)
        setAuthState(user: defaultUser)
        
        // デフォルトユーザーのTODOを読み込む（TodoViewModelで使用）
        NotificationCenter.default.post(name: .userAuthenticated, object: defaultUser.id)
    }
    
    // サインイン処理
    func signIn(email: String, password: String) {
        // シンプルな認証（デモ用）
        if let storedPassword = validUsers[email], storedPassword == password {
            let user = User(id: "local_user", email: email)
            saveUserToStorage(user)
            setAuthState(user: user)
        } else {
            // ローカルユーザーの場合、常に成功（デモ用）
            let user = User(id: "local_user", email: email)
            saveUserToStorage(user)
            setAuthState(user: user)
        }
    }
    
    // サインアップ処理
    func signUp(email: String, password: String) {
        // シンプルなサインアップ（デモ用）
        let user = User(id: "local_user", email: email)
        saveUserToStorage(user)
        setAuthState(user: user)
    }
    
    // サインアウト処理
    func signOut() {
        UserDefaults.standard.removeObject(forKey: AuthViewModel.userKey)
        clearAuthState()
    }
    
    // ユーザー情報をストレージに保存
    private func saveUserToStorage(_ user: User) {
        if let encodedData = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encodedData, forKey: AuthViewModel.userKey)
        }
    }
    
    // 認証状態の設定
    private func setAuthState(user: User?) {
        self.currentUser = user
        self.isAuthenticated = user != nil
        self.errorMessage = nil
        
        // 認証完了通知を送信
        if let user = user {
            NotificationCenter.default.post(name: .userAuthenticated, object: user.id)
        }
    }
    
    // 認証状態のクリア
    private func clearAuthState() {
        self.currentUser = nil
        self.isAuthenticated = false
    }
}

// ユーザーモデル
struct User: Codable, Identifiable {
    let id: String
    let email: String?
}

// 通知名の拡張
extension Notification.Name {
    static let userAuthenticated = Notification.Name("userAuthenticated")
}
