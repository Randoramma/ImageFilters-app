//
//  ParseService.swift
//  ImageFiltersRM
//
//  Created by Randy McLain on 4/8/15.
//  Copyright (c) 2015 Randy McLain. All rights reserved.
//

import UIKit
import Parse

class ParseService {
  
  class func ParseService (theParsingImage : UIImage, theSize : CGSize, completionHandler : (String?) -> Void){
    
    
    let thePhoto : UIImage = ImageResizer.ImageResizer(theParsingImage, theSize: theSize)
    
    let theImageData = UIImageJPEGRepresentation(thePhoto, 1.0)
    let theFile = PFFile (name: "theImage", data: theImageData)
    
    let theImagePost = PFObject(className: "ImagePost")
    theImagePost["image"] = theFile
    theImagePost["theTitle"] = "this photo also Rocks!"
    
    theImagePost.saveInBackgroundWithBlock {(suceeded, error) -> Void in
      println("photo uploaded!")
      completionHandler(nil)
    }
    
  }
}