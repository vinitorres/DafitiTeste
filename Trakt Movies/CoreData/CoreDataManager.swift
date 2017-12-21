//
//  CoreDataManager.swift
//  Trakt Movies
//
//  Created by Vinicius Torres on 12/20/17.
//  Copyright © 2017 Vinicius Torres. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    
    static func getContext () -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
        
    }
    
    static func saveToFavorites(movie: Movie, onComplete: @escaping (_ success: Bool)->()) {
        
        let context = self.getContext()
    
        let entity =  NSEntityDescription.entity(forEntityName: "Movie", in: context)
        
        let movieEntity = NSManagedObject(entity: entity!, insertInto: context)
        
        
        movieEntity.setValue(movie.id, forKey: "id")
        movieEntity.setValue(movie.name, forKey: "name")
        movieEntity.setValue(movie.releaseDate, forKey: "releaseDate")
        movieEntity.setValue(movie.runtime, forKey: "runtime")
        movieEntity.setValue(movie.tagline, forKey: "tagline")
        movieEntity.setValue(movie.overview, forKey: "overview")
        movieEntity.setValue(movie.rating, forKey: "rating")
        movieEntity.setValue(movie.genres, forKey: "genres")
        movieEntity.setValue(movie.posterUrl, forKey: "posterUrl")
        movieEntity.setValue(movie.backdropImagesUrl, forKey: "backdropImagesUrl")
        movieEntity.setValue(movie.favorite, forKey: "favorite")

        
        do {
            try context.save()
            print("movie add")
            onComplete(true)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
            onComplete(false)
        }
    }
    
    static func getMovies() -> [Movie] {
        
        var movies: [Movie] = []
        
        do {
            
            let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
  
            let searchResults = try self.getContext().fetch(fetchRequest)
            
            for movie in searchResults as [NSManagedObject] {
                movies.append(movie as! Movie)
            }
            
        } catch {
            print("Error with request: \(error)")
        }
        
        return movies
    }
    
    static func removeMovie(movie: Movie) {
        
        let context = self.getContext()
        
        do {
            context.delete(movie)
            try context.save()
            
        } catch {
            print("Error with request: \(error)")
        }
        
    }
    
}
