//
//  Movie.swift
//  Trakt Movies
//
//  Created by Vinicius Torres on 12/19/17.
//  Copyright © 2017 Vinicius Torres. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Movie {
    
    let id: String
    let name: String
    let releaseDate: String
    let runtime: String
    let tagline: String
    let overview: String
    let rating: Float
    let genres: [String]
    let images: ImageMovie
   
    init(json: JSON) {
        
        let ids:JSON = json["ids"]
        
        self.id = ids["tmdb"].stringValue
        self.name = json["title"].stringValue
        self.releaseDate = json["released"].stringValue
        self.runtime = json["runtime"].stringValue
        self.tagline = json["tagline"].stringValue
        self.overview = json["overview"].stringValue
        self.rating = json["rating"].floatValue
        self.genres = json["genres"].arrayObject as? [String] ?? [""]
        self.images = ImageMovie(movieId: id)

    }
    
    func displayGenres() -> String {
        return genres.first!
    }
    
}

