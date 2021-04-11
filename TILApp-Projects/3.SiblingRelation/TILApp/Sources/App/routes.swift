import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    let acronymsController = AcronymsController()
    try app.register(collection: acronymsController)
    
    // 1
    let usersController = UsersController()
    // 2
    try app.register(collection: usersController)
    
    let categoriesController = CategoriesController()
    try app.register(collection: categoriesController)
}
