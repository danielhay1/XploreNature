//
//  PostVC.swift
//  XploreNature
//
//  Created by user196210 on 7/8/21.
//

import UIKit
import MobileCoreServices
import FirebaseStorage


class PostVC: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var post_TF_name: UITextField!
    @IBOutlet weak var post_SC_type: UISegmentedControl!
    @IBOutlet weak var post_TF_description: UITextField!
    @IBOutlet weak var post_TF_arrivalInstructions: UITextField!
    @IBOutlet weak var post_IMG_xploreImg: UIImageView!
    var lat : Double?
    var lon : Double?
    var xplore_type = XPLORE_TYPE.nature_trip
    let firebase = MyFirebaseServies()
    let preference = myPreference()
    var imgUrl: URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadPostLocation()
        self.loadPostImage()
        
    }
    
    func loadPostLocation() {
        self.lat = preference.loadPostLocationFromPreference().0
        self.lon = preference.loadPostLocationFromPreference().1
        if (lat != nil) && (lon != nil) {
            print("location: \(String(describing: lat)),\(String(describing: lon))")
        }
    }
    
    func loadPostImage() {
        if(self.imgUrl == nil) {
            if let strImgUrl = preference.loadPostImageFromPreference() {
                self.imgUrl = URL(string: strImgUrl)
                self.post_IMG_xploreImg.downloaded(from: imgUrl!)
            }
        }
    }
    
    @IBAction func submitPost(_ sender: Any) {
        // Collect data
        let name = post_TF_name.text
        let description = post_TF_description.text
        let arrivalInstructions = post_TF_arrivalInstructions.text
        var strImg = ""
        if imgUrl != nil {
            if (lat != nil) && (lon != nil) {
                strImg = "\(String(describing: self.imgUrl!))"
                let xplore = Xplore(name: name, type: self.xplore_type.rawValue, img: strImg, desc: description, ArrivalInstructions: arrivalInstructions, lat: lat, lon: lon)            // Create Xplore object
                if let url = self.imgUrl {
                    firebase.uploadImage(localFile: url)
                }
                firebase.saveXploreToFirebase(xplore: xplore)   // Convert object to json and save it to firebase
                preference.removePostImageFromPreference()
                preference.removePostLocationFromPreference()
                switchToMainVC()
            } else {
                print("No location insterted!")
            }
        } else {
            print("No image insterted!")
        }
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
        self.init_picker()
    }
    
    func init_picker() {
        let imgType = kUTTypeImage as String
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [imgType]
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func locationBtnClick(_ sender: Any) {
        switchToChooseLocationVc()
    }
}

extension PostVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            print("Local url:\(url)")
            self.imgUrl = url
            self.preference.savePostImageToPreference(img: url.absoluteString)
            self.post_IMG_xploreImg.downloaded(from: url)
        }
        picker.dismiss(animated: true,completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

