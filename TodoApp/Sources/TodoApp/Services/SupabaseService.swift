// このファイルはTODOアプリの将来的なSupabase連携に備えてダミー実装のままで保存しています
// 現在はアプリ内ストレージのみを使用するため、このファイル自体は使用されていません

import Foundation

// ダミーのSupabaseサービス（将来的な実装のためのプレースホルダー）
class SupabaseService {
    // シングルトンインスタンス
    static let shared = SupabaseService()
    
    private init() {}
    
    // ダミーメソッド - サインイン
    func signIn(email: String, password: String) async throws -> User {
        return User(id: "dummy_id", email: email)
    }
    
    // ダミーメソッド - サインアップ
    func signUp(email: String, password: String) async throws -> User {
        return User(id: "dummy_id", email: email)
    }
    
    // ダミーメソッド - サインアウト
    func signOut() async throws {
        // 何もしない
    }
    
    // ダミーメソッド - 現在のセッションを取得
    func getCurrentSession() async throws -> User {
        throw NSError(domain: "SupabaseService", code: 401, userInfo: [NSLocalizedDescriptionKey: "No active session"])
    }
    
    // ダミーメソッド - Todoを取得
    func fetchTodos(for userId: String) async throws -> [Todo] {
        return []
    }
    
    // ダミーメソッド - Todoを追加
    func addTodo(_ todo: Todo) async throws -> Todo {
        return todo
    }
    
    // ダミーメソッド - Todoを更新
    func updateTodo(_ todo: Todo) async throws -> Todo {
        return todo
    }
    
    // ダミーメソッド - Todoを削除
    func deleteTodo(id: UUID) async throws {
        // 何もしない
    }
}
