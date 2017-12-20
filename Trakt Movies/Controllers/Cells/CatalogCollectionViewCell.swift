//
//  CatalogCollectionViewCell.swift
//  Trakt Movies
//
//  Created by Vinicius Torres on 12/19/17.
//  Copyright © 2017 Vinicius Torres. All rights reserved.
//

import UIKit
import Kingfisher

class CatalogCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var releaseDateLabel: UILabel!
    @IBOutlet var imageIV: UIImageView!
    
    @IBOutlet weak var backgroundInfoViewWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.clear.cgColor
    }
    
    func prepare(movie: Movie) {
        
        nameLabel.text = movie.name
        releaseDateLabel.text = movie.releaseDate
        
        if movie.images.posterUrl != "" {
            imageIV.kf.indicatorType = .activity
            let resource = ImageResource(downloadURL: URL(string: movie.images.posterUrl)!, cacheKey: movie.images.posterUrl)
            imageIV.kf.setImage(with: resource, placeholder: nil, options: nil, progressBlock: { (received, total) in
                self.imageIV.kf.indicator?.startAnimatingView()
            }, completionHandler: { (image, error, cache, url) in
                self.imageIV.kf.indicator?.stopAnimatingView()
                self.imageIV.contentMode = .scaleAspectFit
                self.backgroundInfoViewWidth.constant = (image?.size.width)!
                self.imageIV.kf.indicatorType = .none
            })
        }
        
    }
    
}
