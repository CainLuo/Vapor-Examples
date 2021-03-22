//
//  File.swift
//  
//
//  Created by YYKJ0048 on 2021/3/22.
//

import Fluent

// 1
struct CreateColor: Migration {
    // 2
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        // 3
        database.schema("colors")
            // 4
            .id()
            .field("name", .string, .required)
            .field("red", .float, .required)
            .field("green", .float, .required)
            .field("blue", .float, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("colors").delete()
    }
}
