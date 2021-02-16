//
//  BookmarkViewController.swift
//  MMS_UAS
//
//  Created by fandy on 15/02/21.
//

import UIKit
import CoreData

class BookmarkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var bookmarkTable: UITableView!
    
    var arrBookmark = [MainResult]()
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        context = appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidAppear(_ animated: Bool) {
        arrBookmark.removeAll()
        loadData()
    }
    
    func loadData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Bookmark")
        request.sortDescriptors = [NSSortDescriptor(key: "word", ascending: true)]
        
        do{
            let results = try context.fetch(request) as! [NSManagedObject]
            
            if results.count == 0 {
                bookmarkTable.isHidden = true
                let alertDialog = UIAlertController(title: "Error", message: "No Bookmark Data", preferredStyle: .alert)
                let close = UIAlertAction(title: "Close", style: .default, handler: nil)
                alertDialog.addAction(close)
                present(alertDialog, animated: true, completion: nil)
                return
            } else {
            
                for data in results {
                    var pos = 0
                    let word = data.value(forKey: "word") as! String
                    let image_url = data.value(forKey: "image_url") as! String
                    let type = data.value(forKey: "type") as! String
                    let definition = data.value(forKey: "definition") as! String
                    
                    if(arrBookmark.isEmpty) {
                        arrBookmark.append(MainResult(word: word, definitions: [Result(image_url: image_url, type: type, definition: definition)]))
                        bookmarkTable.isHidden = false
                        bookmarkTable.reloadData()
                    }else{
                        for a in 0..<arrBookmark.count {
                            if arrBookmark[a].word == word {
                                pos = a
                                break
                            }else{
                                pos = -1
                            }
                        }
                        
                        if pos == -1 {
                            arrBookmark.append(MainResult(word: word, definitions: [Result(image_url: image_url, type: type, definition: definition)]))
                        }else {
                            arrBookmark[pos].definitions.append(Result(image_url: image_url, type: type, definition: definition))
                        }
                        
                        bookmarkTable.isHidden = false
                    }
                }
                
            }
            bookmarkTable.reloadData()
            
        }catch{
            let alertDialog = UIAlertController(title: "Error", message: "Something wrong when loading data", preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "Close", style: .default, handler: nil)
            alertDialog.addAction(closeAction)
            present(alertDialog, animated: true, completion: nil)
        }
            
    }
    
    
    func deleteData(pos: Int) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Bookmark")
        request.predicate = NSPredicate(format: "word==%@", arrBookmark[pos].word!)
        
        do{
            let result = try context.fetch(request) as! [NSManagedObject]
            for data in result{
                context.delete(data)
            }
                    
            try context.save()
            } catch{
                let alertDialog = UIAlertController(title: "Error", message: "Something wrong when deleting", preferredStyle: .alert)
                let closeAction = UIAlertAction(title: "Close", style: .default, handler: nil)
                alertDialog.addAction(closeAction)
                present(alertDialog, animated: true, completion: nil)
            }
        bookmarkTable.reloadData()
    }
    
    @objc func confirmation(sender: UIButton) {
        let pos = sender.tag
        
        let alertDialog = UIAlertController(title: "Confirmation to Delete", message: "Are you sure want to delete \"\(arrBookmark[pos].word)\" from your bookmark ?", preferredStyle: .alert)
                let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
                let yesAction = UIAlertAction(title: "Yes", style: .destructive){
                    action in
                    self.deleteData(pos: pos)
                }
                alertDialog.addAction(noAction)
                alertDialog.addAction(yesAction)
                
                present(alertDialog, animated: true, completion: nil)
    }
    

    //TABLE SETTING
    func numberOfSections(in tableView: UITableView) -> Int {
            return arrBookmark.count
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrBookmark[section].definitions.count
        }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        arrBookmark[section].word
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = bookmarkTable.dequeueReusableCell(withIdentifier: "BookmarkCell",for: indexPath) as! BookmarkTableViewCell
        
        let result = arrBookmark[indexPath.section].definitions[indexPath.row]
        
        cell.bookmarkImage.getImage(url: result.image_url!)
        cell.bookmarkType.text = result.type
        cell.bookmarkDefinition.text = result.definition!
            
        return cell
        }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
        return tableView.rowHeight = 175
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        	
        let label = UILabel()
        label.frame = CGRect.init(x: 20, y: 0, width: tableView.frame.width-230, height: 50)
        label.text = arrBookmark[section].word
        
        let button = UIButton(type: .system)
        button.frame = CGRect.init(x: 250, y: 10, width: 150, height: 30)
        button.setTitle("Delete Favourite", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.darkGray
        button.addTarget(self, action: #selector(self.confirmation), for: .touchUpInside)
        
        let tableHeader = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        tableHeader.addSubview(label)
        tableHeader.addSubview(button)

        return tableHeader
    }


}
