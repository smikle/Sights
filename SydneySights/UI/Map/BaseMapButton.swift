//
//  BaseMapButton.swift
//  SydneySights
//
//  Created by Mikhail Stetcura on 7/3/18.
//  Copyright © 2018 SML. All rights reserved.
//

import UIKit
import MapKit

class BaseMapButton<T>: UIButton {
    
    public private (set) var data: T?
    private var completionHandler: ((T?) -> Void)?
    
    init(_ data: T, imageName: String, completionHandler: ((T?) -> Void)? = nil) {
        super.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        
        self.data = data
        setImage(UIImage(named: imageName), for: .normal)
        self.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        self.completionHandler = completionHandler
    }
    
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        guard let sender = sender as? BaseMapButton else {
            return
        }
        completionHandler?(sender.data)
    }
}

class InfoSightMapButton: BaseMapButton<SightProtocol> {

    init(_ data: SightProtocol, completionHandler: ((SightProtocol?) -> Void)? = nil) {
        super.init(data, imageName: "info", completionHandler: completionHandler)
    }

    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
    }
}

class InfoPlaceMapButton: BaseMapButton<MKPlacemark> {
    
    init(_ data: MKPlacemark, completionHandler: ((MKPlacemark?) -> Void)? = nil) {
        super.init(data, imageName: "save", completionHandler: completionHandler)
    }
    
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
    }
}
