//
//  APPostSignupProfileViewController.swift
//  E3malApp
//
//  Created by Rishav Tomar on 09/11/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift


@objc protocol APProfilePickerImageDelgate {
    func getPickedImage(pickedImage: UIImage)
}

enum TextFieldEnum : Int {
    case Name = 1,DateOfBirth,Email,Country,City,Mobile
}

class APPostSignupProfileViewController: BaseViewController,  UITableViewDataSource, UITableViewDelegate,APProfileImageDelegate, APProfileStartButtonDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    var pickerView: UIPickerView!
    
     // MARK: variables
    var name:String?
    var email:String?
    var password:String?
    var profilePicPath:String?
    var bio:String?
    var nameTextFieldValue: String?
    var emailTextFieldValue: String?
    var phoneNumberTextFieldValue: String?
    var cityTextFieldValue: String?
    var countryTextFieldValue: String?
    var bioTextFieldValue: String?
    var dobTextFieldValue: String?
    var textViewPlaceholderText = Localization("Bio (Optional)")
    var isTextViewEmpty = true
    var textFieldCount: Int?
    var activeField: UITextField?
    var delegate: APProfilePickerImageDelgate?
    var isProviderScreen = false
    var profileImage : UIImage?
    let imagePicker = UIImagePickerController()
    var countryList:[GulfCountry]?
    var selectedCountryIndex = -1
    var newSelectedCountryIndex = -1
    var selectedCountryId: NSNumber?
    var selectedCityId: NSNumber?
    var isImageUploaded: Bool = false
    var selectedCityIndex = -1
    var selectedDate: Date?
    var dialingCode: String?
    
    //MARK: View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = Localization("PERSONAL DETAILS")
        IQKeyboardManager.sharedManager().previousNextDisplayMode = .alwaysHide
        self.titleLabel.addTextSpacing(spacing: 1)
        self.profileTableView.dataSource = self
        self.profileTableView.delegate =  self
        self.profileTableView.separatorStyle = .none
        self.profileTableView.allowsSelection = true
        self.imagePicker.delegate = self
        if  UserManager.sharedManager().userType == .userTypeProvider {
            self.isProviderScreen = true
            getCountryList()
          }
        else {
            self.isProviderScreen = false
        }
        self.pickerView = UIPickerView()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    //MARK: UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell: UITableViewCell?
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImageCell") as! APImageSelectionTableViewCell
            cell.delegate = self
            self.delegate = cell
            if self.profileImage != nil {
                cell.profileImageView.image = self.profileImage
            }
            if  UserManager.sharedManager().userType == .userTypeSeeker {
                cell.profilePicTopConstraint.constant = 46
            }
            returnCell = cell
            
        case 1,2,3,4,5,6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTextFieldCell") as! APProfileTextFieldTableViewCell
            cell.profileTextField.tag = indexPath.row
            cell.profileTextField.delegate = self
            self.configureCellForTextField(cell: cell, forRowAtIndexPath: indexPath)
            
            returnCell = cell
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTextViewCell") as!APProfileTextViewTableViewCell
            cell.profileTextView.text = textViewPlaceholderText
            cell.profileTextView.delegate = self
            cell.profileTextView.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
            cell.profileTextView.textContainerInset = UIEdgeInsetsMake(5, 2, 5, 5)
            returnCell = cell
        case 8:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileButtonCell") as!APProfileButtonTableViewCell
            cell.delegate = self
            if (self.isProviderScreen) {
                cell.profileStartButton.setTitle(Localization("NEXT"), for: .normal)
            }
            else {
                cell.profileStartButton.setTitle(Localization("GREAT! LET'S START"), for: .normal)
            }
            cell.profileStartButton.titleLabel?.addTextSpacing(spacing: 1)
            returnCell = cell
        default:()
            
        }
        
        return returnCell!
    }
    
    //MARK: UITableView Delegates
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight: CGFloat?
        switch indexPath.row {
        case 0:
            if (self.isProviderScreen){
                rowHeight = 101
            }
            else {
                rowHeight = 143
                
            }
        case 5,4:
            if (self.isProviderScreen) {
                rowHeight = 56
            }
            else {
                rowHeight = 0
            }
        case 7:
            rowHeight = 86
        default:
            rowHeight = 56
        }
        return rowHeight!
    }
    
    func configureCellForTextField(cell: APProfileTextFieldTableViewCell, forRowAtIndexPath: IndexPath) {
        switch forRowAtIndexPath.row {
        case 1:
            if(self.name == nil || self.name == "") {
            cell.profileTextField.placeholder = Localization("Name")
            }
            else {
                cell.profileTextField.text = name!
            }
        case 2:
            cell.profileTextField.placeholder = Localization("Date of Birth (Optional)")
            cell.profileTextField.clearButtonMode = .never
            cell.profileTextField.tintColor = UIColor.clear

        case 3:
            if(self.email == nil || self.email == "") {
            cell.profileTextField.placeholder = Localization("E-mail")
            }
            else {
                cell.profileTextField.text = email!
            }
        case 6:
            cell.profileTextField.placeholder = Localization("Mobile (Optional)")
        case 4:
             cell.profileTextField.placeholder = Localization("Country")
             cell.profileTextField.clearButtonMode = .never
             cell.profileTextField.tintColor = UIColor.clear

        case 5:
            cell.profileTextField.placeholder = Localization("City")
            cell.profileTextField.isUserInteractionEnabled = false
            cell.profileTextField.clearButtonMode = .never
            cell.profileTextField.tintColor = UIColor.clear
            
        default:
            cell.profileTextField.placeholder = Localization("")
        }
    }
    
    //MARK: APProfileImageDelegate
    func openActionSheet(sender:UIButton) {
        self.openImagePickerController(sender)
    }
    
    func profileStartBtnPressed() {
        self.view.window?.endEditing(true)
        if self.textValidation() {
            if(self.isImageUploaded) {
              self.updateProfileImage()
             }
            else {
              self.startNetworkRequest()
            }

        }
    }
    
    func startNetworkRequest() {
        if(isProviderScreen) {
            self.sendWorkProfileInfo()
        }
        else {
            self.sendProfileInfo()
        }
    }
    
    func textValidation() -> Bool {
        
        for index in 0..<7 {
            let indexpath = IndexPath(row: index, section: 0)
            if let cellAtIndex = self.profileTableView.cellForRow(at: indexpath) as? APProfileTextFieldTableViewCell{
                let textFieldString = cellAtIndex.profileTextField.text
                if(isProviderScreen) {
                if !(textFieldString?.isEmpty)! {
                    self.getFieldValuesForProvider(index: indexpath.row, string: textFieldString!)
                }
                else if(indexpath.row == 2 && (textFieldString?.isEmpty)! ){
                    self.dobTextFieldValue = ""
                }
                else if(indexpath.row == 6 && (textFieldString?.isEmpty)!) {
                    self.phoneNumberTextFieldValue = ""
                }
                else  {
                    self.view.makeToast("\((cellAtIndex.profileTextField.placeholder)!) field can not be empty", duration: 3, position: .bottom)
                    return false
                    
                }
              }
                else {
                    if(index != 5 && index != 4){
                       if !(textFieldString?.isEmpty)! {
                       self.getValuesForSeeker(index: indexpath.row, string: textFieldString!)
                        }
                       else if(indexpath.row == 2 && (textFieldString?.isEmpty)! ){
                        self.dobTextFieldValue = ""
                       }
                       else if(indexpath.row == 6 && (textFieldString?.isEmpty)!) {
                        self.phoneNumberTextFieldValue = ""
                       }
                        else {
                           self.view.makeToast("\((cellAtIndex.profileTextField.placeholder)!) field can not be empty", duration: 3, position: .bottom)
                        return false
                        }
                    }
                }
            }
        }
        
        let indexpath = IndexPath(row: 7, section: 0)
        if let cellAtIndex = self.profileTableView.cellForRow(at: indexpath) as? APProfileTextViewTableViewCell{
            let textViewString = cellAtIndex.profileTextView.text
            if  ((!(textViewString?.isEmpty)!) && textViewString != Localization("Bio (Optional)") ) {
                self.bioTextFieldValue = textViewString
            }
            else {
                self.bioTextFieldValue = Localization("NA") 
            }

        }
        return true
    }
    
    //MARK : UIDate Picker
    func openDatePicker() {
        let datePickerView:UIDatePicker = UIDatePicker()
        let locale = NSLocale.init(localeIdentifier: "en_US") as Locale
        datePickerView.locale = locale
        datePickerView.datePickerMode = UIDatePickerMode.date
        activeField?.inputView = datePickerView
        let gregorian =  NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let currentDate = NSDate()
       
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        let dateComponents = NSDateComponents()
        dateComponents.year = -10
        let maxdate = gregorian.date(byAdding: dateComponents as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue:0))!
        dateComponents.year = -150
        let mindate = gregorian.date(byAdding: dateComponents as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))!
        datePickerView.maximumDate = maxdate
        datePickerView.minimumDate = mindate
        dateFormatter.dateStyle = .medium
        if(self.selectedDate == nil) {
            self.selectedDate = currentDate as Date
            activeField?.text = dateFormatter.string(from: maxdate)
        }
        else {
            datePickerView.date =  self.selectedDate!
            activeField?.text = dateFormatter.string(from: self.selectedDate!)
        }
        
        datePickerView.addTarget(self, action: #selector(APPostSignupProfileViewController.datePickerValueChanged(_:)), for: UIControlEvents.valueChanged)
    }
    
    func datePickerValueChanged(_ sender:UIDatePicker)  {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.init(localeIdentifier: "en_US") as Locale
        dateFormatter.dateStyle = .medium
        self.selectedDate = nil
        self.selectedDate = sender.date
        DispatchQueue.main.async {
        self.activeField?.text = dateFormatter.string(from: self.selectedDate!)
        }
    }
    
    func getFieldValuesForProvider(index: Int, string: String) {
        switch index {
        case 1:
             self.nameTextFieldValue = string
        case 2:
            self.dobTextFieldValue = string
        case 3:
            self.emailTextFieldValue = string
        case 6:
            phoneNumberTextFieldValue =  self.dialingCode! + " " + string
        case 4:
            self.countryTextFieldValue = string
        case 5:
            self.cityTextFieldValue = string
        default: ()
           
        }
     }
    
     func getValuesForSeeker(index: Int, string: String) {
        switch index {
        case 1:
             self.nameTextFieldValue = string
        case 2:
            self.dobTextFieldValue = string
        case 3:
            self.emailTextFieldValue = string
        case 6:
            self.phoneNumberTextFieldValue = string
        default: ()
        
        }
    }
    
    func enableCityTextField() {
        let indexpath = IndexPath(row: 5, section: 0)
        if let cellAtIndex = self.profileTableView.cellForRow(at: indexpath) as? APProfileTextFieldTableViewCell {
          cellAtIndex.profileTextField.isUserInteractionEnabled = true
        }
    }
    
    func disableCityTextField() {
        let indexpath = IndexPath(row: 5, section: 0)
        if let cellAtIndex = self.profileTableView.cellForRow(at: indexpath) as? APProfileTextFieldTableViewCell {
            cellAtIndex.profileTextField.isUserInteractionEnabled = false
        }
    }
    
    func enableContryTextField() {
        let indexpath = IndexPath(row: 4, section: 0)
        if let cellAtIndex = self.profileTableView.cellForRow(at: indexpath) as? APProfileTextFieldTableViewCell {
            cellAtIndex.profileTextField.isUserInteractionEnabled = true
        }
    }
    
    func disableCountryTextField() {
        let indexpath = IndexPath(row: 4, section: 0)
        if let cellAtIndex = self.profileTableView.cellForRow(at: indexpath) as? APProfileTextFieldTableViewCell {
            cellAtIndex.profileTextField.isUserInteractionEnabled = false
        }
    }
    
    func setCityTextFieldText() {
        let indexpath = IndexPath(row: 5, section: 0)
        if let cellAtIndex = self.profileTableView.cellForRow(at: indexpath) as? APProfileTextFieldTableViewCell {
            cellAtIndex.profileTextField.text = nil
            cellAtIndex.profileTextField.placeholder = Localization("City")
            selectedCityIndex = -1
        }
    }
    
    func setCityTextFieldTextValue() {
        let indexpath = IndexPath(row: 5, section: 0)
        if let cellAtIndex = self.profileTableView.cellForRow(at: indexpath) as? APProfileTextFieldTableViewCell {
            if(selectedCityIndex != -1 && selectedCityIndex < (self.countryList?[selectedCountryIndex].cities?.count)!) {
            let city = self.countryList?[selectedCountryIndex].cities?[selectedCityIndex] as? City
            cellAtIndex.profileTextField.text = city?.name
            }
        }
    }
    
    func setCountryCode(row: Int) {
        let indexpath = IndexPath(row: 6, section: 0)
        if let cellAtIndex = self.profileTableView.cellForRow(at: indexpath) as? APProfileTextFieldTableViewCell{
            let label = UILabel(frame: CGRect(x: 5, y: 0, width: 40, height: 30))
            if Localisator.sharedInstance.currentLanguage == "ar"{
                cellAtIndex.profileTextField.rightView = label
                cellAtIndex.profileTextField.rightViewMode = .always
            }
            else {
            cellAtIndex.profileTextField.leftView = label
            cellAtIndex.profileTextField.leftViewMode = .always
            }
            label.text = self.countryList?[row].dialingCode
            label.font = UIFont(name: "FSJoey-Light", size:  12.0)
            label.textColor = UIColor.white
            label.textAlignment = .center
            self.dialingCode = self.countryList?[row].dialingCode
            cellAtIndex.profileTextField.placeholderText = ""
                        
        }
    }
    
}
//MARK: UITextFieldDelegate
extension APPostSignupProfileViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        let isFirstResponder = textField.isFirstResponder
        if isFirstResponder ==  false {
            activeField = textField
            switch textField.tag {
            case TextFieldEnum.DateOfBirth.rawValue:
                self.openDatePicker()
            case TextFieldEnum.Email.rawValue:
                if(self.email != nil && self.email != "") {
                textField.text = self.email
                }
                textField.isUserInteractionEnabled = false
            case  TextFieldEnum.Mobile.rawValue:
                textField.keyboardType = .numberPad
                
            case TextFieldEnum.Country.rawValue:
                textField.inputView = self.pickerView
                if(self.countryList?.count != 0) {
                    if(selectedCountryIndex == -1) {
                      textField.text = self.countryList?[0].name
                      self.selectedCountryId = self.countryList?[0].countryId
                     selectedCountryIndex = 0
                     self.pickerView.selectRow(0, inComponent: 0, animated: false)
                     self.setCountryCode(row: 0)
                    }
                    else {
                       textField.text = self.countryList?[selectedCountryIndex].name
                       self.selectedCountryId = self.countryList?[selectedCountryIndex].countryId
                         self.pickerView.selectRow(selectedCountryIndex, inComponent: 0, animated: false)
                        self.setCountryCode(row: selectedCountryIndex)
                    }
                }
                self.disableCityTextField()
                
            case TextFieldEnum.City.rawValue:
                
                textField.inputView = self.pickerView
                if(self.countryList?.count != 0) {
                    if(selectedCountryIndex == -1) {
                    let city = self.countryList?[0].cities?[0] as? City
                    textField.text = city?.name
                     self.selectedCityId = city?.cityId
                     self.pickerView.selectRow(0, inComponent: 0, animated: false)
                    }
                    else {
                        if(selectedCityIndex == -1) {
                            let city = self.countryList?[selectedCountryIndex].cities?[0] as? City
                            textField.text = city?.name
                            self.selectedCityId = city?.cityId
                            self.pickerView.selectRow(0, inComponent: 0, animated: false)
                        }
                        else {
                        let city = self.countryList?[selectedCountryIndex].cities?[selectedCityIndex] as? City
                        textField.text = city?.name
                        self.selectedCityId = city?.cityId
                        self.pickerView.selectRow(selectedCityIndex, inComponent: 0, animated: false)
                        }
                    }
                }
                
                self.disableCountryTextField()
          
            default:()
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField.tag == TextFieldEnum.Name.rawValue || textField.tag == TextFieldEnum.Mobile.rawValue) {
            return true
        } else {
            return false
        }
    }
        
    func textFieldDidEndEditing(_ textField: UITextField) -> Bool {
        
        if(textField.tag == TextFieldEnum.Country.rawValue && isProviderScreen) {
            self.enableCityTextField()
            if(newSelectedCountryIndex == -1){
                newSelectedCountryIndex = selectedCountryIndex
            }
            else if(newSelectedCountryIndex != selectedCountryIndex) {
                newSelectedCountryIndex = selectedCountryIndex
               self.setCityTextFieldText()
            }
            else if(newSelectedCountryIndex == selectedCountryIndex){
                self.setCityTextFieldTextValue()
            }
        } else if(textField.tag == TextFieldEnum.City.rawValue && isProviderScreen) {
            self.enableContryTextField()
        }
        
        return true
    }
}

