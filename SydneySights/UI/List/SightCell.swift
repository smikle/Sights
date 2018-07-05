//
//  SightCell.swift
//  SydneySights
//
//  Created by Mikhail Stetcura on 7/3/18.
//  Copyright © 2018 SML. All rights reserved.
//

import UIKit

class SightCell: UITableViewCell {

    @IBOutlet private (set) weak var nameLabel: UILabel!
    @IBOutlet private (set) weak var distanceLabel: UILabel!
    
    var item: SightProtocol? {
        didSet {
            refreshUI(item)
        }
    }

    //MARK: -
    
    override func prepareForReuse() {
        item = nil
    }

    private func refreshUI(_ item: SightProtocol?) {
        nameLabel?.text = item?.name
        distanceLabel?.text = "\(Formatter.groupping.string(for: item?.distance) ?? "-") m"
    }    
}
