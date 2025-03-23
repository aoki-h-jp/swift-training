import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct TodoListView: View {
    // 表示するTodoリスト
    let todos: [Todo]
    
    // 完了状態切り替えとタスク削除のコールバック
    let onToggleCompletion: (Todo) -> Void
    let onDelete: (Todo) -> Void
    
    var body: some View {
        List {
            if todos.isEmpty {
                // タスクがない場合のプレースホルダー
                Text("タスクがありません")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    #if os(iOS)
                    .listRowBackground(Color(UIColor.systemGroupedBackground))
                    #else
                    .listRowBackground(Color(.windowBackgroundColor))
                    #endif
            } else {
                // タスクのリスト表示
                ForEach(todos) { todo in
                    TodoRow(
                        todo: todo,
                        onToggleCompletion: onToggleCompletion,
                        onDelete: onDelete
                    )
                    #if os(iOS)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            withAnimation {
                                onDelete(todo)
                            }
                        } label: {
                            Label("削除", systemImage: "trash")
                        }
                    }
                    #endif
                }
            }
        }
        #if os(iOS)
        .listStyle(InsetGroupedListStyle())
        #else
        .listStyle(.inset)
        #endif
    }
}

// 行区切り線非表示のための互換性修飾子
struct HideRowSeparatorModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(macOS 13.0, iOS 16.0, *) {
            content
                .listRowSeparator(.hidden)
        } else {
            content
        }
    }
}

// タスク行の表示コンポーネント
struct TodoRow: View {
    let todo: Todo
    let onToggleCompletion: (Todo) -> Void
    let onDelete: (Todo) -> Void
    
    // 日付フォーマッター
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }()
    
    var body: some View {
        HStack(spacing: 12) {
            // 完了チェックボックス
            Button(action: {
                withAnimation {
                    onToggleCompletion(todo)
                }
            }) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(todo.isCompleted ? .green : .gray)
                    .font(.title2)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            // タスク内容
            VStack(alignment: .leading, spacing: 4) {
                Text(todo.title)
                    .font(.headline)
                    .foregroundColor(todo.isCompleted ? .gray : .primary)
                    .strikethrough(todo.isCompleted)
                
                if let description = todo.description, !description.isEmpty {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                // 期限日の表示
                if let dueDate = todo.dueDate {
                    HStack {
                        Image(systemName: "calendar")
                            .font(.caption)
                        Text("期限: \(dateFormatter.string(from: dueDate))")
                            .font(.caption)
                    }
                    .foregroundColor(isOverdue(date: dueDate) ? .red : .blue)
                    .padding(.top, 2)
                }
            }
            
            Spacer()
            
            // 編集ボタン
            Button(action: {}) {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding(.vertical, 8)
    }
    
    // 期限切れの判定
    private func isOverdue(date: Date) -> Bool {
        return date < Date() && !todo.isCompleted
    }
}
