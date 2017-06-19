//
//  DetailViewController.swift
//  coderschool_ios_ass1
//
//  Created by Tran Tien Tin on 6/18/17.
//  Copyright © 2017 phapli. All rights reserved.
//

import UIKit
import AFNetworking

class DetailViewController: UIViewController {

    var selectedPhotoUrlString: String?
    var overviewString: String?
    
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let urlString = selectedPhotoUrlString, let url = URL(string: urlString) {
            posterImage.setImageWith(url)
        }
        
        overviewLabel.text = overviewString
        overviewLabel.sizeToFit()
    }

    
}
