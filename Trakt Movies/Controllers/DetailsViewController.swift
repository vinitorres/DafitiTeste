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
    
    @IBOutlet weak var galleryScrollView: UIScrollView!
    @IBOutlet weak var galleryPageControl: UIPageControl!
    
    var movie: Movie?
    var imageToZoom: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black]
        
        let didRotate: (Notification) -> Void = { notification in
            for view in self.galleryScrollView.subviews {
                view.removeFromSuperview()
            }
            self.loadValues()
        }
        
        NotificationCenter.default.addObserver(forName: .UIDeviceOrientationDidChange, object: nil, queue: .main, using: didRotate)
        
        galleryScrollView.delegate = self
        
        loadValues()
    }
    
    func loadValues() {
        
        if let currentMovie = movie {
            
            imageIV.kf.indicatorType = .activity
            
            Service.getImagesUrlFromTMBD(movieId: currentMovie.id) { (images) in
                if let imagesUrlResult = images {
                    let resource = ImageResource(downloadURL: URL(string: imagesUrlResult.0)!, cacheKey: imagesUrlResult.0)
                    self.imageIV.isUserInteractionEnabled = true
                    self.imageIV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleZoomTap)))
                    self.imageIV.kf.setImage(with: resource, placeholder: nil, options: nil, progressBlock: { (received, total) in
                        self.imageIV.kf.indicator?.startAnimatingView()
                    }, completionHandler: { (image, error, cache, url) in
                        self.imageIV.kf.indicator?.stopAnimatingView()
                        self.imageIV.kf.indicatorType = .none
                    })
                    
                    if imagesUrlResult.1.count > 0 {
                        self.galleryPageControl.numberOfPages = imagesUrlResult.1.count
                        for i in 0..<imagesUrlResult.1.count {
                            
                            let imageView = UIImageView()
                            imageView.contentMode = .scaleAspectFit
                            imageView.isUserInteractionEnabled = true
                            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleZoomTap)))
                            let resourceBackdrop = ImageResource(downloadURL: URL(string: imagesUrlResult.1[i])!, cacheKey: imagesUrlResult.1[i])

                            imageView.kf.setImage(with: resourceBackdrop, placeholder: nil, options: nil, progressBlock: { (received, total) in
                                self.imageIV.kf.indicator?.startAnimatingView()
                            }, completionHandler: { (image, error, cache, url) in
                                self.imageIV.kf.indicator?.stopAnimatingView()
                                self.imageIV.kf.indicatorType = .none
                            })
                            let xPosition = self.galleryScrollView.frame.width * CGFloat(i)
                            imageView.frame = CGRect(x:xPosition,y:0,width: self.galleryScrollView.frame.width,height: self.galleryScrollView.frame.height)
                            
                            self.galleryScrollView.contentSize.width = self.galleryScrollView.frame.width * CGFloat(i + 1)
                            self.galleryScrollView.addSubview(imageView)
                        }
                    } else {
                        self.galleryPageControl.numberOfPages = 1

                        let imageView = UIImageView()
                        imageView.contentMode = .scaleAspectFit
                        imageView.isUserInteractionEnabled = false
                        imageView.image = UIImage(named: "placeholder")
                        let xPosition = self.galleryScrollView.frame.width * CGFloat(0)
                        imageView.frame = CGRect(x:xPosition,y:0,width: self.galleryScrollView.frame.width,height: self.galleryScrollView.frame.height)
                        
                        self.galleryScrollView.contentSize.width = self.galleryScrollView.frame.width * CGFloat(0 + 1)
                        self.galleryScrollView.addSubview(imageView)
                    }
                } else {
                    self.imageIV.image = UIImage(named: "placeholder")
                }
            }
            
            
            self.title = currentMovie.name
            taglineLabel.text = currentMovie.tagline
            ratingLabel.text = String(format: "%.1f", currentMovie.rating)
            releaseDateLabel.text = currentMovie.formatedDateRelease()
            runtimeLabel.text = "\(currentMovie.runtime) minutes"
            genresLabel.text = currentMovie.displayGenres()
            overviewLabel.text = currentMovie.overview
        }
        
    }

    //zoom image
    
    @objc func handleZoomTap(sender: UITapGestureRecognizer) {
        print("zoom tap")
        imageToZoom = (sender.view as! UIImageView).image
        performSegue(withIdentifier: "zoomSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "zoomSegue"  {
            let zoomVC = segue.destination as! ImageZoomViewController
            zoomVC.image = self.imageToZoom
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.loadValues()
    }

}

extension DetailsViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(galleryScrollView.contentOffset.x / galleryScrollView.frame.size.width)
        galleryPageControl.currentPage = Int(pageNumber)
    }
    
}
