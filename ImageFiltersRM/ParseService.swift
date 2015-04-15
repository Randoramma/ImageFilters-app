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
  
  
  class func ParseService (theParsingImage : UIImage, theSize : CGSize, completionHandler : (String?) -> Void) {
    
    // a UIPhoto object to store the Parse object into
    let thePhoto : UIImage = ImageResizer.ImageResizer(theParsingImage, theSize: theSize)
    // create a jpeg object from thePhoto data.
    let theImageData = UIImageJPEGRepresentation(thePhoto, 1.0)
    // create a PFFile object from the jpeg object data.
    let theFile = PFFile (name: "theImage", data: theImageData)
    // create a PFObject from the PFObject giving it a class name object.
    let theImagePost = PFObject(className: "ImagePost")
    // add a key "image" and give it the PFFobject value.
    theImagePost["image"] = theFile
    // add a key "title" and give it the string value vvv.
    theImagePost["theTitle"] = "this photo also Rocks!"
    // save the PFObject on a background thread.
    theImagePost.saveInBackgroundWithBlock {(suceeded, error) -> Void in
      println("photo uploaded!")
      completionHandler(nil)
    }
    
  } // ParseService
  
  /*
  Step 1: To create a dictionary to pull the images from parse into.
  
  Step 2: Connect to our parse account and pull down the PFobjects
  
  Step 3: Send the array of PFObjects to the TimelineVC.
   */
  
  
  class func ParseRetrevial (theImageClass: String, completion: ([PFObject]) -> Void) {
    
    // we will want to put the "TheImageClass under class name when finished.
    var query = PFQuery(className: theImageClass)
    //query.whereKey("playerName", equalTo:"Sean Plott")
    query.findObjectsInBackgroundWithBlock { (query, error) -> Void in
      if error == nil {
        // the find succeeds.
        println("Successfully retrieved \(query!.count) scores.")
        // Hand back the array of PF objects to the VC.  
        if let theObjects = query as? [PFObject] {
            completion (theObjects)
          // to see if this thing kind of works.
            println(theObjects.count)
        } // if let
      } // if error
    } // findObjectsInBackgroundWithBlock
  } // ParseRetrevial
}
  