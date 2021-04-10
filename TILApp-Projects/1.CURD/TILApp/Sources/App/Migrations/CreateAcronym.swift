//
//  File.swift
//  
//
//  Created by CainLuo on 2021/3/21.
//

import Fluent
// 1
struct CreateAcronym: Migration {
    // 2
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        // 3
        database.schema("acronyms")
            // 4
            .id()
            // 5
            .field("short", .string, .required)
            .field("long", .string, .required)
            // 6
            .create()
    }
    // 7
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("acronyms").delete()
    }
}
