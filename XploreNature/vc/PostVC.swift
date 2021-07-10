//
//  PostVC.swift
//  XploreNature
//
//  Created by user196210 on 7/8/21.
//

import UIKit
import MobileCoreServices
import FirebaseStorage
class PostVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var post_TF_name: UITextField!
    @IBOutlet weak var post_SC_type: UISegmentedControl!
    @IBOutlet weak var post_TF_description: UITextField!
    @IBOutlet weak var post_TF_arrivalInstructions: UITextField!
    var lat : Double = 0.0
    var lon : Double = 0.0
    var xplore_type = XPLORE_TYPE.nature_trip
    let firebase = MyFirebaseServies()
    let preference = myPreference()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lat = preference.loadPostLocationFromPreference().0 ?? 0.0
        self.lon = preference.loadPostLocationFromPreference().1 ?? 0.0
        preference.removePostLocationFromPreference()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitPost(_ sender: Any) {
        // Collect data
        let name = post_TF_name.text
        let description = post_TF_description.text
        let arrivalInstructions = post_TF_arrivalInstructions.text
        let img = "Xplore.png"
        //let xplore = Xplore(name: name, type: self.xplore_type.rawValue, img: img,desc: description,ArrivalInstructions: arrivalInstructions,lat: lat, lon: lon)            // Create Xplore object
        let xplore = Xplore(name: "daniel", type: 0, img: "pic.png", desc: "go", ArrivalInstructions: "go", lat: lat, lon: lon)
        firebase.saveXploreToFirebase(xplore: xplore)   // Convert object to json and save it to firebase

        switchToMainVC()
    }
    
    func switchToMainVC() {
        // Open new viewController
        guard let vc = storyboard?.instantiateViewController(identifier: "Main") as? MainVC else {
            print("failed to get vc from storyboard")
            return
        }
        present(vc, animated: true, completion: nil)
    }
    
    func switchToChooseLocationVc(){
        // Open new viewController
        guard let vc = storyboard?.instantiateViewController(identifier: "choose_location") as? ChooseLocationVC else {
            print("failed to get vc from storyboard")
            return
        }
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func selectXploreType(_ sender: Any) {
        switch post_SC_type.selectedSegmentIndex {
        case 0:
            self.xplore_type = XPLORE_TYPE.nature_trip.self
        case 1:
            self.xplore_type = XPLORE_TYPE.park.self
        case 2:
            self.xplore_type = XPLORE_TYPE.wellspring.self
        case 3:
            self.xplore_type = XPLORE_TYPE.observation.self
        default:
            self.xplore_type = XPLORE_TYPE.nature_trip.self
            break;
        }
    }
    
    @IBAction func addImg(_ sender: Any) {
        
        //picker.delegate = self
        //picker.allowsEditing = true
        //present(picker, animated: true)
        self.storage()
    }
    
    func storage() {
        let imgType = kUTTypeImage as String
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [imgType]
        picker.delegate = self
    }
    
    @IBAction func locationBtnClick(_ sender: Any) {
        switchToChooseLocationVc()
    }
}

