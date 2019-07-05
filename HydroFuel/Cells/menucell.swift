//
//  menucell.swift
//  HydroFuel
//
//  Created by Stegowl05 on 01/09/18.
//  Copyright © 2018 Stegowl. All rights reserved.
//

import UIKit

class menucell: UITableViewCell {

    @IBOutlet var lineview: UIView!
    @IBOutlet var lblname: UILabel!
    @IBOutlet var imgview: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
