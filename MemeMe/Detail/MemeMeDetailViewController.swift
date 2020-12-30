//
//  MemeMeDetailViewController.swift
//  MemeMe
//
//  Created by Lixiang Zhang on 12/29/20.
//

import UIKit

class MemeMeDetailViewController: UIViewController {
    
    @IBOutlet weak var memeImage: UIImageView!
    
    var image: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        memeImage.image = image
    }
}
