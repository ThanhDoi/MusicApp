//
//  ListFlowLayout.swift
//  MusicPlayer
//
//  Created by Thanh Doi on 6/21/17.
//  Copyright © 2017 Thanh Doi. All rights reserved.
//

import UIKit

class ListFlowLayout: UICollectionViewFlowLayout {
    let itemHeight: CGFloat = 75
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    func setupLayout() {
        minimumInteritemSpacing = 10
        minimumLineSpacing = 10
        scrollDirection = .vertical
    }
    
    func itemWidth() -> CGFloat {
        return (collectionView?.frame.width)!
    }
    
    override var itemSize: CGSize {
        set {
            self.itemSize = CGSize(width: itemWidth(), height: itemHeight)
        }
        get {
            return CGSize(width: itemWidth(), height: itemHeight)
        }
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return collectionView!.contentOffset
    }
}
