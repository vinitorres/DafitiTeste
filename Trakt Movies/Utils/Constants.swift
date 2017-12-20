//
//  Constants.swift
//  Trakt Movies
//
//  Created by Vinicius Torres on 12/19/17.
//  Copyright © 2017 Vinicius Torres. All rights reserved.
//

import Foundation

class Constants {
    
    private static let API_KEY_TMBD = "8e778ba5d415f5223bd045dc2e173dce"
    
    struct Colors {
        static let THEME = "#4A5253"
    }
    
    struct HttpRequestURL {
        static let BASE: String = "https://api.trakt.tv/"
        static let MOVIES_POPULAR_EXTENDED = "movies/popular?extended=full&limit=20"
        static let GET_IMAGES_TMBD = "https://api.themoviedb.org/3/movie/{movieId}/images?api_key=\(API_KEY_TMBD)"
        static let BASE_URL_TMBD = "https://image.tmdb.org/t/p/"
    }
    
    struct Headers {
        static let POPULAR_MOVIES_HEADER = [
            "Content-Type":"application/json",
            "trakt-api-version":"2",
            "trakt-api-key":"ae62a8012a8234485bfbcd2f5e7d3408aae65eb7ebac7b03181890ee30512164",
            "Content-Length":"0"
        ]
    }
    
}

