//
//  File.swift
//  
//
//  Created by CainLuo on 2021/4/11.
//

import Vapor

// 1
struct CategoriesController: RouteCollection {
    // 2
    func boot(routes: RoutesBuilder) throws {
        // 3
        let categoriesRoute = routes.grouped("api", "categories")
        // 4
        categoriesRoute.post(use: createHandler)
        categoriesRoute.get(use: getAllHandler)
        categoriesRoute.get(":categoryID", use: getHandler)
    }
    
    // 5
    func createHandler(_ req: Request) throws -> EventLoopFuture<Category> {
        // 6
        let category = try req.content.decode(Category.self)
        return category.save(on: req.db).map { category }
    }
    
    // 7
    func getAllHandler(_ req: Request) throws -> EventLoopFuture<[Category]> {
        // 8
        Category.query(on: req.db).all()
    }
    
    // 9
    func getHandler(_ req: Request) throws -> EventLoopFuture<Category> {
        // 10
        Category.find(req.parameters.get("categoryID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    // 1
    func getAcronymsHandler(_ req: Request) throws -> EventLoopFuture<[Acronym]> {
        // 2
        Category.find(req.parameters.get("categoryID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { category in
                // 3
                category.$acronyms.get(on: req.db)
            }
    }

}
