//
//  GalleryViewController.swift
//  ImageFiltersRM
//
//  Created by Randy McLain on 4/10/15.
//  Copyright (c) 2015 Randy McLain. All rights reserved.
//

import UIKit
import Photos

// set the image protocol delegate.  Be sure to make it a class protocol so that the 
// connections are weak connections.
protocol ImageSelectedDelegate : class {
  
  func controllerDidSelectImage (theImage :UIImage) -> Void
  
}

class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  
  //properties
  var myImageManager : PHCachingImageManager!
  var myPrimaryImageViewSize : CGSize!
  var myResults : PHFetchResult!
  
  /*
  The delegate
  This is our delegate object.



  */
  weak var myDelegate : ImageSelectedDelegate?
  
  @IBOutlet weak var myGalleryCollectionView: UICollectionView!

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    self.myGalleryCollectionView.delegate = self
    self.myGalleryCollectionView.dataSource = self
    
    self.myResults = PHAsset.fetchAssetsWithOptions(nil)
    self.myImageManager = PHCachingImageManager()
//    
//    let pinch = UIGestureRecognizer(target: self, action: "collectionViewPinched:")
//    self.myGalleryCollectionView.addGestureRecognizer(pinch)
    
  }// viewdidload
  
  
  //MARK: UICollectionViewDataSource
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return myResults.count
  } // numberOfItemsInSection
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    let theCell = collectionView.dequeueReusableCellWithReuseIdentifier("myGalleryViewCell", forIndexPath: indexPath) as GalleryViewCell
    
    let theAsset = self.myResults[indexPath.row] as PHAsset
    
    self.myImageManager.requestImageForAsset(theAsset, targetSize: theCell.frame.size, contentMode: PHImageContentMode.AspectFill, options: nil) { (theImage, theInfo) -> Void in
      if theImage != nil {
        theCell.myGalleryCellImageView.image = theImage
      } // if else
    } // requestImageForAsset
    return theCell
  } // cellForItemAtIndexPath
  
  //MARL: UICollectionViewDelegate
  
  func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
    let theAsset = self.myResults[indexPath.row] as PHAsset
    
    self.myImageManager.requestImageForAsset(theAsset, targetSize: self.myPrimaryImageViewSize, contentMode: PHImageContentMode.AspectFill, options: nil) { [weak self]  (theImage, theInfo) -> Void in
      if self != nil {
        if theImage != nil {
          self!.myDelegate?.controllerDidSelectImage(theImage)
          self!.navigationController?.popToRootViewControllerAnimated(true)
          
        } // if else
      } // if self
    } // requestImageForAsset
  } // didDeselectItemAtIndexPath
  
  func collectionViewPinched(pinch : UIPinchGestureRecognizer) {
    println(pinch.scale)
  } // collectionViewPinched
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
