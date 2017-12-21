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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    func prepare(movie: Movie) {
        
        nameLabel.text = movie.name
        releaseDateLabel.text = movie.formatedDateYear()
        
        Service.getImagesUrlFromTMBD(movieId: movie.id) { (images) in
            if let imagesUrlResult = images {
                self.imageIV.kf.indicatorType = .activity
                if imagesUrlResult.0 != "" {
                    let resource = ImageResource(downloadURL: URL(string: imagesUrlResult.0)!, cacheKey: movie.name)
                    self.self.imageIV.kf.setImage(with: resource, placeholder: nil, options: nil, progressBlock: { (received, total) in
                        self.imageIV.kf.indicator?.startAnimatingView()
                    }, completionHandler: { (image, error, cache, url) in
                        self.imageIV.kf.indicator?.stopAnimatingView()
                        self.imageIV.kf.indicatorType = .none
                    })
                } else {
                    self.imageIV.image = UIImage(named: "placeholder")
                }
            } else {
                self.imageIV.image = UIImage(named: "placeholder")
            }
        }
    }
    
}
