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
    @IBOutlet weak var searchBarButton: UIBarButtonItem!
    
    private let refreshControl = UIRefreshControl()
    private let searchBar = UISearchBar()
    private let fakeLeftBarButton = UIBarButtonItem()
    private let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))

    fileprivate var currentPage = 1
    fileprivate var hasNext = true
    fileprivate var searchActive = false
    fileprivate var textSearch = ""
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
        
        setLogoImage()
        
        self.title = ""
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "CatalogCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "catalogCell")
        
        refreshControl.addTarget(self, action: #selector(refreshMovieList(_:)), for: .valueChanged)
        collectionView.refreshControl = self.refreshControl
        
        searchBar.searchBarStyle = UISearchBarStyle.minimal
        searchBar.delegate = self
        searchBar.frame.size.height = 20
        fakeLeftBarButton.tintColor = .clear
        fakeLeftBarButton.title = "fake"
        
        self.loadData()
    }
    
    func setLogoImage() {
        logoImageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "logo")
        let iconSize = CGSize(width: 30, height: 30)
        UIGraphicsBeginImageContextWithOptions(iconSize, false, 0.0);
        image?.draw(in: CGRect(x:0,y:0,width: iconSize.width,height: iconSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        logoImageView.image = newImage
        
        navigationItem.titleView = logoImageView
    }
    
    func loadData() {
        
        let currentCount = movieList.returnMoviesCount()
        
        self.collectionView.backgroundView = nil
        
        if currentCount == 0 {
            self.activityIndicator.startAnimating()
        }
        
        movieList.downloadMoviesList(page: currentPage) { (result) in
            self.refreshControl.endRefreshing()
            self.activityIndicator.stopAnimating()
            if result {
                self.previousCallResult = result
                DispatchQueue.main.async {
                    if self.movieList.returnMoviesCount() < 1 {
                        self.showEmptyMessage()
                    } else {
                        if currentCount == self.movieList.returnMoviesCount() {
                            self.hasNext = false
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.showDownloadErrorMessage()
                }
            }
            self.numberOfItems = self.movieList.returnMoviesCount()
        }
    
    }
    
    func clearCollectionView() {
        movieList.clearList()
        hasNext = true
        numberOfItems = movieList.returnMoviesCount()
        currentPage = 1
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func showDownloadErrorMessage() {
        let message = "Falha ao baixar dados."
        let messageLabel = UILabel(frame: CGRect(x: 0,y: 0,width: self.view.bounds.size.width, height:  self.view.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        
        self.collectionView.backgroundView = messageLabel
    }
    
    func showEmptyMessage() {
        let message = "Nenhum filme encontrado."
        let messageLabel = UILabel(frame: CGRect(x: 0,y: 0,width: self.view.bounds.size.width, height:  self.view.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        
        self.collectionView.backgroundView = messageLabel
    }
    
    func showSearchMessage() {
        let message = "Digite o nome do filme que deseja buscar."
        let messageLabel = UILabel(frame: CGRect(x: 0,y: 0,width: self.view.bounds.size.width, height:  self.view.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        
        self.collectionView.backgroundView = messageLabel
    }
    
    @objc func refreshMovieList(_ sender: Any) {
        clearCollectionView()
        self.loadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsSegue" {
            let detailsVC = segue.destination as! DetailsViewController
            detailsVC.movie = selectedMovie
            
        }
    }
    
    //SearchBar
    
    @IBAction func showSearchBarAction(_ sender: Any) {
        if searchBarButton.image == nil {
            self.hideSearchBar()
            self.clearCollectionView()
            self.searchBar.resignFirstResponder()
            self.loadData()
        } else {
            searchActive = true
            self.clearCollectionView()
            self.showSearchMessage()
            self.showSearchBar()
        }
    }
    
    func showSearchBar() {
        searchBar.alpha = 0
        navigationItem.titleView = searchBar
        navigationItem.setLeftBarButton(nil, animated: true)
        UIView.animate(withDuration: 0.5, animations: {
            self.searchBar.alpha = 1
            self.searchBarButton.image = nil
        }, completion: { finished in
            self.searchBar.becomeFirstResponder()
        })
    }
    
    func hideSearchBar() {
        navigationItem.setLeftBarButton(searchBarButton, animated: true)
        logoImageView.alpha = 0
        navigationItem.setLeftBarButton(fakeLeftBarButton, animated: true)
        UIView.animate(withDuration: 0.3, animations: {
            self.navigationItem.titleView = self.logoImageView
            self.logoImageView.alpha = 1
            self.searchBarButton.image = UIImage(named: "search")
        }, completion: { finished in
            
        })
    }
    
    func searchForText(text: String) {
   
        self.collectionView.backgroundView = nil
        
        let currentCount = movieList.returnMoviesCount()
        
        movieList.searchMovie(searchFor: text, page: currentPage) { (result) in
            self.refreshControl.endRefreshing()
            if result {
                self.previousCallResult = result
                DispatchQueue.main.async {
                    if self.movieList.returnMoviesCount() < 1 {
                        self.showEmptyMessage()
                    } else {
                        if currentCount == self.movieList.returnMoviesCount() {
                            self.hasNext = false
                        }
                        self.collectionView.reloadData()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.showDownloadErrorMessage()
                }
            }
            self.numberOfItems = self.movieList.returnMoviesCount()
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
        print("current size of collectionView: \(numberOfItems)")
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
                if searchActive {
                    self.searchForText(text: textSearch)
                } else {
                    self.loadData()
                }
                self.previousCallResult = false
            }
        }
    }
    
}

extension CatalogViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchActive = true
        self.clearCollectionView()
        self.collectionView.backgroundView = nil
        textSearch = searchBar.text!
        self.searchForText(text: textSearch)
    }
}
