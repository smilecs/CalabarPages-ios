//
//  ReviewTableViewCell.swift
//  CalabarYellowPages
//
//  Created by Mmumene Egbai on 23/09/2017.
//  Copyright © 2017 calabarpages. All rights reserved.
//

import UIKit
import FloatRatingView

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var reviewersName: UILabel!
    @IBOutlet weak var reviewMessage: UILabel!
    @IBOutlet var rating: FloatRatingView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
