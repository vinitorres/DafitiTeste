//
//  Constants.swift
//  Trakt Movies
//
//  Created by Vinicius Torres on 12/19/17.
//  Copyright © 2017 Vinicius Torres. All rights reserved.
//

import Foundation

class Constants {
    
    private static let API_KEY_TRAKT = "ae62a8012a8234485bfbcd2f5e7d3408aae65eb7ebac7b03181890ee30512164"
    private static let API_KEY_TMDB = "8e778ba5d415f5223bd045dc2e173dce"

    struct HttpRequestURL {
        static let BASE: String = "https://api.trakt.tv/"
        static let MOVIES_POPULAR_EXTENDED = "movies/popular?extended=full&&page={page}&limit=20"
        static let SEARCH_MOVIE_EXTENDED = "search/movie?query={text}&field=title&extended=full&limit=20&page={page}"
        static let GET_IMAGES_TMBD = "https://api.themoviedb.org/3/movie/{movieId}/images?api_key=\(API_KEY_TMDB)"
        static let BASE_URL_TMBD = "https://image.tmdb.org/t/p/"
    }
    
    struct Headers {
        static let TRAKT_HEADER = [
            "Content-Type":"application/json",
            "trakt-api-version":"2",
            "trakt-api-key":API_KEY_TRAKT
        ]
    }
    
    struct ImageUrlFormat {
        static let POSTER_PATH_FORMAT = HttpRequestURL.BASE_URL_TMBD + "w500{posterPath}"
        static let BACKDROP_PATH_FORMAT = HttpRequestURL.BASE_URL_TMBD + "w780{backdropPath}"
    }
    
}

