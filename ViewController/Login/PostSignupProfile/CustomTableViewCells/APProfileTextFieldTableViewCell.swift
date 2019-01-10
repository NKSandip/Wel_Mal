//
//  APProfileTextFieldTableViewCell.swift
//  E3malApp
//
//  Created by Rishav Tomar on 09/11/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class APProfileTextFieldTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.profileTextField.changeCornerAndColor(10, borderWidth: 1.0, color: Constants.cornerColorBlack)
        self.profileTextField.textAlignment = Localisator.sharedInstance.currentTextDirection
        if Localisator.sharedInstance.currentLanguage == "ar"{
            self.profileTextField.font = UIFont(name: "Geeza Pro", size: (self.profileTextField.font?.pointSize)!)
        }
        let clearButton : UIButton =  self.profileTextField.value(forKey: "_clearButton") as! UIButton
        clearButton.setImage(UIImage(named: "cross-icon"), for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
