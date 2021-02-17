//
//  ViewController.swift
//  MMS_UAS
//
//  Created by fandy on 14/02/21.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   

    @IBOutlet weak var searchBar: UITextField!
    
    @IBOutlet weak var table: UITableView!
    
    @IBAction func searchButton(_ sender: Any) {
        if searchBar.text!.count < 3 {
            let alert = UIAlertController(title: "OOPS!!", message: "searched word must be 3 or more", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        else {
        let url = "https://myawesomedictionary.herokuapp.com/words?q="+searchBar.text!
            arrResult.removeAll()
            getData(from: url)
        }
    }
    
    var arrResult = [MainResult]()
    
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        context = appDelegate.persistentContainer.viewContext
    
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
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [[String: Any]]
                    
                    for data in response {
                        let Response = data["definitions"] as! [[String: Any]]
                        let Kata = data["word"] as! String
                        var Definitions = [Result]()
                        
                        for hasil in Response {
                            let image_url = hasil["image_url"] as? String
                            let type = hasil["type"] as! String
                            let definition = hasil["definition"] as? String
                            
                            Definitions.append(Result(image_url: image_url ?? "", type: type, definition: definition))
                        }
                        self.arrResult.append(MainResult(word: Kata,definitions: Definitions))
                    }
                    
                    DispatchQueue.main.async {
                        self.table.reloadData()
                    }
                    
                }catch{
                    print("Error in JSON parsing")
                }
            }
        }
    dataTask.resume()
   }
    
    @objc func SaveData(sender: UIButton) {
        
        let pos = sender.tag
        
        let entity = NSEntityDescription.entity(forEntityName: "Bookmark", in: context)
        
        for data in arrResult[pos].definitions{
            let newBookmark = NSManagedObject(entity: entity!, insertInto: context)
            newBookmark.setValue(arrResult[pos].word, forKey: "word")
            newBookmark.setValue(data.type, forKey: "type")
            newBookmark.setValue(data.image_url, forKey: "image_url")
            newBookmark.setValue(data.definition, forKey: "definition")
            
        }
        
        do{
            try context.save()
        }catch {
            let alertDialog = UIAlertController(title: "Error", message: "Something wrong when saving data", preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "Close", style: .default, handler: nil)
            alertDialog.addAction(closeAction)
            present(alertDialog, animated: true, completion: nil)
        }
        
        let alertDialog = UIAlertController(title: "Success", message: "Word saved to Bookmark succesfully", preferredStyle: .alert)
        let close = UIAlertAction(title: "Close", style: .default, handler: nil)
        alertDialog.addAction(close)
        present(alertDialog, animated: true, completion: nil)
    }
    
    //TABLE SETTING
    func numberOfSections(in tableView: UITableView) -> Int {
            return arrResult.count
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrResult[section].definitions.count
        }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        arrResult[section].word
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "Cell",for: indexPath) as! TableCell
        
        let result = arrResult[indexPath.section].definitions[indexPath.row]
        
            cell.cellPicture.getImage(url: result.image_url!)
            cell.cellType.text = result.type
            cell.cellDefinition.text = result.definition
            
        return cell
        }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
        return tableView.rowHeight = 175
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel()
        label.frame = CGRect.init(x: 20, y: 0, width: tableView.frame.width-210, height: 50)
        label.text = arrResult[section].word
        
        let button = UIButton(type: .system)
        button.frame = CGRect.init(x: 250, y: 10, width: 150, height: 30)
        button.setTitle("Favourite", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.darkGray
        button.addTarget(self, action: #selector(self.SaveData), for: .touchUpInside)
        
        let tableHeader = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        tableHeader.addSubview(label)
        tableHeader.addSubview(button)

        return tableHeader
    }
        
    
}




