//
//  XploreTableViewCell.swift
//  Xplore nature
//
//  Created by user196210 on 6/26/21.
//

import UIKit
public protocol CellActionDelegate{
    func cellBtnTapped()
}
class XploreTableViewCell: UITableViewCell {
    var actionDelegate: CellActionDelegate?
    @IBOutlet weak var cell_LBL_name: UILabel!
    @IBOutlet weak var cell_LBL_type: UILabel!
    @IBOutlet weak var cell_LBL_date: UILabel!
    @IBOutlet weak var cell_LBL_img: UIImageView!
    @IBOutlet weak var cell_LBL_description: UITextView!
    @IBOutlet weak var cell_LBL_arrivalInstructions: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        actionDelegate = CellActionDelegate.self as! CellActionDelegate
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func viewXplore(_ sender: Any) {
        
        if let delegate = self.actionDelegate {
            delegate.cellBtnTapped()
        }       
    }
}
