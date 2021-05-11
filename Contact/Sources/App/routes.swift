import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    let user = UserController()

    try app.register(collection: user)
}
