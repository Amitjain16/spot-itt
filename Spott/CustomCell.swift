 //
//  CustomCell.swift
//  Spott
//
//  Created by Amit Jain on 3/26/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!

    @IBOutlet weak var goButton: UIButton!
   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
