import Fluent
import Vapor

func routes(_ app: Application) throws {

    // 1
    let colorsController = ColorsController()
    // 2
    try app.register(collection: colorsController)
}
