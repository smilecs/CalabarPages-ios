//
//  TableViewCell.swift
//  CalabarYellowPages
//
//  Created by Smile Egbai on 11/19/16.
//  Copyright © 2016 calabarpages. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var SearchSpecialisation: UILabel!
    @IBOutlet weak var SearchPhone: UILabel!
    @IBOutlet weak var SearchWorkDay: UILabel!
    @IBOutlet weak var SearchAddress: UILabel!
    @IBOutlet weak var SearchLogo: UIImageView!
    @IBOutlet weak var SearchTitle: UILabel!
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
