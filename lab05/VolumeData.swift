//
//  VolumeData.swift
//  lab05
//
//  Created by Saauren Mankad on 4/4/2022.
//

import UIKit

class VolumeData: NSObject, Decodable {
    
    var books: [BookData]?
    
    
    private enum CodingKeys: String, CodingKey {
        case books = "items"
    }
    
    
}
