//
//  MainTableViewCell.swift
//  coderschool_ios_ass1
//
//  Created by Tran Tien Tin on 6/18/17.
//  Copyright © 2017 phapli. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
