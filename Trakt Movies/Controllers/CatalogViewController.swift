//
//  CatalogViewController.swift
//  Trakt Movies
//
//  Created by Vinicius Torres on 12/19/17.
//  Copyright © 2017 Vinicius Torres. All rights reserved.
//

import UIKit

class CatalogViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    private let refreshControl = UIRefreshControl()

    fileprivate var currentPage = 1
    fileprivate var hasNext = true
    fileprivate var previousCallResult = false
    
    var movieList = MovieManager()
    var selectedMovie: Movie?
    var viewSize = CGSize()

    var numberOfItems: Int = 0 {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ""
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "CatalogCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "catalogCell")
        
        refreshControl.addTarget(self, action: #selector(refreshMovieList(_:)), for: .valueChanged)
        collectionView.refreshControl = self.refreshControl
        
        self.loadData()
    }
    
    func loadData() {
        
        let currentCount = movieList.returnMoviesCount()
        
        movieList.downloadMoviesList(page: currentPage) { (result) in
            self.refreshControl.endRefreshing()
            if result {
                self.previousCallResult = result
                DispatchQueue.main.async {
                    if self.movieList.returnMoviesCount() < 1 {
                        
                        self.numberOfItems = self.movieList.returnMoviesCount()
                        
                        let message = "Nenhum filme encontrado."
                        let messageLabel = UILabel(frame: CGRect(x: 0,y: 0,width: self.view.bounds.size.width, height:  self.view.bounds.size.height))
                        messageLabel.text = message
                        messageLabel.textColor = UIColor.black
                        messageLabel.numberOfLines = 0
                        messageLabel.textAlignment = .center
                        messageLabel.sizeToFit()
                        
                        self.collectionView.backgroundView = messageLabel
                        
                    } else {
                        
                        self.numberOfItems = self.movieList.returnMoviesCount()
                        
                        if currentCount == self.movieList.returnMoviesCount() {
                            self.hasNext = false
                        }
                        
                    }
                }
            } else {
                DispatchQueue.main.async {
                    
                    //self.activityIndicator.removeFromSuperview()
                    
                    let message = "Falha ao baixar dados."
                    let messageLabel = UILabel(frame: CGRect(x: 0,y: 0,width: self.view.bounds.size.width, height:  self.view.bounds.size.height))
                    messageLabel.text = message
                    messageLabel.textColor = UIColor.black
                    messageLabel.numberOfLines = 0;
                    messageLabel.textAlignment = .center;
                    messageLabel.sizeToFit()
                    
                    self.collectionView.backgroundView = messageLabel;
                }
            }
        }
    
    }
    
    @objc func refreshMovieList(_ sender: Any) {
        movieList.clearList()
        currentPage = 1
        self.loadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsSegue" {
            let detailsVC = segue.destination as! DetailsViewController
            detailsVC.movie = selectedMovie
            
        }
    }
}

extension CatalogViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        collectionView.collectionViewLayout.invalidateLayout()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMovie = movieList.getMovieAtIndex(index:indexPath.row)
        self.performSegue(withIdentifier: "detailsSegue", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "catalogCell", for: indexPath) as! CatalogCollectionViewCell
        cell.prepare(movie: movieList.getMovieAtIndex(index: indexPath.row))
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height {
            print(movieList.returnMoviesCount())
            if hasNext && previousCallResult {
                self.currentPage += 1
                self.loadData()
                self.previousCallResult = false
            }
        }
    }
    
}

