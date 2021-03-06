//
//  File.swift
//  
//
//  Created by CainLuo on 2021/5/11.
//

import Vapor
import Fluent

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get("api", "users", use: getUsers)
        routes.post("api", "register", use: register)
//        routes.post("api", "login", use: login)
    }
    
    func getUsers(_ req: Request) throws -> EventLoopFuture<[UsersModel]> {
        UsersModel.query(on: req.db).all()
    }
    
    func register(_ req: Request) throws -> EventLoopFuture<UsersModel> {
        let user = try req.content.decode(UsersModel.self)
        return user.save(on: req.db).map { user }
    }
    
//    func login(_ req: Request) throws -> EventLoopFuture<UsersModel> {
//        let user = try req.content.decode(UsersModel.self)
//
//        return UsersModel.find(req.parameters.get("name"),
//                               on: req.db)
//            .unwrap(or: Abort(.noContent))
//    }
}
