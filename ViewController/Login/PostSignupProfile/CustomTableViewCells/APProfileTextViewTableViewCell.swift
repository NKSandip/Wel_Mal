//
//  APProfileTextViewTableViewCell.swift
//  E3malApp
//
//  Created by Rishav Tomar on 09/11/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class APProfileTextViewTableViewCell: UITableViewCell {

    @IBOutlet weak var profileTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.profileTextView.changeCornerAndColor(10, borderWidth: 1.0, color: Constants.cornerColorBlack)
        self.profileTextView.textAlignment = Localisator.sharedInstance.currentTextDirection
        self.profileTextView.placeholderText = Localization("Bio")
        if Localisator.sharedInstance.currentLanguage == "ar"{
            self.profileTextView.font = UIFont(name: "Geeza Pro", size: (self.profileTextView.font?.pointSize)!)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
