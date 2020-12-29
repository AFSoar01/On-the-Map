//
//  PutLocationResponse.swift
//  On the Map
//
//  Created by John Fowler on 12/26/20.
//

import Foundation

struct PutLocationResponse: Codable {
    var updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case updatedAt = "updatedAt"
    }
}

//struct PostLocationResponse: Codable {
//    var createdAt: String
//    var objectId: String
//
//    enum CodingKeys: String, CodingKey {
//        case createdAt = "createdAt"
//        case objectId = "objectId"
//    }
//}
