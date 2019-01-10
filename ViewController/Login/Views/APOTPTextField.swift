//
//  OTPTextField.swift
//  OnDemandApp
//
//  Created by Pawan Joshi on 28/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

protocol OTPTextFieldDelegate {
    func backspaceInEmptyFieldPressed(_ textField: UITextField)
}

class OTPTextField: UITextField {

    var otpDelegate: OTPTextFieldDelegate?
    
    override func deleteBackward() {
        super.deleteBackward()
        
        if self.text == nil || self.text?.length == 0 {
            otpDelegate?.backspaceInEmptyFieldPressed(self)
        }
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
}
