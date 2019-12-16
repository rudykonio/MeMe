//
//  MeMeCollectionViewController.swift
//  MeMe
//
//  Created by Rodion Konioshko on 06/12/2019.
//  Copyright © 2019 Rodion Konioshko. All rights reserved.
//

import Foundation
import UIKit
class MeMeCollectionViewController: UICollectionViewController{
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    var memes: [MemeModel]! = []
    var selectedRow:Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName:"plus"), style: .plain, target: self, action: #selector(add))
        let space:CGFloat = 3.0
        collectionViewFlowLayout.minimumInteritemSpacing = space
        collectionViewFlowLayout.minimumLineSpacing = space
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        collectionViewFlowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeMeCollectionCell", for: indexPath) as! MeMeCollectionCell
        cell.memeImage.image = memes[indexPath.row].memedImage
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        performSegue(withIdentifier: "memeDetailSegue", sender: self)
        collectionView.deselectItem(at:indexPath,animated: false)
    }
    
    @objc func add(){
        performSegue(withIdentifier: "collectionToMeMeSegue", sender:self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "collectionToMeMeSegue"){
            (segue.destination as! MeMeViewController).collectionViewController = self
            (segue.destination as! MeMeViewController).memeTabBarController = tabBarController
        }else if(segue.identifier == "memeDetailSegue"){
            (segue.destination as! MeMeDetailViewController).memeImage = memes[selectedRow].memedImage
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(memes.capacity != (tabBarController as! MeMeTabBarController).memes.capacity){
            memes = (tabBarController as! MeMeTabBarController).memes
            collectionView.reloadData()
        }
    }
    
}
