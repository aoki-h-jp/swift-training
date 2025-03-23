import Foundation

// Todoモデル - Supabaseに保存されるデータモデル
struct Todo: Identifiable, Codable {
    // Supabaseテーブルのプライマリキーとして使用されるID
    let id: UUID
    
    // タイトル（必須）
    var title: String
    
    // タスクの詳細説明（オプション）
    var description: String?
    
    // 締め切り日（オプション）
    var dueDate: Date?
    
    // 完了フラグ
    var isCompleted: Bool
    
    // ユーザーID - 各タスクは特定のユーザーに属する
    var userId: String
    
    // 作成日時
    let createdAt: Date
    
    // 更新日時
    var updatedAt: Date
    
    // 新しいTodoを作成するイニシャライザ
    init(
        id: UUID = UUID(),
        title: String,
        description: String? = nil,
        dueDate: Date? = nil,
        isCompleted: Bool = false,
        userId: String,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.userId = userId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
