//
//  Note.swift
//  Note2
//
//  Created by 徐志豪 on 2018/11/28.
//  Copyright © 2018 orange. All rights reserved.
//

import Foundation

import CoreData

import UIKit

class Note:NSManagedObject{
    
   @NSManaged var text :String?
    
    @NSManaged var imagename:String?
    
    @NSManaged var noteID :String
    
    override func awakeFromInsert() {
        noteID = UUID().uuidString
    }
    
    
    func image() -> UIImage?{
        
        if let name = imagename {
            let home = URL(fileURLWithPath: NSHomeDirectory())
            let documents = home.appendingPathComponent("Documents")
            
            let fileURL = documents.appendingPathComponent(name)
            if let image = UIImage(contentsOfFile: fileURL.path)
            {
                return image
                
            }
        }
        return nil
        
    }
    func thumbnailImage() -> UIImage? {
        if let image =  self.image() {
            
            let thumbnailSize = CGSize(width:50, height: 50); //設定縮圖大小
            let scale = UIScreen.main.scale //找出目前螢幕的scale，視網膜技術為2.0
            
            //產生畫布，第一個參數指定大小,第二個參數true:不透明（黑色底）,false表示透明背景,scale為螢幕scale
            UIGraphicsBeginImageContextWithOptions(thumbnailSize,false,scale)
            
            //計算長寬要縮圖比例，取最大值MAX會變成UIViewContentModeScaleAspectFill
            //最小值MIN會變成UIViewContentModeScaleAspectFit
            let widthRatio = thumbnailSize.width / image.size.width;
            let heightRadio = thumbnailSize.height / image.size.height;
            
            let ratio = max(widthRatio,heightRadio);
            
            let imageSize = CGSize(width:image.size.width*ratio,height: image.size.height*ratio);
            
            image.draw(in:CGRect(x: -(imageSize.width-thumbnailSize.width)/2.0,y: -(imageSize.height-thumbnailSize.height)/2.0,
                                 width: imageSize.width,height: imageSize.height))
            //取得畫布上的縮圖
            let smallImage = UIGraphicsGetImageFromCurrentImageContext();
            //關掉畫布
            UIGraphicsEndImageContext();
            return smallImage
        }else{
            return nil;
        }
        
    }

    
    
    
}
