# Swift TODOアプリ（Supabase連携）

## 概要

このプロジェクトは、Swift言語を使用したシンプルなTODOアプリケーションで、バックエンドにSupabaseを使用しています。MVVMアーキテクチャに基づいて設計されており、基本的なタスク管理機能と認証機能を提供します。

## 機能

- ユーザー認証（サインアップ/ログイン）
- タスクの作成、閲覧、編集、削除
- タスクのフィルタリング（すべて/未完了/完了）
- タスクの完了状態の切り替え
- 期限日の設定
- Supabaseとのデータ同期

## 環境構築

### 必要条件

- Swift 5.5以上
- macOS 12.0以上/iOS 15.0以上
- Supabaseアカウント

### セットアップ手順

1. **プロジェクトのクローン**

```bash
git clone <repository-url>
cd swift-training
```

2. **Supabaseのセットアップ**

Supabaseアカウントを作成し、新しいプロジェクトを作成します。その後、`supabase/schema.sql`に記載されているSQLスクリプトを実行してデータベースのテーブルを作成します。

3. **環境変数の設定**

プロジェクトのルートディレクトリに`.env`ファイルを作成し、以下の環境変数を設定します：

```bash
SUPABASE_URL=<your-supabase-url>
SUPABASE_API_KEY=<your-supabase-anon-key>
```

または、`TodoApp/Sources/TodoApp/Utils/Config.swift`ファイルを直接編集して、SupabaseのURLとAPIキーを設定します。

4. **依存関係のインストール**

```bash
cd TodoApp
swift package resolve
```

5. **ビルド実行**

```bash
swift build
swift run
```

## プロジェクト構造

```
TodoApp/
├── Sources/
│   └── TodoApp/
│       ├── Models/          # データモデル
│       ├── Views/           # UI定義
│       ├── ViewModels/      # ビジネスロジック
│       ├── Services/        # APIサービス
│       └── Utils/           # ユーティリティ
├── Package.swift            # 依存関係定義
└── README.md                # プロジェクト説明
```

## アーキテクチャ

このプロジェクトはMVVM（Model-View-ViewModel）アーキテクチャパターンを採用しています：

- **Model**: アプリケーションのデータとビジネスロジックを定義
- **View**: ユーザーインターフェースの定義
- **ViewModel**: ViewとModelの間の仲介役、UIの状態管理

## Supabase連携

Supabaseは認証とデータ保存の両方に使用しています：

- **認証**: Supabaseの認証システムを使用してユーザー登録/ログイン
- **データベース**: タスクデータの保存と取得

## 今後の改善点

- [ ] オフラインモードの実装
- [ ] タスクの共有機能
- [ ] リマインダー通知
- [ ] タグやカテゴリによるタスク整理
- [ ] UI/UXの改善

## ライセンス

このプロジェクトはMITライセンスの下で配布されています。詳細は[LICENSE](LICENSE)ファイルを参照してください。
