//
//  ImageResizer.swift
//  ImageFiltersRM
//
//  Created by Randy McLain on 4/8/15.
//  Copyright (c) 2015 Randy McLain. All rights reserved.
//

import UIKit

class ImageResizer {
  
  class func ImageResizer (theOriginalImage : UIImage, theSize : CGSize) -> UIImage {
    
    UIGraphicsBeginImageContext(theSize)
    theOriginalImage.drawInRect(CGRect(x: 0, y: 0, width: theSize.width, height: theSize.height))

    let theNewImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return theNewImage
  }
}


