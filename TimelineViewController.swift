//
//  TimelineViewController.swift
//  ImageFiltersRM
//
//  Created by Randy McLain on 4/9/15.
//  Copyright (c) 2015 Randy McLain. All rights reserved.
//

import UIKit
import Parse

class TimelineViewController: UIViewController, UITableViewDataSource  {
  
  
  @IBOutlet weak var myTimeLineTableView: UITableView!
  
  var myObjects = [PFObject]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Timeline"
    
    myTimeLineTableView.dataSource = self
    
    /*
    Pull the objects from the parser to the VC.  If our object class id is correct,
    the completion handler will bring out the array of PF objects and we will populate
    them into our own array in the class so that we can lazy load them when the collection
    builds.
    */
    
    ParseService.ParseRetrevial("ImagePost", completion: {(objectArray) -> Void in
      
      for object in objectArray {
        let file = object.objectForKey("theImage") as! PFObject
        self.myObjects.append(object)
        
        //let theImage = file.
        // follow the steps from the parse service here or in the deque reusable cell
        
        
        // dont forget to add an image to the cell on the storyboard.
        
        
      } // for loop
      
      NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
        self.myTimeLineTableView.reloadData()
        println(self.myObjects.count)
      })
      
    }) // completion
    
    // bring back to the main queue
    
    //        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
    //          completion
    //        })
  } // viewDidLoad
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return myObjects.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let theCell = tableView.dequeueReusableCellWithIdentifier("myTableViewCell", forIndexPath: indexPath) as! UITableViewCell
    
    
    
    return theCell
  }
  
  
  //
  //      // we want this cell to take us back to the main image.
  //  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
  //
  //    let theCell = collectionView.dequeueReusableCellWithReuseIdentifier("myTimelineViewCell", forIndexPath: indexPath)  as! GalleryViewCell
  //
  //    let theAsset = self.myObjects[indexPath.row]
  //
  //    // find the key we used
  //
  //
  //    // pull out the parse object with the key
  //    theCell.myGalleryCellImageView.image = theAsset.fetchInBackgroundWithBlock({ (theKey, theError) -> Void in
  //     // <#code#>
  //
  //      return theCell
  //    })
  //
  //
  //
  //    return theCell
  //  } // cellForItemAtIndexPath
  //
  //  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
  //    return 1
  //  }
  
  
  
  
  
  
  
}
