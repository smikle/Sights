//
//  EditViewController.swift
//  SydneySights
//
//  Created by Mikhail Stetcura on 7/3/18.
//  Copyright © 2018 SML. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, ViewControllerStoryboard {

    static var storyboardName = "Main"
    
    @IBOutlet private (set) weak var nameTextField: UITextField!
    @IBOutlet private (set) weak var descrTextField: UITextField!
    @IBOutlet private (set) weak var longitudeTextField: UITextField!
    @IBOutlet private (set) weak var latitudeTextField: UITextField!
    
    @IBOutlet private weak var saveButton: UIBarButtonItem!
    
    var sight: SightProtocol?
    
    //MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        longitudeTextField.delegate = self
        latitudeTextField.delegate = self
        refreshUI(sight)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sight?.rollback()
    }

    //MARK: -
    
    private func refreshUI(_ item: SightProtocol?) {
        nameTextField?.text = item?.name
        descrTextField?.text = item?.descr
        longitudeTextField?.text = "\(item?.longitude ?? 0)"
        latitudeTextField?.text = "\(item?.latitude ?? 0)"
    }

    //MARK: - Actions
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        sight?.name = nameTextField.text
        sight?.descr = descrTextField.text
        sight?.longitude = longitudeTextField.text?.double ?? 0
        sight?.latitude = latitudeTextField.text?.double ?? 0
        
        sight?.save()
        
        navigationController?.popViewController(animated: true)
    }    
}

extension EditViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return sight?.isUserPoint ?? false
    }
}
