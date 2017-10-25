//
//  SetTripDatesViewController.swift
//  TripJournal
//
//  Created by Jacqueline Sloves on 4/19/16.
//  Copyright © 2016 Jacqueline Sloves. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SetTripDatesViewController : UIViewController {
    
    //MARK - UIOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!

    @IBOutlet weak var nextButton: UIButton!
    
    //MARK - View LifeCycle
    override func viewDidLoad() {
        nextButton.isEnabled = false
    }
    
    @IBAction func addTitle(_ sender: AnyObject) {
        enableButton()
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addStartDate(_ sender: UITextField) {
        resignFirstResponder()
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.startDatePickerValueChanged), for: UIControlEvents.valueChanged)
        enableButton()

    }
    
    @IBAction func addEndDate(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.endDatePickerValueChanged), for: UIControlEvents.valueChanged)

    }
    
    func startDatePickerValueChanged(_ sender: UIDatePicker, textFieldToChange: UITextField) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        startDateTextField.text = dateFormatter.string(from: sender.date)
        enableButton()

    }
    
    func endDatePickerValueChanged(_ sender: UIDatePicker, textFieldToChange: UITextField) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        endDateTextField.text = dateFormatter.string(from: sender.date)
        enableButton()

    }
    
    func validateDates(){
    //TODO: Ensure End date is after Start Date
    }
    
    func enableButton(){
        if titleTextField.text != "" && startDateTextField.text != "" && endDateTextField.text != "" {
            nextButton.isEnabled = true
        }
    }
  
    @IBAction func nextButtonPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "LoginSegue", sender: self)
    }
    
    }
