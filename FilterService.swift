//
//  FilterService.swift
//  ImageFiltersRM
//
//  Created by Randy McLain on 4/7/15.
//  Copyright (c) 2015 Randy McLain. All rights reserved.
//

import UIKit
import CoreImage

class FilterService {
  
  class func sepia(originalImage : UIImage) -> UIImage {
    
    let image = CIImage(image: originalImage)
    let sepia = CIFilter(name: "CISepiaTone")
    sepia.setDefaults()
    
    sepia.setValue(image, forKey: kCIInputImageKey)
    let result = sepia.valueForKey(kCIOutputImageKey) as CIImage
    
    for input in sepia.inputKeys() {
      println(input)
    }
    
    let options = [kCIContextWorkingColorSpace : NSNull()]
    let eaglContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
    let context = CIContext(EAGLContext: eaglContext, options: options)
    
    let resultRef = context.createCGImage(result, fromRect: result.extent())
    return UIImage(CGImage: resultRef)!
  }
}
