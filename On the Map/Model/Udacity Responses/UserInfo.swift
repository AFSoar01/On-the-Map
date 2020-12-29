//
//  UserInfo.swift
//  On the Map
//
//  Created by John Fowler on 12/20/20.
//

import Foundation

struct UserInfo: Codable {
    let firstName: String
    let lastName: String
    let mediaURL: String?
    let uniqueKey: String

    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case mediaURL = "website_url"
        case uniqueKey = "key"

    }
}
