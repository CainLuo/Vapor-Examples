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
        acronymsRoutes.get("search", use: searchMultipleHandler)
        // 6
        acronymsRoutes.get("first", use: getFirstHandler)
        // 7
        acronymsRoutes.get("sorted", use: sortedHandler)
    }
    
    /// 获取所有的Acronyms
    /// - Parameter req: Request
    /// - Returns: [Acronym]
    func getAllHandler(_ req: Request) throws -> EventLoopFuture<[Acronym]> {
        Acronym.query(on: req.db).all()
    }
    
    /// 创建Acronyms
    /// - Parameter req: Request
    /// - Returns: Acronym
    func createHandler(_ req: Request) throws -> EventLoopFuture<Acronym> {
        let acronym = try req.content.decode(Acronym.self)
        return acronym.save(on: req.db).map { acronym }
    }
    
    /// 根据指定acronymID的获取Acronym
    /// - Parameter req: Request
    /// - Returns: Acronym
    func getHandler(_ req: Request) throws -> EventLoopFuture<Acronym> {
        Acronym.find(req.parameters.get("acronymID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    /// 根据指定的acronymID更新Acronym
    /// - Parameter req: Request
    /// - Returns: Acronym
    func updateHandler(_ req: Request) throws -> EventLoopFuture<Acronym> {
        let updatedAcronym = try req.content.decode(Acronym.self)
        return Acronym.find(
            req.parameters.get("acronymID"),
            on: req.db)
            .unwrap(or: Abort(.notFound)).flatMap { acronym in
                acronym.short = updatedAcronym.short
                acronym.long = updatedAcronym.long
                return acronym.save(on: req.db).map {
                    acronym
                }
            }
    }
    
    /// 根据acronymID删除对应的Acronym
    /// - Parameter req: Request
    /// - Returns: HTTPStatus
    func deleteHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Acronym.find(req.parameters.get("acronymID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { acronym in
                acronym.delete(on: req.db)
                    .transform(to: .noContent)
            }
    }
    
    /// 根据输入的内容搜索随影的Acronym，比如：OMG
    /// - Parameter req: Request
    /// - Returns: [Acronym]
    func searchHandler(_ req: Request) throws -> EventLoopFuture<[Acronym]> {
        guard let searchTerm = req.query[String.self, at: "term"] else {
            throw Abort(.badRequest)
        }
        return Acronym.query(on: req.db)
            .filter(\.$short == searchTerm)
            .all()
    }
    
    /// 根据输入的内容搜索对应的Acronym，比如：Oh+My+God
    /// - Parameter req: Request
    /// - Returns: [Acronym]
    func searchMultipleHandler(_ req: Request) throws -> EventLoopFuture<[Acronym]> {
        guard let searchTerm = req
                .query[String.self, at: "term"] else {
            throw Abort(.badRequest)
        }
        return Acronym.query(on: req.db)
            .group(.or) { or in
                or.filter(\.$short == searchTerm)
                or.filter(\.$long == searchTerm)
            }
            .all()
    }
    
    /// 获取第一个Acronym
    /// - Parameter req: Request
    /// - Returns: Acronym
    func getFirstHandler(_ req: Request) throws -> EventLoopFuture<Acronym> {
        return Acronym.query(on: req.db)
            .first()
            .unwrap(or: Abort(.notFound))
    }
    
    /// 获取sorted排序的[Acronym]
    /// - Parameter req: Request
    /// - Returns: [Acronym]
    func sortedHandler(_ req: Request) throws -> EventLoopFuture<[Acronym]> {
        return Acronym.query(on: req.db)
            .sort(\.$short, .ascending).all()
    }
}
