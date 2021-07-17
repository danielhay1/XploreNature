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
    private let POST_LOCATION_LATITUDE = "post_location_latitude"
    private let POST_LOCATION_LONGITUDE = "post_location_longitude"
    private let POST_IMAGE = "post_image"
    
    // MARK: Post location fucntions:
    func savePostLocationToPreference(lat: Double, lon: Double) {
        UserDefaults.standard.setValue(lat, forKey: POST_LOCATION_LATITUDE)
        UserDefaults.standard.setValue(lon, forKey: POST_LOCATION_LONGITUDE)
    }
    
    func loadPostLocationFromPreference()-> (Double?, Double?) {
        let lat = UserDefaults.standard.double(forKey: POST_LOCATION_LATITUDE)
        let lon = UserDefaults.standard.double(forKey: POST_LOCATION_LONGITUDE)
        if(lat != 0.0) || (lon != 0.0) {
            return (lat,lon)
        }
        return (nil,nil)
    }

    func removePostLocationFromPreference() {
        UserDefaults.standard.removeObject(forKey: POST_LOCATION_LATITUDE)
        UserDefaults.standard.removeObject(forKey: POST_LOCATION_LONGITUDE)
    }
    // MARK: Post image fucntions:
    func savePostImageToPreference(img: String) {
        UserDefaults.standard.setValue(img, forKey: POST_IMAGE)
    }
    
    func loadPostImageFromPreference()-> String? {
        if let img = UserDefaults.standard.string(forKey: POST_IMAGE) {
            return img
        } else {
            return nil
        }
    }
    
    func removePostImageFromPreference() {
        UserDefaults.standard.removeObject(forKey: POST_IMAGE)
    }
    // MARK: Encode functions
    func encodeUser(user: User) -> String{
        let encoder = JSONEncoder()
        encoder.outputFormatting = .withoutEscapingSlashes
        let data = try! encoder.encode(user)
        return String(data: data, encoding: .utf8)!
    }
    
    func encodeXplore(xplore: Xplore) -> String{
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(xplore)
        print(String(data: data, encoding: .utf8)!)
        return String(data: data, encoding: .utf8)!
    }
    
    func convertToDictionary(json: String) -> [String: Any]? {
        if let data = json.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
        
    /*
     
     */
    func saveUserToPreference(user: User) {
        let jsonUser = encodeUser(user: user)
        UserDefaults.standard.setValue(jsonUser, forKey: CURRENT_USER)
    }
    
    // MARK: Decode functions
    func dictionaryToXplore(dictXplore:[String: Any]?) ->Xplore? {
        var xplore : Xplore?
        if let safeDictXplore = dictXplore {
            var jsonXplore : String = "{\n"
            for tup in safeDictXplore {
                var value = tup.value
                if value is String {
                    value = "\"\(tup.value)\""
                }
                jsonXplore += String("  \"\(tup.key)\" : \(value),\n")
            }
            jsonXplore = jsonXplore.substring(to: jsonXplore.count-2)
            jsonXplore+="\n}"
            //print("Value=\n\(jsonXplore)")
            xplore = self.decodeXplore(jsonXplore: jsonXplore)
        }
        return xplore
    }
    
    func decodeUserFromPreference () -> User? {
        if let safeJsonPlayer = UserDefaults.standard.string(forKey: CURRENT_USER)  {
            let decoder = JSONDecoder()
            let data = Data(safeJsonPlayer.utf8)
            do {
                let user = try decoder.decode(User.self, from: data)
                return user
            } catch{}
        }
        return nil
    }
    
    func decodeXplore(jsonXplore: String?)->Xplore? {
        if let safeJsonPlayer = jsonXplore {
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
