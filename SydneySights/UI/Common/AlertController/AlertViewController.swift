//
//  AlertViewController.swift
//  SydneySights
//
//  Created by Mikhail Stetcura on 7/3/18.
//  Copyright © 2018 SML. All rights reserved.
//

import UIKit

typealias AlertCompletionHandler = (Int) -> Void
typealias TextFieldAlertCompletionHandler = (AlertButtons, String?) -> Void

typealias TextFieldAlertConfigurationHandler = (UITextField?) -> Void

enum AlertButtons: Int {
    case cancel = 0
    case ok = 1
}

class AlertViewController: UIAlertController {
    
    var completionHandler: AlertCompletionHandler?
    var textFieldCompletionHandler: TextFieldAlertCompletionHandler?

    //MARK: -
    
    convenience init(title: String? = nil, message: String? = nil, buttonTitles: [String], completionHandler: AlertCompletionHandler? = nil) {
        self.init(title: title, message: message, preferredStyle: .alert)
        
        for index in 0...buttonTitles.count - 1 {
            let action = UIAlertAction(title: buttonTitles[index], style: .default) { (_) in
                completionHandler?(index)
            }
            addAction(action)
        }
    }

    convenience init(title: String? = nil, message: String? = nil, completionHandler: TextFieldAlertCompletionHandler?, textFieldConfigurationHandler: TextFieldAlertConfigurationHandler?) {
        self.init(title: title, message: message, preferredStyle: .alert)
    
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (_) in
            completionHandler?(.cancel, nil)
        }
        addAction(cancel)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] (_) in
            let str = self?.textFields?.first?.text
            completionHandler?(.ok, str)
        }
        addAction(okAction)
        
        addTextField(configurationHandler: textFieldConfigurationHandler)
    }
}
