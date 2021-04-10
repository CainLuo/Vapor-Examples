//
//  File.swift
//  
//
//  Created by CainLuo on 2021/3/21.
//

import Vapor
import Fluent

struct AcronymsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        //        routes.get("api", "acronyms", use: getAllHandler)
        
        let acronymsRoutes = routes.grouped("api", "acronyms")
        acronymsRoutes.get(use: getAllHandler)
        
        // 1
        acronymsRoutes.post(use: createHandler)
        // 2
        acronymsRoutes.get(":acronymID", use: getHandler)
        // 3
        acronymsRoutes.put(":acronymID", use: updateHandler)
        // 4
        acronymsRoutes.delete(":acronymID", use: deleteHandler)
        // 5
        acronymsRoutes.get("search", use: searchHandler)
        // 6
        acronymsRoutes.get("first", use: getFirstHandler)
        // 7
        acronymsRoutes.get("sorted", use: sortedHandler)
    }
    
    func getAllHandler(_ req: Request) throws
    -> EventLoopFuture<[Acronym]> {
        Acronym.query(on: req.db).all()
    }
    
    func createHandler(_ req: Request) throws
    -> EventLoopFuture<Acronym> {
        let acronym = try req.content.decode(Acronym.self)
        return acronym.save(on: req.db).map { acronym }
        
//        // 1
//        let data = try req.content.decode(CreateAcronymData.self)
//        // 2
//        let acronym = Acronym(
//            short: data.short,
//            long: data.long,
//            userID: data.userID)
//        return acronym.save(on: req.db).map { acronym }
    }
    
    func getHandler(_ req: Request) throws
    -> EventLoopFuture<Acronym> {
        Acronym.find(req.parameters.get("acronymID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
//    func updateHandler(_ req: Request) throws
//    -> EventLoopFuture<Acronym> {
//        let updatedAcronym = try req.content.decode(Acronym.self)
//        return Acronym.find(
//            req.parameters.get("acronymID"),
//            on: req.db)
//            .unwrap(or: Abort(.notFound)).flatMap { acronym in
//                acronym.short = updatedAcronym.short
//                acronym.long = updatedAcronym.long
//                return acronym.save(on: req.db).map {
//                    acronym
//                }
//            }
//    }
    
    func updateHandler(_ req: Request) throws
    -> EventLoopFuture<Acronym> {
        let updateData =
            try req.content.decode(CreateAcronymData.self)
        return Acronym
            .find(req.parameters.get("acronymID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { acronym in
                acronym.short = updateData.short
                acronym.long = updateData.long
                acronym.$user.id = updateData.userID
                return acronym.save(on: req.db).map {
                    acronym
                }
            }
    }
    
    func deleteHandler(_ req: Request) throws
    -> EventLoopFuture<HTTPStatus> {
        Acronym.find(req.parameters.get("acronymID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { acronym in
                acronym.delete(on: req.db)
                    .transform(to: .noContent)
            }
    }
    
    func searchHandler(_ req: Request) throws
    -> EventLoopFuture<[Acronym]> {
        guard let searchTerm = req
                .query[String.self, at: "term"] else {
            throw Abort(.badRequest)
        }
        return Acronym.query(on: req.db).group(.or) { or in
            or.filter(\.$short == searchTerm)
            or.filter(\.$long == searchTerm)
        }.all()
    }
    
    func getFirstHandler(_ req: Request) throws
    -> EventLoopFuture<Acronym> {
        return Acronym.query(on: req.db)
            .first()
            .unwrap(or: Abort(.notFound))
    }
    
    func sortedHandler(_ req: Request) throws
    -> EventLoopFuture<[Acronym]> {
        return Acronym.query(on: req.db)
            .sort(\.$short, .ascending).all()
    }
}

struct CreateAcronymData: Content {
    let short: String
    let long: String
    let userID: UUID
}
