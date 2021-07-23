//
//  xplorePostCell.swift
//  XploreNature
//
//  Created by user196210 on 7/21/21.
//

import UIKit
protocol CellActionDelegate {
    func navigateDest(lat: Double,lon: Double)
}
class xplorePostCell: UITableViewCell {

    var actionDelegate : CellActionDelegate?
    @IBOutlet weak var cell_LBL_name: UILabel!
    @IBOutlet weak var cell_LBL_type: UILabel!
    @IBOutlet weak var cell_LBL_date: UILabel!
    @IBOutlet weak var cell_IMG: UIImageView!
    @IBOutlet weak var cell_LBL_description: UILabel!
    @IBOutlet weak var cell_LBL_arrivalInstructions: UILabel!
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
    
    
    @IBAction func viewXplore(_ sender: Any) {
        if let delegate = self.actionDelegate {
            if((self.lat != nil)&&(self.lon != nil)) {
                print("OPENING MAPS NAVIGATION TO DESTINATION...")
                delegate.navigateDest(lat: self.lat!,lon: self.lon!)
            }
        }
    }
}
