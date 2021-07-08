//
//  PostVC.swift
//  XploreNature
//
//  Created by user196210 on 7/8/21.
//

import UIKit

class PostVC: UIViewController {
    
    @IBOutlet weak var post_TF_name: UITextField!
    @IBOutlet weak var post_SC_type: UISegmentedControl!
    @IBOutlet weak var post_TF_description: UITextField!
    @IBOutlet weak var post_TF_arrivalInstructions: UITextField!
    var lat : Double = 0.0
    var lon : Double = 0.0
    var xplore_type = XPLORE_TYPE.nature_trip
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitPost(_ sender: Any) {
        // Collect data
        let name = post_TF_name.text
        let description = post_TF_description.text
        let arrivalInstructions = post_TF_arrivalInstructions.text
        // Create Xplore object
        // Convert object to json and save it to firebase
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
    
    @IBAction func submitPostClick(_ sender: Any) {
    }
    
    @IBAction func locationBtnClick(_ sender: Any) {
    }
}
