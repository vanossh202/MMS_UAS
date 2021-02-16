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
        self.image = UIImage(named: "Default")
        
        if url == ""{
            return
        }
        
        let imgURL = URL(string: url)
        URLSession.shared.dataTask(with: imgURL!) { (data, response, error) in
            if error != nil{
                return
            }
            
            DispatchQueue.main.async {
               self.image = UIImage(data: data!)
            }
        }.resume()
    }
}
