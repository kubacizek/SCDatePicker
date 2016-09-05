//
//  SCDatePicker.swift
//  Helper App
//
//  Created by Stewart Crainie on 21/06/2016.
//  Copyright © 2016 Stewart Crainie. All rights reserved.
//

import UIKit
import Foundation

//Adding Comment to Github

@objc public protocol SCDatePickerDelegate: NSObjectProtocol {
    
    optional func didSelectDate(dateString:String, date:NSDate)
   
}

@objc public protocol SCDateFieldDelegate: NSObjectProtocol {
    
    optional func dateTextHasChanged(dateString:String, date:NSDate)
    
}

public class SCDatePicker: UIDatePicker {
    
    //DatePicker Mode
    public enum SCDatePickerType {
        case date, time, countdown
        
        public func dateType() -> UIDatePickerMode {
            switch self {
            case SCDatePickerType.date: return .Date
            case SCDatePickerType.time: return .DateAndTime
            case SCDatePickerType.countdown: return .CountDownTimer
            }
        }
    }

    //Delegate
    public var scDelegate: SCDatePickerDelegate?
    
    //Public Options
    public var scType: SCDatePickerType!
    
    
    // MARK: - NSObject
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureDatePicker()
        
        
    }
    
    //Layout Subviews
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.datePickerMode = scType.dateType()

    }
    
    //Configure DatePicker
    private func configureDatePicker() {
        
        self.addTarget(self, action: #selector(SCDatePicker.handleDatePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    //MARK: Delegate - handle datepicker selection
    @objc private func handleDatePicker(sender: UIDatePicker) {
        
        if scDelegate != nil {
            scDelegate?.didSelectDate!(dateToString("EEE, dd MMM yyyy", date: sender.date), date: sender.date)
        }
        
    }
    
    //Date -> String (input string required)
    private func dateToString(convertTo:String, date:NSDate) -> String{
        
        let dateFormatter = NSDateFormatter()
        let currentDate = date
        dateFormatter.dateFormat = convertTo
        
        return dateFormatter.stringFromDate(currentDate)
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
}

//DatePickerTexfield Class
public class DateFieldTextField: UITextField, SCDatePickerDelegate{
    
    //Init DatePicker
    let scDatePicker = SCDatePicker()
    
    //Public Options
    public var datetype: SCDatePicker.SCDatePickerType?

    //Toolbar
    public var doneButtonTint:UIColor?
    
    //Delegate
    public var dateDelegate: SCDateFieldDelegate?
    
    // MARK: - NSObject
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    //Layout Subviews
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.inputAccessoryView = configureToolBar()
        scDatePicker.scDelegate = self
        scDatePicker.scType = datetype
        self.inputView = scDatePicker
        
    }
    
    //Date Selected
    public func didSelectDate(dateString: String, date: NSDate) {
        
        if dateDelegate != nil {
            self.text = dateString
            self.dateDelegate?.dateTextHasChanged!(dateString, date: date)
        }
    }
    
    //Configure Toolbar
    private func configureToolBar() -> UIToolbar {
        
        //ToolBar
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.Default
        toolbar.translucent = true
    
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(DateFieldTextField.handleDatePickerDoneButton(_:)))
        
        //Custom Options
        doneButton.tintColor = doneButtonTint
        
        toolbar.setItems([space, doneButton], animated: false)
        toolbar.userInteractionEnabled = true
        toolbar.sizeToFit()
        
        return toolbar
        
    }

    //MARK: Delegate - did select date
    @objc private func handleDatePickerDoneButton(sender:UIBarButtonItem) {
        if dateDelegate != nil {
            self.endEditing(true)
        }
    }

    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
