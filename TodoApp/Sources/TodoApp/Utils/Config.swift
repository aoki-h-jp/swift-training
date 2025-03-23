import Foundation

// アプリケーション全体の設定を管理するクラス
struct Config {
    // Supabase接続情報
    struct Supabase {
        static var url: URL {
            // 環境変数からSupabase URLを取得
            // 実際のアプリでは、Info.plistや環境変数から取得することも考慮
            if let urlString = ProcessInfo.processInfo.environment["SUPABASE_URL"],
               let url = URL(string: urlString) {
                return url
            }
            
            // 開発用のデフォルト値（実際のプロジェクトでは本番URLに置き換える）
            // この値は環境変数が設定されていない場合のフォールバック
            #if DEBUG
            return URL(string: "https://your-project-id.supabase.co")!
            #else
            fatalError("Supabase URLが設定されていません")
            #endif
        }
        
        static var apiKey: String {
            // 環境変数からSupabase API Keyを取得
            if let apiKey = ProcessInfo.processInfo.environment["SUPABASE_API_KEY"] {
                return apiKey
            }
            
            // 開発用のデフォルト値（実際のプロジェクトでは環境変数から取得する）
            #if DEBUG
            return "your-supabase-anon-key"
            #else
            fatalError("Supabase APIキーが設定されていません")
            #endif
        }
    }
    
    // アプリ全体の設定
    struct App {
        // アプリバージョン
        static var version: String {
            return "1.0.0"
        }
        
        // アプリ名
        static let name = "TODOアプリ"
    }
}
