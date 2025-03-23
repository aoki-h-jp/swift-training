import Foundation
import Combine
import SwiftUI

// フィルタリングオプション
enum TodoFilter {
    case all           // すべてのタスク
    case active        // 未完了のタスク
    case completed     // 完了済みのタスク
}

class TodoViewModel: ObservableObject {
    // Todoリストを管理するための公開プロパティ
    @Published var todos: [Todo] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentFilter: TodoFilter = .all
    
    // ユーザー識別子
    private var userId: String?
    private var cancellables = Set<AnyCancellable>()
    
    // UserDefaultsのキー
    private static let todosKey = "saved_todos"
    
    init(userId: String? = nil) {
        self.userId = userId
        
        // 認証通知の監視を設定
        setupAuthenticationObserver()
        
        // 初期TODOを読み込む
        if let userId = userId {
            loadTodosFromStorage()
        }
    }
    
    // 認証通知の監視を設定
    private func setupAuthenticationObserver() {
        NotificationCenter.default.publisher(for: .userAuthenticated)
            .sink { [weak self] notification in
                if let userId = notification.object as? String {
                    self?.setUserId(userId)
                }
            }
            .store(in: &cancellables)
    }
    
    // ユーザーIDを設定する
    func setUserId(_ userId: String) {
        self.userId = userId
        loadTodosFromStorage()
    }
    
    // ストレージからTodosを読み込む
    private func loadTodosFromStorage() {
        isLoading = true
        
        if let savedData = UserDefaults.standard.data(forKey: TodoViewModel.todosKey),
           let decodedTodos = try? JSONDecoder().decode([Todo].self, from: savedData) {
            // ユーザーIDが設定されている場合は、そのユーザーのTodosのみをフィルタリング
            if let userId = self.userId {
                self.todos = decodedTodos.filter { $0.userId == userId }
            } else {
                self.todos = decodedTodos
            }
        }
        
        // サンプルTODOがなければ追加
        if todos.isEmpty && userId != nil {
            addSampleTodos()
        }
        
        isLoading = false
    }
    
    // サンプルTODOを追加
    private func addSampleTodos() {
        guard let userId = userId else { return }
        
        let sampleTodos = [
            Todo(title: "買い物リストを作成する", description: "週末のパーティーの買い物リストを準備", userId: userId),
            Todo(title: "プレゼンテーションの準備", description: "次週の会議用の資料を作成", dueDate: Calendar.current.date(byAdding: .day, value: 3, to: Date()), userId: userId),
            Todo(title: "ジムに行く", description: "週3回の運動計画を継続", userId: userId)
        ]
        
        // サンプルTODOを追加
        todos.append(contentsOf: sampleTodos)
        
        // ストレージに保存
        saveTodosToStorage()
    }
    
    // ストレージにTodosを保存
    private func saveTodosToStorage() {
        // 既存のTODOを読み込む
        var allTodos: [Todo] = []
        if let savedData = UserDefaults.standard.data(forKey: TodoViewModel.todosKey),
           let decodedTodos = try? JSONDecoder().decode([Todo].self, from: savedData) {
            // 他のユーザーのTODOは保持
            if let userId = self.userId {
                allTodos = decodedTodos.filter { $0.userId != userId }
            } else {
                allTodos = decodedTodos
            }
        }
        
        // 現在のユーザーのTODOを追加
        allTodos.append(contentsOf: todos)
        
        // 保存
        if let encodedData = try? JSONEncoder().encode(allTodos) {
            UserDefaults.standard.set(encodedData, forKey: TodoViewModel.todosKey)
        }
    }
    
    // 新しいTodoを追加する
    func addTodo(_ todo: Todo) {
        guard let userId = userId else {
            errorMessage = "ユーザーIDが設定されていません"
            return
        }
        
        isLoading = true
        
        // ユーザーIDを設定して保存
        var newTodo = todo
        newTodo.userId = userId
        
        // 現在のリストに追加
        todos.insert(newTodo, at: 0)
        
        // ストレージに保存
        saveTodosToStorage()
        
        isLoading = false
    }
    
    // Todoの完了状態を切り替える
    func toggleTodoCompletion(_ todo: Todo) {
        guard !isLoading else { return }
        
        isLoading = true
        
        // Todoの完了状態を反転
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].isCompleted.toggle()
            todos[index].updatedAt = Date()
        }
        
        // ストレージに保存
        saveTodosToStorage()
        
        isLoading = false
    }
    
    // Todoを更新する
    func updateTodo(_ todo: Todo) {
        guard !isLoading else { return }
        
        isLoading = true
        
        // 既存のTodoを更新
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index] = todo
            todos[index].updatedAt = Date()
        }
        
        // ストレージに保存
        saveTodosToStorage()
        
        isLoading = false
    }
    
    // Todoを削除する
    func deleteTodo(_ todo: Todo) {
        guard !isLoading else { return }
        
        isLoading = true
        
        // リストから削除
        todos.removeAll { $0.id == todo.id }
        
        // ストレージに保存
        saveTodosToStorage()
        
        isLoading = false
    }
    
    // フィルター適用済みのTodoリスト
    var filteredTodos: [Todo] {
        switch currentFilter {
        case .all:
            return todos
        case .active:
            return todos.filter { !$0.isCompleted }
        case .completed:
            return todos.filter { $0.isCompleted }
        }
    }
}
