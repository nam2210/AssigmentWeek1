//
//  MovieTableViewCell.swift
//  AssigmentWeek1
//
//  Created by Nam Pham on 2/18/17.
//  Copyright © 2017 Nam Pham. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    
    @IBOutlet weak var ivThumbnail: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         lblTitle.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
