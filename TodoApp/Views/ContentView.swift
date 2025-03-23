import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var todoViewModel: TodoViewModel
    @State private var showingAddTodo = false
    
    var body: some View {
        NavigationView {
            ZStack {
                #if os(iOS)
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()
                #else
                Color(.windowBackgroundColor)
                    .ignoresSafeArea()
                #endif
                
                VStack(spacing: 12) {
                    // フィルターセグメントコントロール
                    Picker("フィルター", selection: $todoViewModel.currentFilter) {
                        Text("すべて").tag(TodoFilter.all)
                        Text("未完了").tag(TodoFilter.active)
                        Text("完了").tag(TodoFilter.completed)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    // Todoリスト
                    TodoListView(
                        todos: todoViewModel.filteredTodos,
                        onToggleCompletion: { todo in
                            todoViewModel.toggleTodoCompletion(todo)
                        },
                        onDelete: { todo in
                            todoViewModel.deleteTodo(todo)
                        }
                    )
                }
                
                // ロード中の表示
                if todoViewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        #if os(iOS)
                        .background(Color(UIColor.systemBackground).opacity(0.8))
                        #else
                        .background(Color.white.opacity(0.8))
                        #endif
                        .frame(width: 80, height: 80)
                        .cornerRadius(10)
                }
                
                // エラーメッセージ
                if let errorMessage = todoViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                        .padding()
                        .transition(.move(edge: .top))
                }
            }
            // ナビゲーションタイトルとツールバー
            .navigationTitle("TODOリスト")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            #endif
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddTodo = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
                #else
                ToolbarItem {
                    Button(action: {
                        showingAddTodo = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
                #endif
            }
            .sheet(isPresented: $showingAddTodo) {
                TodoFormView(
                    mode: .create,
                    onSave: { title, description, dueDate in
                        let newTodo = Todo(
                            title: title,
                            description: description,
                            dueDate: dueDate,
                            userId: "default_user"
                        )
                        
                        todoViewModel.addTodo(newTodo)
                    }
                )
            }
        }
        #if os(iOS)
        .navigationViewStyle(StackNavigationViewStyle())
        #endif
    }
}
