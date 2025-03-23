import SwiftUI

// フォームの使用モード
enum TodoFormMode {
    case create // 新規作成
    case edit(Todo) // 編集
}

struct TodoFormView: View {
    // フォームモード (作成/編集)
    let mode: TodoFormMode
    
    // 保存時のコールバック
    let onSave: (String, String?, Date?) -> Void
    
    // フォーム入力値
    @State private var title = ""
    @State private var description = ""
    @State private var dueDate: Date? = nil
    @State private var hasDate = false
    
    // 画面制御
    @Environment(\.presentationMode) var presentationMode
    @State private var showingValidationError = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    // タイトル入力フィールド (必須)
                    TextField("タイトル (必須)", text: $title)
                        #if os(iOS)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        #endif
                    
                    // 説明入力フィールド (オプション)
                    TextField("説明 (オプション)", text: $description)
                        #if os(iOS)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        #endif
                } header: {
                    Text("タスク情報")
                }
                
                Section {
                    // 期限日の有無を選択するトグル
                    Toggle("期限日を設定", isOn: $hasDate)
                    
                    // 期限日が有効な場合は日付選択を表示
                    if hasDate {
                        DatePicker(
                            "期限日",
                            selection: Binding<Date>(
                                get: { dueDate ?? Date() },
                                set: { dueDate = $0 }
                            ),
                            displayedComponents: [.date]
                        )
                        #if os(iOS)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        #endif
                        .accentColor(.blue)
                    }
                } header: {
                    Text("期限設定")
                }
            }
            .navigationTitle(mode.isCreating ? "新規タスク" : "タスクを編集")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            showingValidationError = true
                        } else {
                            // 保存処理の実行
                            let finalDescription = description.isEmpty ? nil : description
                            let finalDueDate = hasDate ? dueDate : nil
                            onSave(title, finalDescription, finalDueDate)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .alert(isPresented: $showingValidationError) {
                Alert(
                    title: Text("入力エラー"),
                    message: Text("タイトルは必須です"),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onAppear {
                // 編集モードの場合、既存のデータをフォームにセット
                if case .edit(let todo) = mode {
                    title = todo.title
                    description = todo.description ?? ""
                    dueDate = todo.dueDate
                    hasDate = todo.dueDate != nil
                }
            }
        }
    }
}

// モードの拡張 - 新規作成かどうかのヘルパープロパティ
extension TodoFormMode {
    var isCreating: Bool {
        if case .create = self {
            return true
        }
        return false
    }
}
