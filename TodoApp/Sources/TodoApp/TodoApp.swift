import SwiftUI

// SwiftUI アプリケーションのエントリーポイント
@main
struct TodoApp: App {
    // アプリ内で共有する環境値（環境オブジェクト）
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var todoViewModel = TodoViewModel()
    
    var body: some Scene {
        WindowGroup {
            // 認証をスキップして直接ContentViewを表示
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(todoViewModel)
                .onAppear {
                    // アプリ起動時に自動ログイン
                    if !authViewModel.isAuthenticated {
                        authViewModel.autoLogin()
                    }
                }
        }
    }
}
