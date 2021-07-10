//
//  MyFirebaseServices.swift
//  XploreNature
//
//  Created by user196210 on 7/9/21.
//

import Foundation
import Firebase
class MyFirebaseServies {
    let preference = myPreference()
    let ref: DatabaseReference = Database.database().reference(fromURL: "https://xplorenature-dc42b-default-rtdb.europe-west1.firebasedatabase.app")
    private let XPOLRE_TITLE = "xplores"
    
    init() {}
    
    // MARK: Firebase database services
    func saveXploreToFirebase(xplore: Xplore) {
        let jsonXplore = preference.encodeXplore(xplore: xplore)
        let key = "\(preference.XPLORE_KEY_PREFIX)\(xplore.id)"
        self.ref.child(XPOLRE_TITLE).setValue([key: jsonXplore])
    }
    
    func loadXploreFromFirebase(xploreId: Int)->Xplore? {
        var xplore: Xplore?
        let key = "\(preference.XPLORE_KEY_PREFIX)\(xploreId)"
        self.ref.child(XPOLRE_TITLE).observeSingleEvent(of: .value, with: { snapshot in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let jsonXplore = value?[key] as? String
            xplore = self.preference.decodeXplore(jsonUser: jsonXplore)!
        }) { error in
          print(error.localizedDescription)
        }
        return xplore
    }
    
    func deleteXploreFromFirebase(xploreId: Int)->Bool {
        var sucess_flag: Bool = true
        let key = "\(preference.XPLORE_KEY_PREFIX)\(xploreId)"
        self.ref.child(XPOLRE_TITLE).child(key).removeValue() { error,dbRef   in
            if error != nil {
                print("error: \(String(describing: error))")
                sucess_flag = false
            }
        }
        return sucess_flag
    }
    // MARK: Firebase storage services
    func uploadImg(){
    }
    /**
     let preference = myPreference()
     static var ref: DatabaseReference!
     static let instance = MyFirebaseServies()
     private let XPOLRE_TITLE = "xplores"
     
     private init() {
         if MyFirebaseServies.ref == nil{
             MyFirebaseServies.ref = Database.database().reference()
         }
     }
     
     func instance() -> DatabaseReference! {
         return MyFirebaseServies.ref
     }
     
     func saveXploreToFirebase(xplore: Xplore) {
         let jsonXplore = preference.encodeXplore(xplore: xplore)
         let key = "\(preference.XPLORE_KEY_PREFIX)\(xplore.id)"
         MyFirebaseServies.ref.child(XPOLRE_TITLE).setValue([key: jsonXplore])
     }
     
     func loadXploreFromFirebase(xploreId: Int)->Xplore? {
         var xplore: Xplore?
         let key = "\(preference.XPLORE_KEY_PREFIX)\(xploreId)"
         MyFirebaseServies.ref.child(XPOLRE_TITLE).child(key).observeSingleEvent(of: .value, with: { [self] snapshot in
             // Get user value
             let value = snapshot.value as? NSDictionary
             let jsonXplore = value?[key] as! String
             xplore = preference.decodeXplore(jsonUser: jsonXplore)!
         }) { error in
           print(error.localizedDescription)
         }
         return xplore
     }
     */
    
}

