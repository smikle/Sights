//
//  MenuItemCell.swift
//  SydneySights
//
//  Created by Mikhail Stetcura on 7/3/18.
//  Copyright © 2018 SML. All rights reserved.
//

import UIKit

class MenuItemCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var defImageView: UIImageView!
    
    var item: MenuItem? {
        didSet {
            refreshUI(item)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func refreshUI(_ item: MenuItem?) {
        titleLabel?.text = item?.title
        defImageView?.image = item?.image
        defImageView?.alpha = item?.imageAlpha ?? 1
    }
}
