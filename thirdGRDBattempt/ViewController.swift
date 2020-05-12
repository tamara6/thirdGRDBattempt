//
//  ViewController.swift
//  firstGRDBattempt
//
//  Created by Tamara Snyder on 1/3/20.
//  Copyright © 2020 Tamara Snyder. All rights reserved.
//  a lot of this from https://www.raywenderlich.com/830-macos-nstableview-tutorial
//

import Cocoa
import GRDB



class ViewController: NSViewController {
    
    @IBOutlet weak var theButton: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    
    @IBOutlet weak var wordSearch: NSTextField!
    @IBOutlet weak var categorySearch: NSTextField!
    
    
    //let delegate = NSApplication.shared.delegate as! AppDelegate
    let appDelegate = NSApp.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let path = NSHomeDirectory()
        print("ViewDidLoad: make sure the database is at \(path)/railsLite.db")
       
        
      /*
        if appDelegate.dbQueue != nil {
            print("it isnt nil 2")
        } else {
            print("it is nil 2")
        }
      */
      
     
      do {
        //let dbQueue = try DatabaseQueue(path: "\(path)/railsLite.db")
        print("ViewDidLoad: checking to see if it is open")
        
        /*
        try dbQueue.inDatabase { db in
            let questions = try Row.fetchAll(db, sql: "SELECT * FROM questions LIMIT 3")
            print("searching")
            
            for q in questions {
                //let theID: Int = q["id"]
                //let theIDstring: String = String(theID)
                let theIDstring: String = String(q["id"] as Int)
                let theA: String  = q["a"]
                let string: String     = q["question"]
                print("\(theIDstring): \(string) a) \(theA)")
             
             }
        
        } */
        
            
      }
      catch {
            print("caught")
      }
      tableView.delegate = self
      tableView.dataSource = self
      
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    @IBAction func buttonClick(_ sender: Any) {
        
        if dbQueue != nil {
            print("ButtonClick: it isnt nil 3")
            let searchTerm = wordSearch.stringValue
            let category = categorySearch.stringValue
            var categoryConnector = " and"
            var sqlSearch = ""
            
            if searchTerm.isEmpty {
              sqlSearch = "SELECT * FROM questions"
              categoryConnector = " where"
            } else {
                sqlSearch = "SELECT * FROM questions WHERE question like '%" + searchTerm + "%'"
            }
            
            if !category.isEmpty {
                let catArray = category.components(separatedBy: [","," "])
                var catArray2: [String] = []
                for cat in catArray {
                    if !cat.isEmpty {
                        let cat2 = "category like '" + cat + "%'"
                        catArray2.append(cat2)
                    }
                }
                let joined = catArray2.joined(separator: " OR ")
                
                //sqlSearch = sqlSearch + categoryConnector + " category like '" + category + "%'"
                sqlSearch = sqlSearch + categoryConnector + " (" + joined + ")"
            }
            
            print("sqlSearch is " + sqlSearch)
            do {
                //let playerCount = try dbQueue.read { db in
                //    try Int.fetchOne(db, sql: "SELECT COUNT(*) FROM
                //questions where question like '%rock%'")!
                let rows = try dbQueue.read { db in
                    try Row.fetchAll(db,
                    sql: sqlSearch
                    //arguments: ["%rock%"]
                    )
                }
                dbRows = rows
                
                
                print("size of rows is : \(rows.count)")
                for row in rows {
                let question: String = row["question"]
                    print(question)
                }
                
                tableView.reloadData()
                
            } catch {
                print("caught - no playerCount")
                
            }
        } else {
            print("ButtonClick: it is nil 3")
        }
        
        
    }
    
    

}

extension ViewController: NSTableViewDataSource {
  
  func numberOfRows(in tableView: NSTableView) -> Int {
    //return directoryItems?.count ?? 0
    
    if dbQueue != nil {
        print("rows in tableview: it isnt nil 5")
        print("size of rows is : \(dbRows.count)")
        return dbRows.count
         
    } else {
        print("rows in tableview: it is nil 5")
    }
    return 0
  }

}

extension ViewController: NSTableViewDelegate {

  fileprivate enum CellIdentifiers {
    static let IDCell = "IDcellID"
    static let RACell = "RAcellID"
    static let QuestionCell = "QuestioncellID"
  }

  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

    var idtext: String = ""
    var text: String = ""
    var cellIdentifier: String = ""

    
    // 1
    //guard let item = directoryItems?[row] else {
      //return nil
    //}
    
   let item = dbRows[row]
    

    // 2
    if tableColumn == tableView.tableColumns[0] {
      //text = item.name
        //text = "0"
        //text = "\(item["id"])"
        text = String(item["id"] as Int)
      cellIdentifier = CellIdentifiers.IDCell
    } else if tableColumn == tableView.tableColumns[1] {
      //text = dateFormatter.string(from: item.date)
       // text = "1"
        if item["randomAns"] == 1 {
            text = "true"
        } else {
            text = "false"
        }
        
        //text = item["randomAns"]
      cellIdentifier = CellIdentifiers.RACell
    } else if tableColumn == tableView.tableColumns[2] {
      //text = item.isFolder ? "--" : sizeFormatter.string(fromByteCount: item.size)
        //text = "question"
        text = item["question"]
      cellIdentifier = CellIdentifiers.QuestionCell
    }
    
    if dbQueue != nil {
       // print("func tableview: it isnt nil 4")
    } else {
        print("func tableview: it is nil 4")
    }

    // 3
    if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
      cell.textField?.stringValue = text
      //cell.imageView?.image = image ?? nil
        
      return cell
    }
 
    return nil
  }

}
