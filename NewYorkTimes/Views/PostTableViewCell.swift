//
//  PostTableViewCell.swift
//  NewYorkTimes
//
//  Created by andah on 26/09/2018.
//  Copyright © 2018 programmer. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var timePeriodLbl: UILabel!
    @IBOutlet weak var abstractDescriptionLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.borderColor = UIColor(white: 0.85, alpha: 1.0).cgColor
        layer.borderWidth = 2.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
// MARK: - ProductViewModelView
extension PostTableViewCell: PostViewModelView {
    
    public var titleLblView: UILabel {
        return titleLbl
    }
    
    public var timePeriodLblView: UILabel {
        return timePeriodLbl
    }
    
    public var abstractDescriptionLblView: UILabel {
        return abstractDescriptionLbl
    }
}
