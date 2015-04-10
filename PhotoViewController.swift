//
//  PhotoViewController.swift
//  ImageFiltersRM
//
//  Created by Randy McLain on 4/6/15.
//  Copyright (c) 2015 Randy McLain. All rights reserved.
//

import UIKit
import Parse

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource {
  
  //MARK:
  //MARK: Properties
  

  let myAlertController = UIAlertController (title: "Options", message: "Choose One", preferredStyle: UIAlertControllerStyle.ActionSheet)
  let theImageLength : CGFloat = 500.0
  let myImageConstraint : CGFloat = 50.0
  let myAnimationDuration = 0.3
  let myImageUploadSize = CGSize(width: 400.0, height: 400.0)
  // let myCollectionViewHeight : CGFloat = 75.0
  let myCollectionViewBottomFilterModeConstant : CGFloat = 8.0
  
  var myFilters : [(UIImage, CIContext)->(UIImage)]!
  var myContext : CIContext!
  var myOriginalThumbnail : UIImage!
  
  var currentImage : UIImage! {
    didSet {
      self.myImageView.image = self.currentImage
      self.myOriginalThumbnail = ImageResizer.ImageResizer(self.currentImage, theSize: self.myThumbnailSize)
      self.myCollectionView.reloadData()
      //self.currentImage = oldValue
    }
  }
  
  
  // imageview constants
  var originalImageViewTopLeadingTrailingConstant : CGFloat = 0.0
  var originalImageViewBottomConstant : CGFloat = 0.0
  let myThumbnailSize = CGSize(width: 75, height: 75)
  
  //MARK:
  //MARK: Interface Outlets
  @IBOutlet weak var myImageView: UIImageView!
  @IBOutlet weak var myPhotoButton: UIButton!
  @IBOutlet weak var myCollectionView: UICollectionView!
  
  
  //MARK:
  //MARK: ImageView Constraints
  
  @IBOutlet weak var myImageViewLeadingConstraint: NSLayoutConstraint!
  @IBOutlet weak var myImageViewTrailingConstraint: NSLayoutConstraint!
  @IBOutlet weak var myImageViewTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var myImageViewBottomConstraint: NSLayoutConstraint!
  
  //MARK: CollectionView Constraints
  
  @IBOutlet weak var myCollectionViewBottomConstraint: NSLayoutConstraint!
  
  //MARK:
  //MARK: Functions
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Editor"
    // this stuff
    let options = [kCIContextWorkingColorSpace : NSNull()]
    let eaglContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
    self.myContext = CIContext(EAGLContext: eaglContext, options: options)
    
    self.myCollectionView.dataSource = self
    
    // setting up collection bar beneath the view
    self.myCollectionViewBottomConstraint.constant = -self.tabBarController!.tabBar.frame.height - self.myCollectionView.frame.height
    
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
      
      let cameraAction = UIAlertAction (title: "Camera", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
        
        let imagePickerController = UIImagePickerController ()
        imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        imagePickerController.allowsEditing = true
        self.presentViewController (imagePickerController, animated: true, completion: nil)
        imagePickerController.delegate = self
      })
      self.myAlertController.addAction (cameraAction)
    } else {
      let cameraAction = UIAlertAction (title: "PhotoLibrary", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
        
        let imagePickerController = UIImagePickerController ()
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePickerController.allowsEditing = true
        self.presentViewController (imagePickerController, animated: true, completion: nil)
        imagePickerController.delegate = self
      })
      self.myAlertController.addAction (cameraAction)
      
    } // if else
    
    let filtersAction = UIAlertAction (title: "Filters", style: UIAlertActionStyle.Default) { [weak self] (action) -> Void in
      
      if self != nil {
        self!.enterFilterMode ()
      }
    } //filters Action
    self.myAlertController.addAction (filtersAction)
    
    self.myFilters = [FilterService.sepia,FilterService.gaussianBlur, FilterService.instant, FilterService.vignette, FilterService.noir]
    
    let saveAction = UIAlertAction (title: "Save photo to Cloud", style: UIAlertActionStyle.Default) { (action) -> Void in
      
      let thePhoto: Void = ParseService.ParseService(self.myImageView.image!, theSize: self.myImageUploadSize, completionHandler : {(errorDescription) -> Void in
        
      })
    } // save action
    self.myAlertController.addAction (saveAction)
    
    let cancelAction = UIAlertAction (title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
      
    } // calcel action
    
    self.myAlertController.addAction (cancelAction)
    
  } // viewDidLoad
  
  func enterFilterMode () {
    
    self.myPhotoButton.enabled = false
    // show the thumbnail bar.
    self.myCollectionViewBottomConstraint.constant = myCollectionViewBottomFilterModeConstant
    
    // when you enter the filter mode, there will be a bar button that will appear on the top right of the menu.
    
    self.navigationItem.rightBarButtonItem = UIBarButtonItem (title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "leaveFilterMode:")
    
    self.myImageViewTopConstraint.constant += myImageConstraint
    self.myImageViewBottomConstraint.constant += myImageConstraint
    self.myImageViewLeadingConstraint.constant += myImageConstraint
    self.myImageViewTrailingConstraint.constant += myImageConstraint
    
    UIView.animateWithDuration(self.myAnimationDuration, animations: { () -> Void in
      self.myImageView.layoutIfNeeded()
    })
    
  } // enterFilterMode
  
  func leaveFilterMode () {
    
    self.myPhotoButton.enabled = true
    // hide the thumbnail bar.
    self.myCollectionViewBottomConstraint.constant = -self.tabBarController!.tabBar.frame.height - self.myCollectionView.frame.height
    
    // remove the done button
    self.navigationItem.rightBarButtonItem = nil
    // allow the imageview to retirn to fill size.
    
    self.originalImageViewTopLeadingTrailingConstant = self.myImageViewTopConstraint.constant
    self.originalImageViewBottomConstant = self.myImageViewBottomConstraint.constant
    
    UIView.animateWithDuration (self.myAnimationDuration, animations: { () -> Void in
      self.myImageView.layoutIfNeeded ()
    })
    
  }// leaveFilterMode
  
  // Photo button pressed function calling the UIAlertController.
  @IBAction func photoButtonPressed (sender: AnyObject) {
    
    // check if device is an iPad to set the setSceneView and setSourceRect
    if let popoverController = self.myAlertController.popoverPresentationController {
      
      /*
      Unstruct the storyboard where to plave the popover controller on an ipad.
      This must be placed within the firing function, as it must be re-established
      each and every time.
      */
      
      if let button = sender as? UIButton {
        // define the sourceView based on the UIView
        popoverController.sourceView = button
        popoverController.sourceRect = button.bounds
      }
    } // if let popoverController
    
    self.presentViewController (myAlertController, animated: true) { () -> Void in
      
    }
  } // photoButtonPressed
  
  //MARK:
  //MARK: UICollectionViewDataSource
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.myFilters.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let theCell = collectionView.dequeueReusableCellWithReuseIdentifier("myImageCell", forIndexPath: indexPath) as UICollectionViewCell
    
    let filter = self.myFilters[indexPath.row]
    theCell.backgroundColor = UIColor.redColor()
    //.imageView.image = filter(self.originalThumbnail,self.context)
    
    return theCell
  }
  
  
  //MARK:
  //MARK: UIImagePickerControllerDelegate
  
  func imagePickerController (picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    if let myEditedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
      myImageView.image = myEditedImage
    }
    picker.dismissViewControllerAnimated(true, completion: nil)
  } // imagePickerController didFinishPickingMediaWithInfo
  
  func imagePickerController (picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
    
  } // imagePickerController didFinishPickingImage
  
  override func didReceiveMemoryWarning () {
    super.didReceiveMemoryWarning ()
    // Dispose of any resources that can be recreated.
  } // didReceiveMemoryWarning
  
}
