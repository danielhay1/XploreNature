//
//  splashCVC.swift
//  XploreNature
//
//  Created by user196210 on 7/27/21.
//

import UIKit

class splashCVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        switchToMainVC()
    }
    func switchToMainVC() {
        // Open new viewController
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            Thread.sleep(forTimeInterval: 3.0)
            guard let vc = self.storyboard?.instantiateViewController(identifier: "Main") as? MainVC else {
                print("failed to get vc from storyboard")
                return
            }
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
}
