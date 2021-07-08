//
//  myPreference.swift
//  MemoryGame
//
//  Created by user196210 on 6/2/21.
//

import Foundation
class myPreference {
    let CURRENT_USER = "current_user"
    let XPLORE_KEY_PREFIX = "xplore_"
    
    // MARK: User codable functions
    func encodeUser(user: User) -> String{
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(user)
        return String(data: data, encoding: .utf8)!
    }
    
    
    func saveUserToPreference(user: User) {
        let jsonUser = encodeUser(user: user)
        UserDefaults.standard.setValue(jsonUser, forKey: CURRENT_USER)
    }
    
    func decodeUser () -> User? {
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
    // MARK: Xplore codable functions
    func encodeXplore(xplore: Xplore) -> String{
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(xplore)
        return String(data: data, encoding: .utf8)!
    }
    
    func saveXploreToFirebase(xplore: Xplore) {
        let jsonXplore = encodeXplore(xplore: xplore)
        let key = "\(XPLORE_KEY_PREFIX)\(xplore.id)"
        //UserDefaults.standard.setValue(jsonXplore, forKey: CURRENT_USER)
        // Save save w
    }
    
    func loadXploreFromFirebase(key: String) {
        //UserDefaults.standard.setValue(jsonXplore, forKey: CURRENT_USER)
        // Save save w
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
