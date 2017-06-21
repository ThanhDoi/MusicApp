//
//  MainViewController.swift
//  MusicPlayer
//
//  Created by Thanh Doi on 5/22/17.
//  Copyright © 2017 Thanh Doi. All rights reserved.
//

import UIKit

enum tabSelecting: Int {
    case songs = 0
    case albums
    case artists
}

var currentTab: Int = 0

class MainViewController: UIViewController {
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var songTypeButton: UIButton!
    var isListView = true
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureSearchController()
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().rearViewRevealWidth = 100
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.reloadData()
    }
    
    func configureSearchController() {
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchView.addSubview(searchController.searchBar)
        searchView.isHidden = true
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
        navView.isHidden = true
        searchView.isHidden = false
    }
    
    @IBAction func songTypeButtonAction(_ sender: Any) {
        if isListView {
            songTypeButton.setImage(UIImage(named: "grid"), for: .normal)
            isListView = false
        } else {
            songTypeButton.setImage(UIImage(named: "list"), for: .normal)
            isListView = true
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        let width = screenSize.width
        return CGSize(width: width/3, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index: tabSelecting = tabSelecting(rawValue: indexPath.row)!
        switch index {
        case .songs:
            currentTab = 0
        case .artists:
            currentTab = 1
        case .albums:
            currentTab = 2
        }
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tabCell", for: indexPath) as!TabCollectionViewCell
        
        cell.tabLabel.text = items[indexPath.row]
        cell.tabLabel.textColor = UIColor.white
        cell.tabLabel.sizeToFit()
        cell.backgroundColor = UIColor.blue
        
        return cell
    }
}

// MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navView.isHidden = false
        self.searchView.isHidden = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text
        self.titleLabel.text = text
        self.navView.isHidden = false
        self.searchController.searchBar.resignFirstResponder()
        self.searchView.isHidden = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchController.isActive = false
    }
}
