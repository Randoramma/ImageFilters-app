//
//  TimelineViewController.swift
//  ImageFiltersRM
//
//  Created by Randy McLain on 4/9/15.
//  Copyright (c) 2015 Randy McLain. All rights reserved.
//

import UIKit
import Parse

class TimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
  
  
  @IBOutlet weak var myTimeLineTableView: UITableView!
  
  var myObjects = [PFObject]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Timeline"
    
    myTimeLineTableView.dataSource = self
    myTimeLineTableView.delegate = self
    
    
    
  } // viewDidLoad
  
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    /*
    Pull the files from the parser to the VC.  If our object class id is correct,
    the completion handler will bring out the array of PF file and we will populate
    them into our own array in the class so that we can lazy load them when the collection
    builds.
    */
    
    ParseService.ParseRetrevial("ImagePost", completion: {(objectArray) -> Void in
      
      for object in objectArray {
        
        // add the PFFiles to our array.
        self.myObjects.append(object)
        
      } // for loop
      
      // bring back to the main queue
      
      NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
        self.myTimeLineTableView.reloadData()
        println(self.myObjects.count)
      }) // NSOperationQueue completion
      
    }) // ParseRetrevial completion
    
  } // viewWillAppear
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    println (myObjects.count)
    if myObjects.count > 0 {
      
      return myObjects.count
      
    } else {
      return 0
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let theCell = tableView.dequeueReusableCellWithIdentifier("myTableViewCell", forIndexPath: indexPath) as! TimelineTableViewCell
    
    // unwrap the object based on the name
    let object = myObjects[indexPath.row]
    // grab the key for the PFObject and
    let file = object["image"] as! PFFile
    
    // grab the data on a background key
    file.getDataInBackgroundWithBlock { (theData, error) -> Void in
      
      if error == nil {
        
        let theImage = UIImage(data: theData!)
        
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
          theCell.myTableViewImage.image = theImage
        })
      }
      
    }
    return theCell
  }
}
