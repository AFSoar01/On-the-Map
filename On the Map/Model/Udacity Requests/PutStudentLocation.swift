//
//  PutStudentLocation.swift
//  On the Map
//
//  Created by John Fowler on 12/22/20.
//

import Foundation

struct PutStudentLocation: Codable {
    var uniqueKey: String?
    var firstName: String?
    var lastName:  String?
    var mapString: String?
    var mediaURL:  String?
    var latitude:  Float?
    var longitude: Float?
}
