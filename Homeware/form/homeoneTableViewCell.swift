//
//  homeoneTableViewCell.swift
//  Homeware
//
//  Created by Han-Pin on 2020/8/25.
//  Copyright © 2020 Han-Pin. All rights reserved.
//

import UIKit

class homeoneTableViewCell: UITableViewCell {
    
    @IBOutlet var namelabel: UILabel!
    @IBOutlet var quantitylabel: UILabel!

    @IBOutlet var starImageView: UIImageView!
    @IBOutlet var homeimage: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
