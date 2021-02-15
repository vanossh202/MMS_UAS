//
//  MainResult.swift
//  MMS_UAS
//
//  Created by fandy on 14/02/21.
//

import Foundation
import UIKit

class MainResult: CustomStringConvertible {
    
    var word: String?
    var image_url: String?
    var type: String = ""
    var definition: String?
    var image: UIImage?
    
    var description: String {
        get {
            return "word: \(String(describing: word)), image_url: \(String(describing: image_url)), type: \(type), definition: \(String(describing: definition))"
        }
    }
}
