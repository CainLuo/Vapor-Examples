//
//  File.swift
//  
//
//  Created by CainLuo on 2021/4/11.
//

import Fluent
// 1
struct CreateAcronymCategoryPivot: Migration {
    // 2
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        // 3
        database.schema("acronym-category-pivot")
            // 4
            .id()
            // 5
            .field("acronymID",
                   .uuid,
                   .required,
                   .references("acronyms", "id", onDelete: .cascade))
            .field("categoryID",
                   .uuid,
                   .required,
                   .references("categories", "id", onDelete: .cascade))
            // 6
            .create()
    }
    
    // 7
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("acronym-category-pivot").delete()
    }
}
