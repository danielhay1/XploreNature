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
        self.localLoadPostDetails()
        
    }
    
    func localSavePostDetails() {
        print("Local save post details")
            preference.savePostDetails(name: post_TF_name.text ?? "", type: xplore_type.rawValue, desc: post_TF_description.text ?? "", arrivalInstructions: post_TF_arrivalInstructions.text ?? "", img: imgUrl?.absoluteString, lat: lat, lon: lon)
    }
    
    func localLoadPostDetails() {
        if let post_details = preference.loadPostDetails() {
            print("Local load post details")
            self.post_TF_name.text = post_details["place_name"] as? String
            self.setXploreTypeValue(value: post_details["type"] as! Int)
            self.post_SC_type.selectedSegmentIndex = self.xplore_type.rawValue
            self.post_TF_description.text = post_details["desc"] as? String
            self.post_TF_arrivalInstructions.text = post_details["arrivalInstructions"] as? String
            if let latlng = post_details["lat"] {
                self.lat = latlng as? Double
            }
            if let latlong = post_details["lon"] {
                self.lon = latlong as? Double
            }
            if let strImgUrl = post_details["img"] {
                self.imgUrl = URL(string: strImgUrl as! String)
                self.post_IMG_xploreImg.downloaded(from: imgUrl!)
            }
        }
        
    }
    
    func alertDialog(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
                case .default:
                print("default")
                
                case .cancel:
                print("cancel")
                
                case .destructive:
                print("destructive")
                
            default:
                fatalError()
            }
        }))
        self.present(alert, animated: true, completion: nil)
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
                    firebase.uploadImage(localFile: url, xplore: xplore)
                }
                preference.RemovePostDetails()
                switchToMainVC()
            } else {
                print("No location insterted!")
                alertDialog(title: "Field is missing", msg: "No location insterted!")
                
            }
        } else {
            print("No image insterted!")
            alertDialog(title: "Field is missing", msg: "No Image insterted!")
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
    
    func setXploreTypeValue(value: Int) {
        switch value {
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
    @IBAction func selectXploreType(_ sender: Any) {
        setXploreTypeValue(value: post_SC_type.selectedSegmentIndex)
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
        self.localSavePostDetails()
        self.switchToChooseLocationVc()
    }
}

extension PostVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            print("Local url:\(url)")
            self.imgUrl = url
            //self.preference.savePostImageToPreference(img: url.absoluteString)
            self.localSavePostDetails()
            self.post_IMG_xploreImg.downloaded(from: url)
        }
        picker.dismiss(animated: true,completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

