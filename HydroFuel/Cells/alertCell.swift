//
//  alertCell.swift
//  HydroFuel
//
//  Created by Stegowl05 on 31/08/18.
//  Copyright © 2018 Stegowl. All rights reserved.
//

import UIKit

class alertCell: UITableViewCell {

    @IBOutlet var txttimer: UITextField!
    @IBOutlet weak var imgEdit: UIImageView!
    @IBOutlet weak var btnEdit: UILabel!
    @IBOutlet var lbltimeshow: UILabel!
    @IBOutlet var lblwaterdescripation: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
