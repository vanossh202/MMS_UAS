//
//  RandomizerViewController.swift
//  MMS_UAS
//
//  Created by fandy on 15/02/21.
//

import UIKit

class RandomizerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var choosenBar: UITextField!
    
    @IBOutlet weak var RandoTable: UITableView!
    
    @IBAction func randomButton(_ sender: Any) {
        choosenBar.text = array.randomElement()
        
        let url = "https://myawesomedictionary.herokuapp.com/words?q="+choosenBar.text!
        
        getData(from: url)
    }
    
    var arrResult = [MainResult]()
    
    let array =
        ["apple","application","alter","black","book","boot","cart","create","dream","dress","easy","entrance","entry","family","famous","food","foot","freeze","great","green","greet","happy","happiness","help","ice","iceberg","ill","illness","jeans","joke","keep","ladder","laddle","lead","leader","mail","main","mystery","mysterious","nail","neat","queue","rain","raspberry","root","run","ruin","salt","salty","soup","tablet","team","tear","tool","universe","university","umbrella"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        choosenBar.text = array.randomElement()
        let url = "https://myawesomedictionary.herokuapp.com/words?q="+choosenBar.text!
        
        getData(from: url)
        
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
                                        self.RandoTable.reloadRows(at: [indexPath], with: .fade)
                                    }

                                }
                                imageTask.resume()
                            }
            
                        }
                        
                        
                        DispatchQueue.main.async {
                            self.RandoTable.reloadData()
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
    
//TABLE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RandoTable.dequeueReusableCell(withIdentifier: "RandoCell") as! RandomizerViewCell
        
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
