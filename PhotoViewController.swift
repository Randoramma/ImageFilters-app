//
//  PhotoViewController.swift
//  ImageFiltersRM
//
//  Created by Randy McLain on 4/6/15.
//  Copyright (c) 2015 Randy McLain. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

  let myAlertController = UIAlertController(title: "Options", message: "Choose One", preferredStyle: UIAlertControllerStyle.Alert)
  
    override func viewDidLoad() {
        super.viewDidLoad()

        let okayAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) { (ACTION) -> Void in
        
      }
      
      let destroyAction = UIAlertAction(title: "Destroy", style: UIAlertActionStyle.Destructive) { (action) -> Void in
        
      }
            self.myAlertController.addAction(okayAction)
            self.myAlertController.addAction(destroyAction)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
  
}
