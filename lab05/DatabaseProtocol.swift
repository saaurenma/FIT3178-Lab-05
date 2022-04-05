//
//  DatabaseProtocol.swift
//  lab05
//
//  Created by Saauren Mankad on 4/4/2022.
//

import Foundation

protocol DatabaseListener: AnyObject {
    
    func onBookListChange(booklist: [Book])
    
}

protocol DatabaseProtocol: AnyObject {
    
    func cleanup()


    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    func addBook(bookData: BookData) -> Book
    
    func deleteBook(book: Book)

    
    
}
