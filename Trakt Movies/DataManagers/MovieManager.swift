//
//  MovieManager.swift
//  Trakt Movies
//
//  Created by Vinicius Torres on 12/19/17.
//  Copyright © 2017 Vinicius Torres. All rights reserved.
//

import Foundation

class MovieManager {
    
    private var movies: [Movie] = []
    
    func returnMoviesCount() -> Int {
        return movies.count
    }
    
    func addMovie(movie: Movie) {
        movies.append(movie)
    }
    
    func clearList() {
        movies.removeAll()
    }
    
    func getMovieAtIndex(index: Int) -> Movie {
        return movies[index]
    }
    
    func downloadMoviesList(page: Int, onComplete: @escaping (_ success: Bool)->()) {
        
        Service.getPopularMovies(page: page) { (resultMovies) in
            
            var result = false
            
            guard let moviesDownloaded = resultMovies else {
                print("Falha ao baixar os dados")
                onComplete(result)
                return
            }
            
            if moviesDownloaded.count > 0 {
                for movie in moviesDownloaded {
                    self.movies.append(movie)
                }
                result = true
            }
            onComplete(result)
        }
    }
    
    func searchMovie(searchFor: String, page: Int, onComplete: @escaping (_ success: Bool)->()) {
        
        Service.searchMovie(searchFor: searchFor, page: page) { (resultMovies) in
            var result = false
            
            guard let moviesDownloaded = resultMovies else {
                print("Falha ao baixar os dados")
                onComplete(result)
                return
            }
            
            if moviesDownloaded.count > 0 {
                for movie in moviesDownloaded {
                    self.movies.append(movie)
                }
                result = true
            }
            onComplete(result)
        }
    }
    
}
