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
  
  class func sepia(myOriginalImage : UIImage, context : CIContext) -> UIImage {

    let theSepia = CIFilter(name: "CISepiaTone")
    theSepia.setDefaults()

    return self.filteredImageFromOriginalImage(myOriginalImage, filter: theSepia, context: context)
  } // sepia
  
  class func vignette(myOriginalImage : UIImage, context : CIContext) -> UIImage {

    let theVignette = CIFilter(name: "CIVignette")
    theVignette.setDefaults()
    theVignette.setValue(NSNumber (float: 1.0), forKey: "inputIntensity")
    
    return self.filteredImageFromOriginalImage(myOriginalImage, filter: theVignette, context: context)
  } // vignette
  
  class func gaussianBlur(myOriginalImage : UIImage, context : CIContext) -> UIImage {
    
    let theGaussianBlur = CIFilter(name: "CIGaussianBlur")
    theGaussianBlur.setDefaults()
    
    return self.filteredImageFromOriginalImage(myOriginalImage, filter: theGaussianBlur, context: context)
    
  } // gaussianBlur
  
  
  class func instant(myOriginalImage : UIImage, context : CIContext) -> UIImage {
    
    
    let theInstant = CIFilter(name: "CIPhotoEffectInstant")
    theInstant.setDefaults()
    
    return self.filteredImageFromOriginalImage(myOriginalImage, filter: theInstant, context: context)
    
  } // instant 
  
  class func noir(myOriginalImage : UIImage, context : CIContext) -> UIImage {
    
    let theNoir = CIFilter(name: "CIPhotoEffectNoir")
    theNoir.setDefaults()
    return self.filteredImageFromOriginalImage(myOriginalImage, filter: theNoir, context: context)
  } // theNoir
  
  private class func filteredImageFromOriginalImage (myOriginalImage : UIImage, filter : CIFilter, context : CIContext) -> UIImage {
    
    let theImage = CIImage (image: myOriginalImage)
    filter.setValue(theImage, forKey: kCIInputImageKey)
    let theResult = filter.valueForKey(kCIOutputImageKey) as CIImage
    let theResultReference = context.createCGImage(theResult, fromRect: theResult.extent())
    return UIImage (CGImage: theResultReference)!
    
  } // filteredImageFromOriginalImage
  
  
}
