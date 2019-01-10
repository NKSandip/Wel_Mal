//
//  AutoCompleteTableView.swift
//  E3malApp
//
//  Created by Pawan Dhawan on 25/11/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

@objc protocol AutoCompleteTableViewDelegate {
    func updateTextFieldWithText(text:String, tagId:NSNumber)
    @objc optional func showSearchBg(flag:Bool)
}

class AutoCompleteTableView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var rowHeight = 30
    var autocompleteTableView : UITableView?
    var autocompleteUrls:[E3malServiceType]?
    var delegate:AutoCompleteTableViewDelegate?
    
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
    }
    
    //MARK : Class Methods
    
    private func setupView() {
        
        autocompleteTableView = UITableView(frame: CGRect(x:0, y:0, width:self.frame.size.width, height:90))
        autocompleteTableView!.delegate = self
        autocompleteTableView!.dataSource = self
        autocompleteTableView!.isScrollEnabled = true
        autocompleteTableView!.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.addSubview(autocompleteTableView!)
        autocompleteTableView?.separatorStyle = .none
        
    }
    
    func updateDataSource(dataSource : [E3malServiceType]?){
        
        self.autocompleteUrls = dataSource
        autocompleteTableView?.reloadData()
    }
    
    func updateTableRowHeight(value : Int){
        
        self.rowHeight = value
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (autocompleteUrls == nil || autocompleteUrls!.count == 0) {
            autocompleteTableView?.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            self.frame.size.height = (autocompleteTableView?.frame.size.height)!
            delegate?.showSearchBg!(flag: false)
            return 0
        }
        
        if autocompleteUrls!.count >= 5 {
            autocompleteTableView?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height:CGFloat(rowHeight * 5))
            self.frame.size.height = (autocompleteTableView?.frame.size.height)!
            
        }else{
            
            autocompleteTableView?.frame = CGRect(x:0, y:0,  width:self.frame.size.width, height:CGFloat(rowHeight * autocompleteUrls!.count))
            self.frame.size.height = (autocompleteTableView?.frame.size.height)!
        }
        delegate?.showSearchBg!(flag: true)
        
        return autocompleteUrls!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let autoCompleteRowIdentifier = "cell"
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: autoCompleteRowIdentifier, for: indexPath) as UITableViewCell
        let index = indexPath.row as Int
        
        cell.textLabel!.text = autocompleteUrls![index].serviceName
        cell.textLabel!.font = UIFont(name: "FS Joey", size: 12.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  CGFloat(self.rowHeight)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell : UITableViewCell = tableView.cellForRow(at: indexPath)!
        let serviceType = autocompleteUrls?[indexPath.row]
        updateDataSource(dataSource: nil)
        delegate?.updateTextFieldWithText(text: selectedCell.textLabel!.text!, tagId: (serviceType?.serviceTypeId!)!)
    }
    
    
}
