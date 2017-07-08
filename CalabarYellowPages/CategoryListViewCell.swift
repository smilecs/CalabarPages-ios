//
//  CategoryListViewCell.swift
//  CalabarYellowPages
//
//  Created by Smile Egbai on 11/21/16.
//  Copyright © 2016 calabarpages. All rights reserved.
//

import UIKit

class CategoryListViewCell: UITableViewCell {

   
    @IBOutlet weak var WorkDays: UILabel!
    @IBOutlet weak var Address: UILabel!
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Phone: UILabel!
    @IBOutlet weak var Specialisation: UILabel!
    @IBOutlet weak var Advert: UIImageView!
    @IBOutlet weak var logo: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
