//
//  ViewController.swift
//  Note2
//
//  Created by 徐志豪 on 2018/11/28.
//  Copyright © 2018 orange. All rights reserved.
//

import UIKit

import CoreData

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,NoteViewControllerdelegate{
    
    var data :[Note] = []
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = data[indexPath.row].text
        cell.imageView?.image = data[indexPath.row].thumbnailImage()
        return cell
    }
    
    @IBOutlet weak var tableview: UITableView!
    @IBAction func Add(_ sender: UIBarButtonItem) {
        let moc = CoreDataHelper.shared.managedObjectContext()
        
       let note = Note(context: moc)
        note.text = "new note"
        
        data.insert(note, at: 0)
        let indexpath = IndexPath(row: 0, section: 0)
        
        tableview.insertRows(at: [indexpath], with: .automatic)
        savetodata()
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
      self.tableview.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
          let note =  data.remove(at: indexPath.row)
            
            CoreDataHelper.shared.managedObjectContext().delete(note)
            
            tableview.deleteRows(at: [indexPath], with: .automatic)
 savetodata()
        }
        
    }
    
    func savetodata(){
        CoreDataHelper.shared.saveContext()
        
    }
    
    func loadfromdata(){
      let moc =  CoreDataHelper.shared.managedObjectContext()
        
        let fetchquest = NSFetchRequest<Note>(entityName: "Note")
        
        moc.performAndWait {
            do{
      let result = try moc.fetch(fetchquest)
               self.data = result
                
            }catch{
                print("error")
                
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cell"{
           let noteVC = segue.destination as! NoteViewController
            
           if let indexpath = self.tableview.indexPathForSelectedRow{
            noteVC.current = data[indexpath.row]
            
          noteVC.delegate = self
            
            }
        }
    }
    
    func didfinishupdata(note:Note){
        
        if let index = data.firstIndex(of: note){
            let indexpath = IndexPath(row: index, section: 0)
            self.tableview.reloadRows(at: [indexpath], with: .automatic)
            
        }
        self.savetodata()
        
    }
//    fsfsf
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loadfromdata()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }


}

