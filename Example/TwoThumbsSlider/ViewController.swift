//
//  ViewController.swift
//  TwoThumbsSlider
//
//  Created by sshulga on 12/15/2015.
//  Copyright (c) 2015 sshulga. All rights reserved.
//

import UIKit
import TwoThumbsSlider

class ViewController: UIViewController {

   @IBOutlet var label: UILabel!
   
   @IBAction func sliderMoved(sender: TwoThumbsSlider) {
      self.label.text = "Left value -> \(sender.leftValue) Right value -> \(sender.rightValue)"
   }

}

