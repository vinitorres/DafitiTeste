//
//  ImageMovie.swift
//  Trakt Movies
//
//  Created by Vinicius Torres on 12/19/17.
//  Copyright © 2017 Vinicius Torres. All rights reserved.
//

import Foundation

class ImageMovie {
    
    var posterUrl: String = ""
    var backdropImagesUrl: [String] = []
    
    init(movieId: String) {
        Service.getImagesUrlFromTMBD(movieId: movieId, onComplete: { (images) in
            if images != nil {
                self.posterUrl = "https://image.tmdb.org/t/p/w500\(images?.0 ?? "")"
                for imageBackdropurl in (images?.1)! {
                    self.backdropImagesUrl.append("\(Constants.HttpRequestURL.BASE_URL_TMBD)/w780\(imageBackdropurl)")
                }
            } else {
                
            }
        })
    }
    
}
