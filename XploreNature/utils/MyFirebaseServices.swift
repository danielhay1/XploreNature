//
//  MyFirebaseServices.swift
//  XploreNature
//
//  Created by user196210 on 7/9/21.
//

import Foundation
import Firebase
import FirebaseStorage
import UIKit

protocol MyFireBaseDelegate {
    func dataIsReady(xplores: [Xplore])
}

class MyFirebaseServies {
    let preference = myPreference()
    var delegate : MyFireBaseDelegate?
    // Firebase references
    let ref: DatabaseReference = Database.database().reference(fromURL: "https://xplorenature-dc42b-default-rtdb.europe-west1.firebasedatabase.app")
    let storageRef = Storage.storage().reference()
    // Firebase keys
    private let XPOLRE_TITLE = "xplores"
    private let XPLORE_IMAGES_KEY  = "xplore_images"
    init() {}
    
    // MARK: Firebase database services
    func saveXploreToFirebase(xplore: Xplore) {
        //print("ENCODE VALUE: \(preference.encodeXplore(xplore: xplore))")
        
        let jsonXplore = preference.convertToDictionary(json: preference.encodeXplore(xplore: xplore))
        let key = "\(preference.XPLORE_KEY_PREFIX)\(xplore.id)"
        self.ref.child(XPOLRE_TITLE).child(key).setValue(jsonXplore)
    }
    
    func loadXploreFromFirebase(xploreKey: String)->Xplore? {
        //BUG!
        var xplore: Xplore?
        //let key = "\(preference.XPLORE_KEY_PREFIX)\(xploreId)"
        self.ref.child(XPOLRE_TITLE).child(xploreKey).observeSingleEvent(of: .value, with: { snapshot in
            // Get user value
            
            guard let value = snapshot.value as? String else {
                
                return
            }
            print("snapshot value: \(value)")
            xplore = self.preference.decodeXplore(jsonXplore: value)

        })
        return xplore
    }
    
    func loadAllXploresFromFirebase() {
        print("loadAllXploresFromFirebase:")
        var xplores : [Xplore] = []
        let parentRef = ref.child(XPOLRE_TITLE)
        parentRef.observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String: [String:Any]] else {
                return
            }
            print("{")
            // DATA WAS FOUND
            for (key, val) in value {
                if let xplore = self.preference.dictionaryToXplore(dictXplore: val) {
                    print("\t\(key) : \(xplore.description)")
                    xplores.append(xplore)
                    self.downloadImage(strUrl: xplore.img)
                }
            }
            print("}")
            self.delegate?.dataIsReady(xplores: xplores)
        })
    }
    
    func name(xploreList: [Xplore],type: Int) {
        
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
    func uploadImage(localFile: URL) {
        let imagesRef = storageRef.child("images").child(localFile.lastPathComponent)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let uploadTask = imagesRef.putFile(from: localFile, metadata: metadata)
        uploadTask.observe(.success) { snapshot in
            // Upload completed successfully
            print("Image Uploadeded Sucessfully")
        }
        // FAILURE
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as NSError? {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    print("File doesn't exist")
                    break
                case .unauthorized:
                    print("User doesn't have permission to access file")
                    break
                case .cancelled:
                    print("User canceled the upload")
                    break
                case .unknown:
                    print("Unknown error occurred, inspect the server response")
                    break
                default:
                    print("A separate error occurred. This is a good place to retry the upload.")
                    break
                }
            }
        }
    }
    
    func downloadImage(strUrl: String) {
        if let localURL = URL(string: strUrl) {
            let fileName = localURL.lastPathComponent
            let imagesRef = storageRef.child("images").child(fileName)
            let downloadTask = imagesRef.write(toFile: localURL)
            downloadTask.observe(.success) { snapshot in
                // Download completed successfully
                print("Image Downloaded Successfully")
            }
            // Errors only occur in the "Failure" case
            downloadTask.observe(.failure) { snapshot in
                guard let errorCode = (snapshot.error as NSError?)?.code else {
                    return
                }
                guard let error = StorageErrorCode(rawValue: errorCode) else {
                    return
                }
                switch (error) {
                case .objectNotFound:
                    print("File doesn't exist")
                    break
                case .unauthorized:
                    print("User doesn't have permission to access file")
                    break
                case .cancelled:
                    print("User cancelled the download")
                    break
                    
                /* ... */
                
                case .unknown:
                    print("Unknown error occurred, inspect the server response")
                    break
                default:
                    print("Another error occurred. This is a good place to retry the download.")
                    break
                }
            }
        }
    }
    
}
