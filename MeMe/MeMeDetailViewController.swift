//
//  MeMeDetailViewController.swift
//  MeMe
//
//  Created by Rodion Konioshko on 15/12/2019.
//  Copyright © 2019 Rodion Konioshko. All rights reserved.
//

import Foundation
import UIKit
class MeMeDetailViewController : UIViewController{
    @IBOutlet weak var memeImageView: UIImageView!
    var memeImage : UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        if(memeImage != nil){
        memeImageView.image = memeImage
        }
    }
}
