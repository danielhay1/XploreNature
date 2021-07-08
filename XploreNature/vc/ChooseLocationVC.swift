//
//  ChooseLocationVC.swift
//  XploreNature
//
//  Created by user196210 on 7/8/21.
//

import UIKit

public protocol locationReady {
    func updateLocation(lat:Double, lon:Double)
}

class ChooseLocationVC: UIViewController {
    var lat = 0
    var lon = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func submitLocation(_ sender: Any) {
        //set location
        //save location on local memory
        //change to PostVC
        guard let vc = storyboard?.instantiateViewController(identifier: "Post") as? PostVC else {
            print("failed to get vc from storyboard")
            return
        }
        present(vc, animated: true, completion: nil)
    }
}
