//
//  MyTripsViewController.swift
//  TripJournal
//
//  Created by Jacqueline Sloves on 4/19/16.
//  Copyright © 2016 Jacqueline Sloves. All rights reserved.
//

import UIKit

class MyTripsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func AddTrip(_ sender: AnyObject) {
        performSegue(withIdentifier: "AddTrip", sender: self)
    }

    @IBAction func loginPressed(_ sender: UIButton) {
        InstagramClient.sharedInstance().authenticateWithViewController(self) { (success, errorString) in
            performUIUpdatesOnMain {
                if success {
                    self.completeLogin()
                } else {
                    print("ERROR: ", errorString)
                }
            }
        
        }
    
    }
    
    //MARK: Login
    
    fileprivate func completeLogin() {
        let vc = storyboard!.instantiateViewController(withIdentifier: "SetTripDatesViewController") 
        present(vc, animated: true, completion: nil)
    
    }
    
}

