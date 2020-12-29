//
//  SessionIdResponse.swift
//  On the Map
//
//  Created by John Fowler on 12/15/20.
//

import Foundation

struct sessionIdResponse: Codable {

    let account: account
    let session: session

}

struct account: Codable {
    let registered: Bool
    //Account: Key is the UserID
    let key: String
}

struct session: Codable {
    let id: String
    let expiration: String
}