extension APPostSignupProfileViewController {
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.isImageUploaded = true
            self.profileImage = pickedImage
            self.delegate?.getPickedImage(pickedImage: pickedImage)
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension APPostSignupProfileViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    @objc(numberOfComponentsInPickerView:) func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(activeField?.tag == TextFieldEnum.Country.rawValue) {
            return self.countryList!.count
        }
        else if (activeField?.tag == TextFieldEnum.City.rawValue) {
            
            if self.selectedCountryIndex == -1{
                return 0
            } else {
                return  (self.countryList?[selectedCountryIndex].cities?.count)!
            }
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(activeField?.tag == TextFieldEnum.Country.rawValue) {
         return   self.countryList?[row].name
        }
        else if (activeField?.tag == TextFieldEnum.City.rawValue) {
        let city = self.countryList?[selectedCountryIndex].cities?[row] as! City
            return city.name
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(activeField?.tag == TextFieldEnum.Country.rawValue) {
            activeField?.text = self.countryList?[row].name
            self.selectedCountryId = self.countryList![row].countryId
            selectedCountryIndex = row
            self.setCountryCode(row: row)
        }
        else if (activeField?.tag == TextFieldEnum.City.rawValue) {
            let city = self.countryList?[selectedCountryIndex].cities?[row] as! City
            self.selectedCityId = city.cityId
            activeField?.text = city.name
            selectedCityIndex = row
        }
    }
}

// MARK : UITextViewDelegate
extension APPostSignupProfileViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.textColor?.isEqual(UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)))!
        {
            textView.text = nil
            textView.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        self.isTextViewEmpty = false
        let maxLength = 250
        let currentString: NSString = textView.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: text) as NSString
        return newString.length <= maxLength
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text =  textViewPlaceholderText
            textView.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        }
        else {
            self.bioTextFieldValue = textView.text
        }
    }
    
}

