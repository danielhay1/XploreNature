//
//  Place.swift
//  Xplore nature
//
//  Created by user196210 on 6/30/21.
//

import Foundation
import CoreLocation

var xplore_counter = 0
public enum XPLORE_TYPE : Int {
    case nature_trip,park,wellspring,observation
}

class Xplore : Codable{
    var id: Int
    var name: String = "NA"
    var date: String
    var img: String = "NA"
    var type: Int = 0
    var desc: String = "NA"
    var ArrivalInstructions: String = "NA"
    var lat: Double = 0
    var lon: Double = 0
    
    init() {
        self.id = xplore_counter
        self.date = Date().getTodayString()
        xplore_counter += 1
    }
    
    init(name: String?, type: Int?, img: String?, desc: String? , ArrivalInstructions: String?, lat: Double?, lon: Double?) {
        self.id = xplore_counter
        self.name = name ?? "NA"
        self.type = type ?? 0
        self.img = img ?? "NA"
        self.desc = desc ?? "NA"
        self.ArrivalInstructions = ArrivalInstructions ?? "NA"
        self.date = Date().getTodayString()
        self.setLocation(lat: lat,lon: lon)
        xplore_counter += 1
    }
    
    func getXploreType() -> XPLORE_TYPE! {
        return XPLORE_TYPE(rawValue: XPLORE_TYPE.RawValue(self.type))
    }
    
    func setLocation(lat : Double?, lon : Double?) {
        if(lat == nil) {
            self.lat = 0
        }
        if(lon == nil) {
            self.lon = 0
        }
        self.lat = lat ?? 0
        self.lon = lon ?? 0
        print("\(self.type): \(self.name)\t location: \(printLocation())")
    }
    
    private func printLocation() -> String{
        var strLat = "NA"
        var strLon = "NA"
        strLat = "\(String(describing: self.lat))"
        strLon = "\(String(describing: self.lon))"
        return "[\(strLat),\(strLon)]"
    }
    
    public var description: String {
        return "\(String(describing: getXploreType())):{\nname: \(String(describing: name))\ndate: \(self.date)\nimg: \(String(describing: img)), location:[\(printLocation())]"
    }
    func calcDistance(user: User, xplore: Xplore) -> Double {
        //calc distance between user location and Xplore location
        // TODO: check how to create comparator and use this function to compate 2 xplores by distance from player.
        if user.lat != 0 || user.lon != 0 {
            let userCoordinate = CLLocation(latitude: user.lat, longitude: user.lon)
            let xploreCoordinate =  CLLocation(latitude: xplore.lat, longitude: xplore.lon)
            return xploreCoordinate.distance(from: userCoordinate) // result is in meters
        } else {
            return -1
        }
    }
}
    
