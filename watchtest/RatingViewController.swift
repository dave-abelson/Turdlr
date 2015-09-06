//
//  RatingViewController.swift
//  Pods
//
//  Created by David Abelson on 9/5/15.
//
//

import UIKit

class RatingViewController: UIViewController {
    
    @IBOutlet weak var button1Constraint: NSLayoutConstraint!
    @IBOutlet weak var button2Constraint: NSLayoutConstraint!
    @IBOutlet weak var button3Constraint: NSLayoutConstraint!
    @IBOutlet weak var button4Constraint: NSLayoutConstraint!
    
    @IBOutlet weak var button1: UIButton!
    
    
    @IBAction func button1Pressed(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        let screenWidth = view.frame.size.width
        
        let buttonWidth = button1.frame.width
        
        let buttonSpacing = (screenWidth - (buttonWidth * 5)) / 6
        
        button1Constraint.constant = buttonSpacing
        
        button2Constraint.constant = buttonSpacing
        
        button3Constraint.constant = buttonSpacing
        
        button4Constraint.constant = buttonSpacing
    }
}
