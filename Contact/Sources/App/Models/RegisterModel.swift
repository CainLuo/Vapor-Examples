//
//  File.swift
//  
//
//  Created by YYKJ0048 on 2021/5/12.
//

import Vapor
import Fluent

final class RegisterModel: Model {

    static let schema = "users"
    @ID
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "address")
    var address: String

    init() {}

    init(id: UUID? = nil, name: String, address: String) {
        self.id = id
        self.name = name
        self.address = address
    }
}

extension UsersModel: Content {}
