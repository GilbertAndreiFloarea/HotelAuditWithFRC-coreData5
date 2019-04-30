//
//  ThingTableViewCell.swift
//  HotelAuditWithFRC-coreData5
//
//  Created by Gilbert Andrei Floarea on 30/04/2019.
//  Copyright © 2019 Gilbert Andrei Floarea. All rights reserved.
//

import UIKit

class ThingTableViewCell: UITableViewCell {

    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var xImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - IBOutlets
    
    // MARK: - View Life Cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        
        brandLabel.text = nil
        countLabel.text = nil
        xImageView.image = nil
    }

}
