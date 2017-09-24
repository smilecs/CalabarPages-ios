//
//  CategoryListViewCell.swift
//  CalabarYellowPages
//
//  Created by Smile Egbai on 11/21/16.
//  Copyright © 2016 calabarpages. All rights reserved.
//

import UIKit

class CategoryListViewCell: UITableViewCell {

    @IBOutlet weak var advert: UIImageView!
   
    @IBOutlet weak var WorkDays: UILabel!
    @IBOutlet weak var Address: UILabel!
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Phone: UILabel!
    @IBOutlet weak var Specialisation: UILabel!
    @IBOutlet weak var logo: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        logo.layer.cornerRadius = logo.frame.size.width/2
        logo.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
