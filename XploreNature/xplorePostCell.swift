//
//  xplorePostCell.swift
//  XploreNature
//
//  Created by user196210 on 7/21/21.
//

import UIKit
import CoreLocation
protocol CellActionDelegate {
    func navigateDest(lat: Double,lon: Double)
    func googleIt(search: String)
}
class xplorePostCell: UITableViewCell {

    var actionDelegate : CellActionDelegate?
    @IBOutlet weak var cell_LBL_name: UILabel!
    @IBOutlet weak var cell_LBL_type: UILabel!
    @IBOutlet weak var cell_LBL_date: UILabel!
    @IBOutlet weak var cell_IMG: UIImageView!
    @IBOutlet weak var cell_LBL_description: UILabel!
    @IBOutlet weak var cell_LBL_arrivalInstructions: UILabel!
    var locationManager: CLLocationManager = CLLocationManager()
    var lat : Double?
    var lon : Double?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func navigateXplore(_ sender: Any) {
        if let delegate = self.actionDelegate {
            if((self.lat != nil)&&(self.lon != nil)) {
                print("OPENING MAPS NAVIGATION TO DESTINATION...")
                delegate.navigateDest(lat: self.lat!,lon: self.lon!)
            }
        }
    }
    @IBAction func googleBtnPress(_ sender: Any) {
        let prefixIndex = "Place Name: ".count
        let text = self.cell_LBL_name.text!.substring(from: prefixIndex)
        self.actionDelegate?.googleIt(search: text)
    }
}
