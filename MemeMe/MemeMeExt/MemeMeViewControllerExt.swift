//
//  BaseMemeMe.swift
//  MemeMe
//
//  Created by Lixiang Zhang on 12/29/20.
//

import UIKit

extension UIViewController {
    
    // MARK: Shared DataSource
    
    var memes: [Meme] {
        return (UIApplication.shared.delegate as? AppDelegate)?.memes ?? [Meme]()
    }
    
    // MARK: Storyboard Identifiers
    
    var tableViewReusableCellId: String {
        "MemeMeTableViewCell"
    }
    
    var collectionViewReusableCellId: String {
        "MemeMeCollectionViewCell"
    }
    
    var detailSegueId: String {
        "MemeMeDetailSegue"
    }
    
    var detailViewControllerId: String {
        "MemeMeDetailViewController"
    }
}
