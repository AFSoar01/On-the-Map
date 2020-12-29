//
//  LoginErrorResponse.swift
//  On the Map
//
//  Created by John Fowler on 12/23/20.
//

import Foundation

struct LoginErrorResponse: Codable {
    
    let status: Int
    let error: String
}
extension LoginErrorResponse: LocalizedError {
    var errorDescription: Int {
        return status
    }
}
