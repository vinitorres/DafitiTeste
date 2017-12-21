//
//  ImageZoomViewController.swift
//  Trakt Movies
//
//  Created by Vinicius Torres on 12/21/17.
//  Copyright © 2017 Vinicius Torres. All rights reserved.
//

import Foundation
import UIKit

class ImageZoomViewController: UIViewController {
    
    @IBOutlet weak var imageIV: UIImageView!
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageIV.isUserInteractionEnabled = false
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissZoomView)))
        loadImage()
    }
    
    func loadImage() {
        
        if let zoomImage = image {
            imageIV.image = zoomImage
        }
        
    }
    
    @objc func dismissZoomView() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
