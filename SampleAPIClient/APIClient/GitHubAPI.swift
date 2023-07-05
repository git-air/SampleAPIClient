//
//  GitHubAPI.swift
//  SampleAPIClient
//
//  Created by AIR on 2023/07/04.
//

import Foundation

/// 型 A か型 B のどちらかのオブジェクトを表す型。
/// たとえば、Either<String, Int> は文字列か整数のどちらかを意味する。
/// なお、慣例的にどちらの型かを左右で表現することが多い。
enum Either<Left, Right> {
    /// Eigher<A, B> の A の方の型。
    case left(Left)
    
    /// Eigher<A, B> の B の方の型。
    case right(Right)
    
    
    /// もし、左側の型ならその値を、右側の型なら nil を返す。
    var left: Left? {
        switch self {
        case let .left(x):
            return x
            
        case .right:
            return nil
        }
    }
    
    /// もし、右側の型ならその値を、左側の型なら nil を返す。
    var right: Right? {
        switch self {
        case .left:
            return nil
            
        case let .right(x):
            return x
        }
    }
}

struct GitHubZen {
    let text: String
    
    
    static func from(response: Response) -> Either<TransformError, GitHubZen> {
        switch response.statusCode {
        case .ok:
            // HTTP ステータスが OK だったら、ペイロードの中身を確認する。
            // Zen API は UTF-8 で符号化された文字列を返すはずので Data を UTF-8 として
            // 解釈してみる。
            guard let string = String(data: response.payload, encoding: .utf8) else {
                // もし、Data が UTF-8 の文字列でなければ、誤って画像などを受信してしまったのかもしれない。。
                // この場合は、malformedData エラーを返す（エラーの型は左なので .left を使う）。
                return .left(.malformedData(debugInfo: "not UTF-8 string"))
            }
            
            // もし、内容を UTF-8 で符号化された文字列として読み取れたなら、
            // その文字列から GitHubZen を作って返す（エラーではない型は右なので .right を使う）
            return .right(GitHubZen(text: string))
            
        default:
            // もし、HTTP ステータスコードが OK 以外であれば、エラーとして扱う。
            // たとえば、GitHub API を呼び出しすぎたときは 200 OK ではなく 403 Forbidden が
            // 返るのでこちらにくる。
            return .left(.unexpectedStatusCode(
                // エラーの内容がわかりやすいようにステータスコードを入れて返す。
                debugInfo: "\(response.statusCode)")
            )
        }
    }
    
    
    /// GitHub Zen API で起きうるエラーの一覧。
    enum TransformError {
        /// ペイロードが壊れた文字列だった場合のエラー。
        case malformedData(debugInfo: String)
        
        /// HTTP ステータスコードが OK 以外だった場合のエラー。
        case unexpectedStatusCode(debugInfo: String)
    }
}
