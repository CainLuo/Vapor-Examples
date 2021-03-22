import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    // MARK: Post color
    // 1
    app.post("api", "postColor") { req -> EventLoopFuture<Color> in
        // 2
        let color = try req.content.decode(Color.self)
        // 3
        return color.save(on: req.db).map {
            // 4
            color
        }
    }
    
    // MARK: Get Colors
    // 1
    app.get("api", "colors") {
        req -> EventLoopFuture<[Color]> in
        // 2
        Color.query(on: req.db).all()
    }
    
    // MARK: Get color id
    // 1
    app.get("api", "colorId", ":colorID") {
        req -> EventLoopFuture<Color> in
        // 2
        Color.find(req.parameters.get("colorID"), on: req.db)
            // 3
            .unwrap(or: Abort(.notFound))
    }
    
    // MARK: Put request
    // 1
    app.put("api", "putColor", ":colorID") {
        req -> EventLoopFuture<Color> in
        // 2
        let updatedColor = try req.content.decode(Color.self)
        return Color.find(
            req.parameters.get("colorID"),
            on: req.db)
            .unwrap(or: Abort(.notFound)).flatMap { color in
                color.name = updatedColor.name
                color.red = updatedColor.red
                color.green = updatedColor.green
                color.blue = updatedColor.blue
                return color.save(on: req.db).map {
                    color
                }
            }
    }

    // MARK: Delete request
    // 1
    app.delete("api", "deleteColor", ":colorID") {
        req -> EventLoopFuture<HTTPStatus> in
        // 2
        Color.find(req.parameters.get("colorID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            // 3
            .flatMap { color in
                // 4
                color.delete(on: req.db)
                    // 5
                    .transform(to: .noContent)
            }
    }

    // MARK: Get search color, single parameter
    // 1
    app.get("api", "colors", "search") {
        req -> EventLoopFuture<[Color]> in
        // 2
        guard let searchColor =
                req.query[String.self, at: "color"] else {
            throw Abort(.badRequest)
        }
        // 3
        return Color.query(on: req.db)
            .filter(\.$name == searchColor)
            .all()
    }
    
    // MARK: Get search color, multiple parameter
    // 1
    app.get("api", "colors", "search") {
        req -> EventLoopFuture<[Color]> in
        // 2
        guard let searchColor =
                req.query[Float.self, at: "color"] else {
            throw Abort(.badRequest)
        }
        // 1
        return Color.query(on: req.db)
            .group(.or) { or in
                // 2
                or.filter(\.$red == searchColor)
                // 3
                or.filter(\.$green == searchColor)
                // 4
                or.filter(\.$blue == searchColor)
            }
            .all()
    }
    
    // MARK: Get first color
    // 1
    app.get("api", "colors", "first") {
        req -> EventLoopFuture<Color> in
        // 2
        Color.query(on: req.db)
            .first()
            .unwrap(or: Abort(.notFound))
    }

    // MARK: Get sorted colors name
    // 1
    app.get("api", "colors", "sorted") {
        req -> EventLoopFuture<[Color]> in
        // 2
        Color.query(on: req.db)
            .sort(\.$name, .ascending)
            .all()
    }
}

