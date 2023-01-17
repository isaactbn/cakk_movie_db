//
//  TableViewCell.swift
//  Cakk Movies
//
//  Created by Isaac on 01/18/23.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewWrapper: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var reviewerName: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewWrapper.layer.applySketchShadow(color: #colorLiteral(red: 0, green: 0.21322909, blue: 0.5749545693, alpha: 1), alpha: 0.1, x: -2, y: 2, blur: 6, spread: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
