//
//  StudentData.swift
//  On the Map
//
//  Created by John Fowler on 12/16/20.
//

import Foundation

struct StudentData: Codable {
    var results: [student]
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
    }
}

struct student: Codable {
    
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String 
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "createdAt"
        case firstName = "firstName"
        case lastName = "lastName"
        case latitude = "latitude"
        case longitude = "longitude"
        case mapString = "mapString"
        case mediaURL = "mediaURL"
        case objectId = "objectId"
        case uniqueKey = "uniqueKey"
        case updatedAt = "updatedAt"
        
    }
}

