//
//  User.swift
//  Xplore nature
//
//  Created by user196210 on 7/1/21.
//

import Foundation
class User : Codable{
    //var name : String
    var lat: Double = 0
    var lon: Double = 0
    init() {}
    func setLocation(lat:Double?, lon:Double?) {
        self.lat = lat ?? 0
        self.lon = lon ?? 0
        
    }
}
