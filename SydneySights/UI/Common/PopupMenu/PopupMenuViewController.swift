//
//  PopupMenuViewController.swift
//  SydneySights
//
//  Created by Mikhail Stetcura on 7/3/18.
//  Copyright © 2018 SML. All rights reserved.
//

import UIKit

class PopupMenuViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    var menuArray: [MenuItem]!       
    
    static func controller(menuArray: [MenuItem]) -> PopupMenuViewController? {
        let storyboard = UIStoryboard(name: "PopupMenu", bundle: Bundle.main)
        let identifier = String(describing: PopupMenuViewController.self)
        let controller = storyboard.instantiateViewController(withIdentifier: identifier) as? PopupMenuViewController
        controller?.menuArray = menuArray
        
        return controller
    }
    
    static func showMenu(menuArray: [MenuItem], from barButton: UIBarButtonItem, in parentViewController: UIViewController) {
        guard let controller = PopupMenuViewController.controller(menuArray: menuArray) else {
            return
        }
        controller.modalPresentationStyle = .popover
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            parentViewController.show(controller, sender: controller)
            return
        }
        
        let popController = controller.popoverPresentationController
        popController?.permittedArrowDirections = .any
        popController?.barButtonItem = barButton
        parentViewController.present(controller, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        preferredContentSize = CGSize(width: 250, height: menuArray.count * 50)
    }
}

extension PopupMenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell") as? MenuItemCell else {
            return UITableViewCell()
        }
        
        let item = menuArray[indexPath.row]
        cell.item = item
        
        return cell
    }
}

extension PopupMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = menuArray[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true, completion: nil)
        if UIDevice.current.userInterfaceIdiom == .phone {
            navigationController?.popViewController(animated: true)
        }
        
        item.action?()
    }
}
