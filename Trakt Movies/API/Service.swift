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
        url = url + "&page=\(page)&limit=20"
        
        Alamofire.request(url, method: .get, parameters: nil , encoding: JSONEncoding.default ,headers: Constants.Headers.POPULAR_MOVIES_HEADER).responseJSON(completionHandler: { response in
            
            if response.response?.statusCode == 200 {
                
                let data = response.data!
                let jsonList =  JSON(data: data)
                var movies: [Movie] = []
                
                for json in jsonList.array! {
                    let game = Movie(json: json)
                    movies.append(game)
                }
                
                print(movies.count)
                
                onComplete(movies)
                
            } else { onComplete(nil) }
        })
    }
    
    static func searchMovie(searchFor: String, page: Int, onComplete: @escaping (_ success: [Movie]?)->()) {
        var url = Constants.HttpRequestURL.BASE + Constants.HttpRequestURL.MOVIES_POPULAR_EXTENDED
        url = url + "&page=\(page)"
        
        Alamofire.request(url, method: .get, parameters: nil , encoding: JSONEncoding.default ,headers: Constants.Headers.POPULAR_MOVIES_HEADER).responseJSON(completionHandler: { response in
            
            if response.response?.statusCode == 200 {
                
                let data = response.data!
                let jsonList =  JSON(data: data)
                var movies: [Movie] = []
                
                for json in jsonList.array! {
                    let game = Movie(json: json)
                    movies.append(game)
                }
                
                print(movies.count)
                
                onComplete(movies)
                
            } else { onComplete(nil) }
        })
    }
    
    static func getImagesUrlFromTMBD(movieId: String, onComplete: @escaping (_ success: (String,[String])?)->()) {
        var url = Constants.HttpRequestURL.GET_IMAGES_TMBD
        url = url.replacingOccurrences(of: "{movieId}", with: movieId)
        
        Alamofire.request(url, method: .get, parameters: nil , encoding: JSONEncoding.default ,headers: Constants.Headers.POPULAR_MOVIES_HEADER).responseJSON(completionHandler: { response in
            
            if response.response?.statusCode == 200 {
                
                let data = response.data!
                let jsonResult =  JSON(data: data)
                let posters: [JSON] = jsonResult["posters"].array!
                let backdrops: [JSON] = jsonResult["backdrops"].array!
                let firstTenBackdropImages = backdrops[0...5]
                var urlBackdrops: [String] = []
                
                for object in firstTenBackdropImages {
                    urlBackdrops.append(object["file_path"].stringValue)
                }
                
                let posterURL = posters.first!["file_path"].stringValue
                
                let success: (String,[String]) = (posterURL,urlBackdrops)
                
                onComplete(success)
                
            } else { onComplete(nil) }
        })
    }
    
}
