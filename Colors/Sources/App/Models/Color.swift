//
//  File.swift
//  
//
//  Created by YYKJ0048 on 2021/3/22.
//

import Vapor
import Fluent

// 1
final class Color: Model {
    // 2
    static let schema = "colors"
    
    // 3
    @ID
    var id: UUID?
    
    // 4
    @Field(key: "name")
    var name: String
    
    @Field(key: "red")
    var red: Float
    
    @Field(key: "green")
    var green: Float
    
    @Field(key: "blue")
    var blue: Float
    
    // 5
    init() {}
    
    // 6
    init(id: UUID? = nil, name: String, red: Float, green: Float, blue: Float) {
        self.id = id
        self.name = name
        self.red = red
        self.green = green
        self.blue = blue
    }
}

extension Color: Content {}
