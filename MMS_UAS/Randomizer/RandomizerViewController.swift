//
//  RandomizerViewController.swift
//  MMS_UAS
//
//  Created by fandy on 15/02/21.
//

import UIKit
import CoreData

class RandomizerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var choosenBar: UITextField!

    @IBOutlet weak var RandoTable: UITableView!

    @IBAction func randomButton(_ sender: Any) {
        choosenBar.text = array.randomElement()

        let url = "https://myawesomedictionary.herokuapp.com/words?q="+choosenBar.text!
        arrResult.removeAll()
        getData(from: url)
    }

    var arrResult = [MainResult]()
    
    var context: NSManagedObjectContext!

    let array =
        ["apple","application","alter","black","book","boot","cart","create","dream","dress","easy","entrance","entry","family","famous","food","foot","freeze","great","green","greet","happy","happiness","help","ice","iceberg","ill","illness","jeans","joke","keep","ladder","laddle","lead","leader","mail","main","mystery","mysterious","nail","neat","queue","rain","raspberry","root","run","ruin","salt","salty","soup","tablet","team","tear","tool","universe","university","umbrella"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        context = appDelegate.persistentContainer.viewContext

    }
    override func viewDidAppear(_ animated: Bool) {
        choosenBar.text = array.randomElement()
        let url = "https://myawesomedictionary.herokuapp.com/words?q="+choosenBar.text!
        arrResult.removeAll()
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
                         self.RandoTable.reloadData()
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
    }

//TABLE
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
        let cell = RandoTable.dequeueReusableCell(withIdentifier: "RandoCell",for: indexPath) as! RandomizerViewCell
        
        let result = arrResult[indexPath.section].definitions[indexPath.row]
        
            cell.picture.getImage(url: result.image_url!)
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
