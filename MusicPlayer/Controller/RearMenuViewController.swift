//
//  RearMenuViewController.swift
//  MusicPlayer
//
//  Created by Thanh Doi on 5/22/17.
//  Copyright © 2017 Thanh Doi. All rights reserved.
//

import UIKit

class RearMenuViewController: UITableViewController {
    
    var mainVC: MainViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rearCell", for: indexPath) as! RearMenuViewCell
        cell.rearLabel.text = items[indexPath.row]
        cell.rearLabel.textColor = UIColor.white
        cell.backgroundColor = UIColor.gray
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: rearMenuClicked), object: indexPath)
    }
}
