//
//  PhotoViewController.swift
//  ImageFiltersRM
//
//  Created by Randy McLain on 4/6/15.
//  Copyright (c) 2015 Randy McLain. All rights reserved.
//

import UIKit
import Parse

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  // properties
  let myAlertController = UIAlertController (title: "Options", message: "Choose One", preferredStyle: UIAlertControllerStyle.ActionSheet)
  
  @IBOutlet weak var myImageView: UIImageView!
  
  //functions
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
      
      let cameraAction = UIAlertAction (title: "Camera", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        imagePickerController.allowsEditing = true
        self.presentViewController(imagePickerController, animated: true, completion: nil)
        imagePickerController.delegate = self
      })
      self.myAlertController.addAction (cameraAction)
    } else {
      let cameraAction = UIAlertAction (title: "PhotoLibrary", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePickerController.allowsEditing = true
        self.presentViewController(imagePickerController, animated: true, completion: nil)
        imagePickerController.delegate = self
      })
      self.myAlertController.addAction (cameraAction)
      
    } // if else
    
    let sepiaAction = UIAlertAction (title: "Sepia", style: UIAlertActionStyle.Destructive) { (action) -> Void in
      
      let sepiaImage = FilterService.sepia(self.myImageView.image!)
      self.myImageView.image = sepiaImage
    } // sepiaAction
    self.myAlertController.addAction (sepiaAction)
    
    
    let vignetteAction = UIAlertAction (title: "Vignette", style: UIAlertActionStyle.Destructive) { (action) -> Void in
      
      let vignetteImage = FilterService.vignette(self.myImageView.image!)
      self.myImageView.image = vignetteImage
    } // vignetteAction
    self.myAlertController.addAction (vignetteAction)
    
    
    let gaussianBlurAction = UIAlertAction (title: "Gaussian Blur", style: UIAlertActionStyle.Destructive) { (action) -> Void in
      
      let gaussianBlur = FilterService.gaussianBlur(self.myImageView.image!)
      self.myImageView.image = gaussianBlur
    }  // gaussianBlurAction
    self.myAlertController.addAction (gaussianBlurAction)
    
//    let testObject = PFObject(className: "TestObject")
//    testObject["foo"] = "bar"
//    testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
//      println("Object has been saved.")
//    }
    
    let saveAction = UIAlertAction (title: "Save photo to Cloud", style: UIAlertActionStyle.Default) { (acton) -> Void in
      
      let thePhoto : UIImage = self.myImageView.image!
      let theImageData = UIImageJPEGRepresentation(thePhoto, 1.0)
      let theFile = PFFile (name: "theImage", data: theImageData)
      
      let theImagePost = PFObject(className: "ImagePost")
      theImagePost["image"] = theFile
      theImagePost["theTitle"] = "this photo also Rocks!"
      
      theImagePost.saveInBackgroundWithBlock({ (succeded, error) -> Void in
       
        println("save completed!")
      })
    } // save action
    self.myAlertController.addAction (saveAction)
    
  } // viewDidLoad
  
  // Photo button pressed function calling the UIAlertController.
  @IBAction func photoButtonPressed(sender: AnyObject) {
    
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
    
    self.presentViewController(myAlertController, animated: true) { () -> Void in
      
    }
  } // photoButtonPressed
  
  //MARK:
  //MARK: UIImagePickerControllerDelegate
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    if let myEditedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
      myImageView.image = myEditedImage
    }
    picker.dismissViewControllerAnimated(true, completion: nil)
  } // imagePickerController didFinishPickingMediaWithInfo
  
  func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
    
  } // imagePickerController didFinishPickingImage
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  } // didReceiveMemoryWarning

}
