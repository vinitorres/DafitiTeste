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
   
    init(json: JSON) {
        let ids:JSON = json["ids"]
        
        self.id = ids["tmdb"].stringValue
        self.name = json["title"].stringValue
        self.releaseDate = json["released"].stringValue
        self.runtime = json["runtime"].stringValue
        self.tagline = json["tagline"].stringValue
        self.overview = json["overview"].stringValue
        self.rating = json["rating"].floatValue
        self.genres = json["genres"].arrayObject as! [String]
    }
    
    func displayGenres() -> String {
        if genres.count > 0 {
            return genres.joined(separator: ",")
        } else {
            return "Not Available"
        }
    }
    
    func formatedDateYear() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy"
        
        let date: Date? = dateFormatterGet.date(from: releaseDate)
        
        if date != nil {
            return dateFormatterPrint.string(from: date!)
        } else {
            return "Not Available"
        }
        
    }
    
    func formatedDateRelease() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd, MMM, yyyy"
        
        let date: Date? = dateFormatterGet.date(from: releaseDate)
        
        if date != nil {
            return dateFormatterPrint.string(from: date!)
        } else {
            return "Not Available"
        }
    }
    
}

