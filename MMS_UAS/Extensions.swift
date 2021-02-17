//
//  Extensions.swift
//  MMS_UAS
//
//  Created by fandy on 16/02/21.
//

import Foundation
import UIKit

extension UIImageView{
    func getImage(url : String){
                if url == ""{
                    self.image = UIImage(named: "Default")
                    return
                }else {
                    let inputURL = URL(string: url)!
            DispatchQueue.global().async {
                [weak self] in
                if let data = try? Data(contentsOf: inputURL){
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.image = image
                        }
                    }
                }
            }
        }
    }
}
