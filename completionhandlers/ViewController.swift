//
//  ViewController.swift
//  completionhandlers
//
//  Created by Harry Merzin on 6/22/16.
//  Copyright © 2016 harry. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true //makes sure that the activity indicator is hidden
        activityIndicator.stopAnimating()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func functionCallPressed(sender: AnyObject) {
        let networking = Networking(username: usernameTextField.text!, password: passwordTextField.text!) // initialize with username and password so we can login with them in the loginToUdacity() method
        resultLabel.hidden = true // hides the results label so it looks like it turned into an activityIndicator
        activityIndicator.startAnimating() // starts animating the activityIndicator
        networking.loginToUdacity() { (connection, statusCode, error) -> Void in
            print("something")
            print(error)
            print(connection)
            print(statusCode)
            //MARK: the performUIUpdatesOnMain method is to make sure that the ui updates are happening on the main thread because if not, they will cause errors... take the Udacity Grand Central Dispach couse for > info
            performUIUpdatesOnMain{
                self.activityIndicator.stopAnimating() // stops activityIndicator so it hides
                self.resultLabel.hidden = false // unhies label
            }
            if (connection == true && (statusCode >= 200 && statusCode <= 299) && error == nil) {
                performUIUpdatesOnMain{
                    self.resultLabel.text! = "It Worked 😃" // changes label's text to success message
                    print(self.resultLabel.text)
                }
            }
                // MARK: If it doesn't work check to see why
            else if(connection! == false) {
                performUIUpdatesOnMain{
                    self.resultLabel.text = "No Connection 😢"
                }
            }
            else if(statusCode! == 403) {
                performUIUpdatesOnMain{
                    self.resultLabel.text = "Invalid Credentials 🔒"
                }
            }
        }
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // closes the textField when you hid 'done'
        textField.resignFirstResponder()
        return true
    }
    
}