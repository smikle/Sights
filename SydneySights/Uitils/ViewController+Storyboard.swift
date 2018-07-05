//
//  ViewController+Storyboard.swift
//  SydneySights
//
//  Created by Mikhail Stetcura on 7/4/18.
//  Copyright © 2018 SML. All rights reserved.
//

import UIKit

protocol ViewControllerStoryboard: class {
    
    static func controller() -> UIViewController?
    static func controller(_ identifier: String ) -> UIViewController?
    
    static var storyboard: UIStoryboard? { get }
    static var storyboardName: String { get }
    static var controllerIdentifier: String { get }
    
}

extension ViewControllerStoryboard where Self: UIViewController {
    
    static func controller() -> UIViewController? {
        return self.controller(self.controllerIdentifier)
    }
    
    static func controller(_ identifier: String ) -> UIViewController? {
        let storyboard = self.storyboard
        let controller = storyboard?.instantiateViewController(withIdentifier: identifier)
        
        return controller
    }
    
    static var storyboard: UIStoryboard? {
        return UIStoryboard(name: self.storyboardName, bundle: Bundle.main)
    }
    
    static var controllerIdentifier: String {
        return String(describing: self)
    }
}
