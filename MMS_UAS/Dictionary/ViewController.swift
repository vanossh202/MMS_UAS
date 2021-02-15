//
//  ViewController.swift
//  MMS_UAS
//
//  Created by fandy on 14/02/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   

    @IBOutlet weak var searchBar: UITextField!
    
    @IBOutlet weak var table: UITableView!
    
    @IBAction func searchButton(_ sender: Any) {
        if searchBar.text!.count < 3 {
            let alert = UIAlertController(title: "OOPS", message: "searched word must be 3 or more", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        else {
        let url = "https://myawesomedictionary.herokuapp.com/words?q="+searchBar.text!
        getData(from: url)
        }
    }
    
    var arrResult = [MainResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
    }
    
   func getData(from url: String) {
        
        let url = URL(string: url)
        
        guard url != nil else{
            return
        }
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            
            if error == nil && data != nil {
                
                do{
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [[String: Any]]
                    
                    let count = response?.count
                    
                    for i in 0..<count! {
                        let arrResponse = response![i]["definitions"] as! [[String: Any]]
                        let arrKata = response![i]["word"]
                        
                        for result in arrResponse {
                            let hasil = MainResult()
                            hasil.word = arrKata as? String
                            hasil.image_url = result["image_url"] as? String
                            hasil.type = result["type"] as! String
                            hasil.definition = result["definition"] as? String
                            
                            let rowIndex = self.arrResult.count
                            self.arrResult.append(hasil)

                            if hasil.image_url == nil {
                                hasil.image = UIImage(named: "Default")
                            
                            }else {
                                let imageURL = URL(string: hasil.image_url!)
                                let imageTask = session.dataTask(with: imageURL!) { (data, response, error) in
                                    if error != nil {
                                        print(error?.localizedDescription)
                                        return
                                    }

                                    hasil.image = UIImage(data: data!)
                                    
                                    DispatchQueue.main.async {
                                        let indexPath = IndexPath(row: rowIndex, section: 0)
                                        self.table.reloadRows(at: [indexPath], with: .fade)
                                    }

                                }
                                imageTask.resume()
                            }
            
                        }
                        
                        
                        DispatchQueue.main.async {
                            self.table.reloadData()
                        }
                    }
                    
                }
                catch{
                        print("Error in JSON parsing")
                    }
                }
            }
            dataTask.resume()
        }
    
    //TABLE SETTING
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "Cell") as! TableCell
        
        let result = arrResult[indexPath.row]
        
        if let thumbnail = result.image {
            cell.picture.image = thumbnail
        }

            cell.cellWord.text = result.word
            cell.cellType.text = result.type
            cell.cellDefinition.text = result.definition
            
        return cell
        }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
        return tableView.rowHeight = 175
    }
        
    
}




