//
//  MeMeTableViewController.swift
//  MeMe
//
//  Created by Rodion Konioshko on 06/12/2019.
//  Copyright © 2019 Rodion Konioshko. All rights reserved.
//

import Foundation
import UIKit
class MeMeTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet var memeTableView: UITableView!
    var memes: [MemeModel]! = []
    var selectedRow:Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName:"plus"), style: .plain, target: self, action: #selector(add))
        memeTableView.dataSource = self
        memeTableView.delegate = self
        memeTableView.tableFooterView = UIView()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeMeTableCell", for: indexPath) as! MeMeTableCell
                cell.memeImage.image = memes[indexPath.row].memedImage
                cell.memeText.text? = "\(memes[indexPath.row].topText)...\(memes[indexPath.row].botText)"
                return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    @objc func add(){
        performSegue(withIdentifier: "tableToMemeSegue", sender:self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "tableToMemeSegue"){
            (segue.destination as! MeMeViewController).tableViewController = self
            (segue.destination as! MeMeViewController).memeTabBarController = tabBarController
        }
        else if (segue.identifier == "memeDetailSegue"){
            (segue.destination as! MeMeDetailViewController).memeImage = memes[selectedRow].memedImage
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        performSegue(withIdentifier: "memeDetailSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(memes.capacity != (tabBarController as! MeMeTabBarController).memes.capacity){
            memes = (tabBarController as! MeMeTabBarController).memes
            memeTableView.reloadData()
        }
    }
}
