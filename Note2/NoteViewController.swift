//
//  NoteViewController.swift
//  Note2
//
//  Created by 徐志豪 on 2018/11/28.
//  Copyright © 2018 orange. All rights reserved.
//

import UIKit

protocol NoteViewControllerdelegate:class {
     func didfinishupdata(note:Note)
}
class NoteViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var textfild: UITextView!
    @IBOutlet weak var imageview: UIImageView!
    
    var delegate :NoteViewControllerdelegate?
    var isnewphoto = false
    var current :Note!
    @IBAction func camera(_ sender: UIBarButtonItem) {
        let controller = UIImagePickerController()
        controller.sourceType = .savedPhotosAlbum
        controller.delegate = self
        
        self.present(controller, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.imageview.image = image
            
        }
        self.dismiss(animated: true, completion: nil)
        isnewphoto = true
    }
    
    
    
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        self.current.text = self.textfild.text
        
        if isnewphoto {
            if let imagedata = imageview.image?.jpegData(compressionQuality: 1){
                do{
             let home  =  URL(fileURLWithPath: NSHomeDirectory())
                let documents = home.appendingPathComponent("Documents")
               let filename = "\(self.current.noteID)"
              let fileurl = documents.appendingPathComponent(filename)
                current.imagename  = filename
                
               try imagedata.write(to: fileurl,options: [.atomicWrite])
                
                }catch{
                    print("載入失敗")
                    
                }
                
         
                
                
            }
            
        }
        
        self.delegate?.didfinishupdata(note: self.current)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textfild.text = current.text
        imageview.image = current.image()

  
    }
    

  

}
