//
//  PlusViewCell.swift
//  CalabarYellowPages
//
//  Created by Smile Egbai on 11/19/16.
//  Copyright © 2016 calabarpages. All rights reserved.
//

import UIKit

class PlusViewCell: UITableViewCell {

    @IBOutlet weak var imageStackView: UIStackView!
    @IBOutlet weak var plusLogo: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var Address: UILabel!
    @IBOutlet weak var workDays: UILabel!
    @IBOutlet weak var Phone: UILabel!
    @IBOutlet weak var special: UILabel!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
   
    @IBOutlet weak var headerStack: UIStackView!
    @IBOutlet weak var advert: UIImageView!
    @IBOutlet weak var review: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
