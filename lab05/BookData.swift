//
//  BookData.swift
//  lab05
//
//  Created by Saauren Mankad on 4/4/2022.
//

import UIKit

class BookData: NSObject, Decodable {
    var isbn13: String?
    var title: String
    var authors: String?
    var publisher: String?
    var publicationDate: String?
    var bookDescription: String?
    var imageURL: String?
    
    private enum RootKeys: String, CodingKey {
        case volumeInfo
    }
    
    private enum BookKeys: String, CodingKey {
        
        case title
        case publisher
        case publicationDate = "publishedDate"
        case bookDescription = "description"
        case authors
        case industryIdentifiers
        case imageLinks
        
        
    }
    
    private enum ImageKeys: String, CodingKey {
        
        case smallThumbnail
        
    }
    
    
    private struct ISBNCode: Decodable {
        
        var type: String
        var identifier: String
        
    }
    
    required init(from decoder: Decoder) throws {
        // Get the root container first
        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
        
        // Get the book container for most info
        let bookContainer = try rootContainer.nestedContainer(keyedBy: BookKeys.self, forKey: .volumeInfo)
        // Get the image links container for the thumbnail
        let imageContainer = try? bookContainer.nestedContainer(keyedBy: ImageKeys.self, forKey: .imageLinks)
        
        // get the book info
        title = try bookContainer.decode(String.self, forKey: .title)
        publisher = try? bookContainer.decode(String.self, forKey: .publisher)
        publicationDate = try? bookContainer.decodeIfPresent(String.self, forKey: .publicationDate)
        bookDescription = try? bookContainer.decode(String.self, forKey: .bookDescription)
        
        // Get authors as an array then compact
        if let authorArray = try? bookContainer.decode([String].self, forKey: .authors) {
            authors = authorArray.joined(separator: ", ")
           
       }
        
        if let isbnCodes = try? bookContainer.decodeIfPresent([ISBNCode].self, forKey: .industryIdentifiers) {
            
            for code in isbnCodes {
                
                if code.type == "ISBN_13" {
                    isbn13 = code.identifier
                }
            }
            
        }
        
        // Lastly get the image thumbnail from the imagecontainer
        
        imageURL = try imageContainer?.decodeIfPresent(String.self, forKey: .smallThumbnail)
        
    }
    
}
