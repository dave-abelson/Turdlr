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
    
    

    
    @IBAction func rateOne(sender: AnyObject) {
        connectServer(1);
        
        
    }
    
    @IBAction func rateTwo(sender: AnyObject) {
        connectServer(2)
    }
    
    
    @IBAction func rateThree(sender: AnyObject) {
        connectServer(3)
    }
    
    @IBAction func rateFour(sender: AnyObject) {
        connectServer(4)
    }
    
    @IBAction func rateFive(sender: AnyObject) {
        connectServer(5);
    }
    
    
    
    func connectServer(rate: Int) {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://104.131.104.27:3000/receive")!)
        request.HTTPMethod = "POST"
        
        var porn = String(rate)
        let postString = "lat="+porn+"&lon="+porn+"&rate=" + porn
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        print(postString)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                println("error=\(error)")
                return
            }
            
            println("response = \(response)")
            
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("responseString = \(responseString)")
        }
        task.resume()
        
        var mainViewController: AnyObject? = self.storyboard?.instantiateViewControllerWithIdentifier("mainController")
        
        
        
        self.presentViewController(mainViewController as! UIViewController, animated: true, completion: nil)
        
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
