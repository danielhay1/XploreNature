//
//  TestCell.swift
//  XploreNature
//
//  Created by user196210 on 7/21/21.
//

import UIKit

public protocol CellActionDelegate{
    func cellBtnTapped()
}

class CustomCell: UITableViewCell {
    
    var actionDelegate : CellActionDelegate?
    @IBOutlet weak var cell_LBL_name: UILabel!
    @IBOutlet weak var cell_LBL_type: UILabel!
    @IBOutlet weak var cell_LBL_date: UILabel!
    @IBOutlet weak var cell_IMG: UIImageView!
    @IBOutlet weak var cell_LBL_description: UILabel!
    @IBOutlet weak var cell_LBL_arrivalInstructions: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func foo(_ sender: Any) {
        print("foo")
        if let delegate = self.actionDelegate {
            delegate.cellBtnTapped()
        }
    }
}
