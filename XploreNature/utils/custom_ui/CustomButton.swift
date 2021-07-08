//
//  CustomButton.swift
//  MemoryGame
//
//  Created by user196210 on 5/1/21.
//

import Foundation
import UIKit

class CustomButton: UIButton {
    //Check why implementation not visible on UI.
    var radius: Double = 30
    var borderSize: Double = 2
    
    func setRadius(radius: Double) { 
        self.radius = radius
    }
    
    func setBorderSize(borderSize: Double) {
        self.borderSize = borderSize
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        shared()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        shared()
    }

   override func prepareForInterfaceBuilder() {
       super.prepareForInterfaceBuilder()
       shared()
   }
   func shared() {
        //TODO: add any custom settings here
        self.backgroundColor = .clear
        self.layer.cornerRadius = CGFloat(radius)
        self.layer.borderWidth = CGFloat(borderSize)
        self.layer.borderColor = UIColor(named: "AppGreen")?.cgColor
        //self.layer.backgroundColor = UIColor.systemPurple.cgColor
        self.setTitleColor(UIColor(named: "AppGreen"), for: .normal)
        //Color("main_btn_color")
   }



}
