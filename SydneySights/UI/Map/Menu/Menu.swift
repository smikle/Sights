//
//  Menu.swift
//  SydneySights
//
//  Created by Mikhail Stetcura on 7/3/18.
//  Copyright © 2018 SML. All rights reserved.
//

import UIKit

protocol MenuProtocol: class {
    var items: [MenuItem]! { get }
    func configureItem(at index: Int, imageAlpha: CGFloat)
}

class Menu: MenuProtocol {
    
    enum ItemType: Int {
        case mapType = 0
        case showTraffic
        case search
        case openInApple
        case openInGoogle
    }
    
    private weak var delegate: MapMenuProtocol?
    private var showingTrafficItem: MenuItem!
    
    public private (set) var items: [MenuItem]!
    
    //MARK: -
    
    init(_ delegate: MapMenuProtocol, items: [MenuItem]) {
        self.delegate = delegate
        self.items = configuredMenu(delegate)
    }
    
    private func configuredMenu(_ delegate: MapMenuProtocol?) -> [MenuItem] {
        var array = [MenuItem]()
        var item = MenuItem(title: "Map type", image: UIImage(named: "map_type"), action: { [weak delegate] in
            delegate?.nextMapType()
        })
        array.append(item)
        
        showingTrafficItem = MenuItem(title: "Show traffic", image: UIImage(named: "traffic"), action: { [weak delegate] in
            delegate?.changeShowingTraffic()
        })
        array.append(showingTrafficItem)
        
        item = MenuItem(title: "Search", image: UIImage(named: "search"), action: { [weak delegate] in
            delegate?.search()
        })
        array.append(item)
        
        item = MenuItem(title: "Open in external Apple maps", image: UIImage(named: "apple_maps"), action: { [weak delegate] in
            delegate?.open(in: "maps.apple.com")
        })
        array.append(item)
        
        item = MenuItem(title: "Open in external Google maps", image: UIImage(named: "google_maps"), action: { [weak delegate] in
            delegate?.open(in: "maps.google.com")
        })
        array.append(item)
        
        return array
    }

    //MARK: -
    
    func configureItem(at index: Int, imageAlpha: CGFloat) {
        guard index < items.count else {
            return
        }
        
        items[index].imageAlpha = imageAlpha
    }
}
