//
//  File.swift
//  
//
//  Created by YYKJ0048 on 2021/5/12.
//

import Vapor
import Fluent

struct UserController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        routes.post("api", "register", use: register)
    }

    func register(_ req: Request) throws -> EventLoopFuture<UsersModel> {
        let user = try req.content.decode(UsersModel.self)
        return user.save(on: req.db).map { user }
    }
}
