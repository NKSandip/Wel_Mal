//
//  BidCellType1.swift
//  E3malApp
//
//  Created by Pawan Dhawan on 28/11/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

protocol BidCellValues {
    func setAmount(text:String)
    func setDate(text:String)
    func setCoverText(text:String)
}

class BidCellType1: UITableViewCell , UITextFieldDelegate{
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var bidAmount: UITextField!
    
    @IBOutlet weak var bidAmountPostFix: UITextField!
    var localtextDirection : NSTextAlignment?

    var delegate:BidCellValues?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        bidAmount.delegate = self
        // Configure the view for the selected state
        
        localtextDirection = textDirection()
        self.bidAmount.textAlignment = localtextDirection!
        if Localisator.sharedInstance.currentLanguage == "ar"{
            nameLabel.font = UIFont(name: "Geeza Pro", size: (self.nameLabel.font?.pointSize)!)
//            self.bidAmount.font = UIFont(name: "Geeza Pro", size: (self.bidAmount.font?.pointSize)!)
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if (textField.text?.contains("SAR"))! {
            textField.text = textField.text!.replacingOccurrences(of: "SAR", with: "")
        }
        textField.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if (textField.text?.contains("SAR"))! == false {
            textField.text = textField.text! + " " + "SAR"
        }
        
        delegate?.setAmount(text: textField.text!)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if((textField.text?.characters.count)! > 5 && range.length == 0) {
            return false;
        }
        return true;
        
    }

}


class BidCellType2: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var bidDate: UITextField!
    
    var localtextDirection : NSTextAlignment?
    var date = ""
    
    var delegate:BidCellValues?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        localtextDirection = textDirection()
        self.bidDate.textAlignment = localtextDirection!
        if Localisator.sharedInstance.currentLanguage == "ar"{
            self.nameLabel.font = UIFont(name: "Geeza Pro", size: (self.nameLabel.font?.pointSize)!)
//            self.bidDate.font = UIFont(name: "Geeza Pro", size: (self.bidDate.font?.pointSize)!)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        date = dateFormatter.string(from: Date())
        delegate?.setDate(text: date)
        //bidDate.text = getDateAndTime(dateInString: date)
        
        bidDate.addTarget(self, action:#selector(textFieldEditing(sender:)), for: .editingDidBegin)
        bidDate.addTarget(self, action:#selector(removeDatePicker(sender:)), for: .editingDidEnd)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func textFieldEditing(sender: UITextField) {
        // 6
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.locale = NSLocale.init(localeIdentifier: "en_US") as Locale
        datePickerView.minimumDate = Date()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
        
        if date != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale.init(localeIdentifier: "en_US") as Locale
            dateFormatter.dateFormat = "yyyy-MM-dd"
            datePickerView.date = dateFormatter.date(from: date)!
        }
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.init(localeIdentifier: "en_US") as Locale
        dateFormatter.dateFormat = "yyyy-MM-dd"
        date = dateFormatter.string(from: sender.date)
        //bidDate.text = getDateAndTime(dateInString: date)
        
    }
    
    @IBAction func removeDatePicker(sender: AnyObject) {
        delegate?.setDate(text: date)
    }
    
}

class BidCellType3: UITableViewCell , UITextViewDelegate{
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var bidCoverLetter: UITextView!
    var localtextDirection : NSTextAlignment?
    var delegate:BidCellValues?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        localtextDirection = textDirection()
        self.bidCoverLetter.textAlignment = localtextDirection!
        self.bidCoverLetter.text = Localization("Enter cover text.")
        if Localisator.sharedInstance.currentLanguage == "ar"{
            self.nameLabel.font = UIFont(name: "Geeza Pro", size: (self.nameLabel.font?.pointSize)!)
//            self.bidCoverLetter.font = UIFont(name: "Geeza Pro", size: (self.bidCoverLetter.font?.pointSize)!)
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Localization("Enter cover text.") {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = Localization("Enter cover text.")
        }
        delegate?.setCoverText(text: textView.text!)
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if range.location == textView.text?.length && text == " " {
            textView.text = textView.text! + "\u{00a0}"
            return false
        }
        return true
    }

    
}

class BidCellType4: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var uploadDoc: UIButton!
    var localtextDirection : NSTextAlignment?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.nameLabel.text = Localization("Upload Documents")
        localtextDirection = textDirection()
        self.uploadDoc.titleLabel?.textAlignment = localtextDirection!
        if Localisator.sharedInstance.currentLanguage == "ar"{
            self.nameLabel.font = UIFont(name: "Geeza Pro", size: (self.nameLabel.font?.pointSize)!)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        
    }
    
}

