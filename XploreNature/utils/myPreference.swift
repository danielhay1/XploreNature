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
    private var POST_DETAILS = "post_details"
    
    
    // MARK: post details functions:
    func savePostDetails(name: String,type: Int, desc: String, arrivalInstructions: String, img: String?, lat:Double?, lon:Double?) {
        var post_details = loadPostDetails() ?? [String:Any]()
        post_details["place_name"] = name
        post_details["type"] = type
        post_details["desc"] = desc
        post_details["arrivalInstructions"] = arrivalInstructions
        if(img != nil) {
            post_details["img"] = img
        }
        if(lat != nil) {
            post_details["lat"] = lat
        }
        if(lon != nil) {
            post_details["lon"] = lon
        }
        UserDefaults.standard.setValue(post_details, forKey: POST_DETAILS)
    }
    
    func loadPostDetails() -> [String: Any]? {
        return (UserDefaults.standard.object(forKey: POST_DETAILS) as? [String:Any])
    }
    
    func RemovePostDetails() {
        UserDefaults.standard.removeObject(forKey: POST_DETAILS)
    }
    
    // MARK: Post location fucntions:
    func savePostLocationToPreference(lat: Double, lon: Double) {
        var post_details = loadPostDetails() ?? [String:Any]()
        post_details["lat"] = lat
        post_details["lon"] = lon
        UserDefaults.standard.setValue(post_details, forKey: POST_DETAILS)
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
