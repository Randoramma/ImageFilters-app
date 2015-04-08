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
  
  class func sepia(myOriginalImage : UIImage) -> UIImage {
    
    let theImage = CIImage(image: myOriginalImage)
    let sepia = CIFilter(name: "CISepiaTone")
    sepia.setDefaults()
    
    sepia.setValue(theImage, forKey: kCIInputImageKey)
    let theResult = sepia.valueForKey(kCIOutputImageKey) as CIImage
//    
//    for theInput in sepia.inputKeys() {
//      println(theInput)
//    }
    
    let theOptions = [kCIContextWorkingColorSpace : NSNull()]
    let eaglContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
    let theContext = CIContext(EAGLContext: eaglContext, options: theOptions)
    
    let resultRef = theContext.createCGImage(theResult, fromRect: theResult.extent())
    return UIImage(CGImage: resultRef)!
  } // sepia
  
  class func vignette(myOrigionalImage : UIImage) -> UIImage {
    
    let theImage = CIImage (image : myOrigionalImage)
    let theVignette = CIFilter(name: "CIVignette")
    theVignette.setDefaults()
    
    theVignette.setValue(theImage, forKey: kCIInputImageKey)
    theVignette.setValue(NSNumber (float: 1.0), forKey: "inputIntensity")
    let theResult = theVignette.valueForKey(kCIOutputImageKey) as CIImage
    
//    for theInput in theVignette.inputKeys() {
//      println(theInput)
//    }
    
    let theOptions = [kCIContextWorkingColorSpace : NSNull()]
    let eaglContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
    let theContext = CIContext(EAGLContext: eaglContext, options: theOptions)
    
    let resultRef = theContext.createCGImage(theResult, fromRect: theResult.extent())
    return UIImage(CGImage: resultRef)!
    
    
  } // vignette 
  
  class func gaussianBlur(myOrigionalImage : UIImage) -> UIImage {
    
    let theImage = CIImage (image : myOrigionalImage)
    let theGaussianBlur = CIFilter(name: "CIGaussianBlur")
    theGaussianBlur.setDefaults()
    
    theGaussianBlur.setValue(theImage, forKey: kCIInputImageKey)
    let theResult = theGaussianBlur.valueForKey(kCIOutputImageKey) as CIImage
    
//    for theInput in theGaussianBlur.inputKeys() {
//      println(theInput)
//    }
    
    let theOptions = [kCIContextWorkingColorSpace : NSNull()]
    let eaglContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
    let theContext = CIContext(EAGLContext: eaglContext, options: theOptions)
    
    let resultRef = theContext.createCGImage(theResult, fromRect: theResult.extent())
    return UIImage(CGImage: resultRef)!
    
    
  } // gaussianBlur
  
}
