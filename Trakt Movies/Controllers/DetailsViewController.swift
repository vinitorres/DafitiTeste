//
//  DetailsViewController.swift
//  Trakt Movies
//
//  Created by Vinicius Torres on 12/19/17.
//  Copyright © 2017 Vinicius Torres. All rights reserved.
//

import UIKit
import Kingfisher

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var imageIV: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!

    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadValues()
    }
    
    func loadValues() {
        
        if movie != nil {
            
            imageIV.kf.indicatorType = .activity
            
            let resource = ImageResource(downloadURL: URL(string: (movie?.images.posterUrl)!)!, cacheKey: movie?.images.posterUrl)
            
            imageIV.kf.setImage(with: resource, placeholder: nil, options: nil, progressBlock: { (received, total) in
                self.imageIV.kf.indicator?.startAnimatingView()
            }, completionHandler: { (image, error, cache, url) in
                self.imageIV.kf.indicator?.stopAnimatingView()
                self.imageIV.kf.indicatorType = .none
            })
            
            
            self.title = movie?.name
            taglineLabel.text = movie?.tagline
            releaseDateLabel.text = movie?.releaseDate
            runtimeLabel.text = "\(movie?.runtime ?? "") minutes"
            genresLabel.text = movie?.displayGenres()
            overviewLabel.text = movie?.overview
            
            
        }
        
    }
    
    
}

