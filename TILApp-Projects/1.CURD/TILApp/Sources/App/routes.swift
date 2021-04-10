import Fluent
import Vapor

func routes(_ app: Application) throws {
    let acronymsController = AcronymsController()
    try app.register(collection: acronymsController)
}

// 如果有Fatal error: Error raised at top level: bind(descriptor:ptr:bytes:): Address already in use (errno: 48): file Swift/ErrorType.swift, line 200错误，在终端上使用下面的命令
// lsof -i :8080 -sTCP:LISTEN |awk 'NR > 1 {print $2}'|xargs kill -15
