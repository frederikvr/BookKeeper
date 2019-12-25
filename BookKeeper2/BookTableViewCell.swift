//
//  BookTableViewCell.swift
//  BookKeeper2
//
//  Created by Fred on 25/12/2019.
//  Copyright © 2019 Fred. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
