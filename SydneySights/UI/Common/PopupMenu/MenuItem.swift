//
//  MenuItem.swift
//  SydneySights
//
//  Created by Mikhail Stetcura on 7/3/18.
//  Copyright © 2018 SML. All rights reserved.
//

import UIKit

typealias MenuItemAction = (() -> Void)

class MenuItem {
    var title: String?
    var image: UIImage?
    var imageAlpha: CGFloat!
    var action: MenuItemAction?
    
    init(title: String? = nil, image: UIImage? = nil, imageAlpha: CGFloat = 1, action: MenuItemAction? = nil) {
        self.title = title
        self.image = image
        self.imageAlpha = imageAlpha
        self.action = action
    }
}
