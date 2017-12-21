//
//  Service.swift
//  Trakt Movies
//
//  Created by Vinicius Torres on 12/19/17.
//  Copyright © 2017 Vinicius Torres. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class Service {
    
    static func getPopularMovies(page: Int, onComplete: @escaping (_ success: [Movie]?)->()) {
        var url = Constants.HttpRequestURL.BASE + Constants.HttpRequestURL.MOVIES_POPULAR_EXTENDED
        url = url.replacingOccurrences(of: "{page}", with: page.description)
        
        Alamofire.request(url, method: .get, parameters: nil , encoding: JSONEncoding.default ,headers: Constants.Headers.TRAKT_HEADER).responseJSON(completionHandler: { response in
            
            if response.response?.statusCode == 200 {
                
                let data = response.data!
                let jsonList =  JSON(data: data)
                var movies: [Movie] = []
                
                for json in jsonList.array! {
                    let movie = Movie(json: json)
                    movies.append(movie)
                }
                
                print(movies.count)
                
                onComplete(movies)
                
            } else { onComplete(nil) }
        })
    }
    
    static func searchMovie(searchFor: String, page: Int, onComplete: @escaping (_ success: [Movie]?)->()) {
        var url = Constants.HttpRequestURL.BASE + Constants.HttpRequestURL.SEARCH_MOVIE_EXTENDED
        url = url.replacingOccurrences(of: "{page}", with: page.description)
        url = url.replacingOccurrences(of: "{text}", with: searchFor)
        
        print(url)
        Alamofire.request(url, method: .get, parameters: nil , encoding: JSONEncoding.default ,headers: Constants.Headers.TRAKT_HEADER).responseJSON(completionHandler: { response in
            
            if response.response?.statusCode == 200 {
                
                let data = response.data!
                let jsonList =  JSON(data: data)
                var movies: [Movie] = []
                
                for json in jsonList.array! {
                    let movieType:JSON = json["movie"]
                    let movie = Movie(json: movieType)
                    movies.append(movie)
                    print(movie.name)
                }
                
                print(movies.count)
                
                onComplete(movies)
                
            } else {
                print(response.response?.statusCode)
                onComplete(nil)
            }
        })
    }
    
    static func getImagesUrlFromTMBD(movieId: String, onComplete: @escaping (_ success: (String,[String])?)->()) {
        var url = Constants.HttpRequestURL.GET_IMAGES_TMBD
        url = url.replacingOccurrences(of: "{movieId}", with: movieId)
        
        Alamofire.request(url, method: .get, parameters: nil , encoding: JSONEncoding.default ,headers: nil).responseJSON(completionHandler: { response in
            
            if response.response?.statusCode == 200 {
                
                let data = response.data!
                let jsonResult =  JSON(data: data)
                let posters: [JSON] = jsonResult["posters"].array!
                let backdrops: [JSON] = jsonResult["backdrops"].array!
                
                var backdropUrlObject: ArraySlice<JSON> = []
                
                if backdrops.count >= 10 {
                    backdropUrlObject = backdrops.prefix(10)
                } else {
                    backdropUrlObject = backdrops.prefix(backdrops.count)
                }
                
                var urlBackdrops: [String] = []
                
                for object in backdropUrlObject {
                    var backdropPath = Constants.ImageUrlFormat.BACKDROP_PATH_FORMAT
                    backdropPath = backdropPath.replacingOccurrences(of: "{backdropPath}", with: object["file_path"].stringValue)
                    urlBackdrops.append(backdropPath)
                }
                
                let posterPath = Constants.ImageUrlFormat.POSTER_PATH_FORMAT
                var posterURL = ""
                if posters.count > 0 {
                    posterURL = posterPath.replacingOccurrences(of: "{posterPath}", with: posters[0]["file_path"].stringValue)
                } else {
                    posterURL = ""
                }
                
                
                let success: (String,[String]) = (posterURL,urlBackdrops)
                
                onComplete(success)
                
            } else { onComplete(nil) }
        })
    }
    
}
