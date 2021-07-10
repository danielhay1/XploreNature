//
//  myPreference.swift
//  MemoryGame
//
//  Created by user196210 on 6/2/21.
//

import Foundation
class myPreference {
    public let CURRENT_USER = "current_user"
    public let XPLORE_KEY_PREFIX = "xplore_"
    public let POST_LOCATION_LATITUDE = "post_location_latitude"
    public let POST_LOCATION_LONGITUDE = "post_location_longitude"
    public let XPLORE_COUNTER = "xplore_counter"
    // MARK: Post location fucntions:
    func savePostLocationToPreference(lat: Double, lon: Double) {
        UserDefaults.standard.setValue(lat, forKey: POST_LOCATION_LATITUDE)
        UserDefaults.standard.setValue(lon, forKey: POST_LOCATION_LONGITUDE)

    }
    
    func loadPostLocationFromPreference()-> (Double?, Double?) {
        let lat = UserDefaults.standard.double(forKey: POST_LOCATION_LATITUDE)
        let lon = UserDefaults.standard.double(forKey: POST_LOCATION_LONGITUDE)
        return (lat,lon)
    }
    
    func removePostLocationFromPreference() {
        UserDefaults.standard.removeObject(forKey: POST_LOCATION_LATITUDE)
        UserDefaults.standard.removeObject(forKey: POST_LOCATION_LONGITUDE)
    }
    // MARK: Encode functions
    func encodeUser(user: User) -> String{
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(user)
        return String(data: data, encoding: .utf8)!
    }
    
    func encodeXplore(xplore: Xplore) -> String{
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(xplore)
        //let xploreJson = ["name":xplore.name,
        //                  "date":xplore.date,
        //                 "img":xplore.img,
        //                  "type":xplore.type,
        //                  "description":xplore.desc,
        //                  "ArrivalInstructions":xplore.ArrivalInstructions,
        //                  "latitude":xplore.lat,
        //                  "longitude":xplore.lon] as [String : Any]
        return String(data: data, encoding: .utf8)!
    }
    
    // MARK: Decode functions
    
    /*
     
     */
    func saveUserToPreference(user: User) {
        let jsonUser = encodeUser(user: user)
        UserDefaults.standard.setValue(jsonUser, forKey: CURRENT_USER)
    }
    
    func decodeUserFromPreference () -> User? {
        if let safeJsonPlayer = UserDefaults.standard.string(forKey: CURRENT_USER)  {
            let decoder = JSONDecoder()
            let data = Data(safeJsonPlayer.utf8)
            do {
                let user = try decoder.decode(User.self, from: data)
                //print("decodePlayer: \(user.description)")
                return user
            } catch{}
        }
        return nil
    }
    
    func decodeXplore(jsonUser: String?)->Xplore? {
        if let safeJsonPlayer = jsonUser {
            let decoder = JSONDecoder()
            let data = Data(safeJsonPlayer.utf8)
            do {
                let xplore = try decoder.decode(Xplore.self, from: data)
                //print("decodePlayer: \(user.description)")
                return xplore
            } catch{}
        }
        return nil
    }
    
    func printMyPreference() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        print("**************PRINTING MYPREFERENCE:**************")
        dictionary.keys.forEach { key in
            print(defaults.value(forKey: key) ?? "NA")
        }
    }

}
