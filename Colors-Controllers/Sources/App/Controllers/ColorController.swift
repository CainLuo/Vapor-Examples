//
//  File.swift
//  
//
//  Created by YYKJ0048 on 2021/3/22.
//

import Vapor
import Fluent

struct ColorsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get("api", "colors", use: getAllHandler)
    }
    
    func getAllHandler(_ req: Request) throws
    -> EventLoopFuture<[Color]> {
        Color.query(on: req.db).all()
    }
}
