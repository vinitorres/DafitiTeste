//
//  CatalogGridFlowLayout.swift
//  Trakt Movies
//
//  Created by Vinicius Torres on 12/19/17.
//  Copyright © 2017 Vinicius Torres. All rights reserved.
//

import Foundation
import UIKit

class CatalogGridFlowLayout: UICollectionViewFlowLayout {
    
    var itemHeight: CGFloat = 180
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    func setupLayout() {
        self.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8)
        minimumInteritemSpacing = 2
        minimumLineSpacing = 8
        scrollDirection = .vertical
    }
    
    func itemWidth() -> CGFloat {
        switch UIDevice.current.orientation {
        case .portrait,.portraitUpsideDown:
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                itemHeight = 300
                return collectionView!.frame.width/3 - 12
            } else {
                itemHeight = 240
                return collectionView!.frame.width/2 - 12
            }
        case .landscapeRight,.landscapeLeft:
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                itemHeight = 300
                return collectionView!.frame.width/4 - 12
            } else {
                itemHeight = 240
                return collectionView!.frame.width/3 - 12
            }
        default:
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                itemHeight = 300
                return collectionView!.frame.width/3 - 12
            } else {
                itemHeight = 240
                return collectionView!.frame.width/2 - 12
            }
        }
    
     
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
