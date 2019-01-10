
//
//  WLCTutorialVC.swift
//  E3malAap
//
//  Copyright © 2016 E3malAap. All rights reserved.

import UIKit

class WLCTutorialVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    @IBOutlet weak var tutorialCollectionView: UICollectionView!
    @IBOutlet weak var tutorialPageControl: UIPageControl!
    
    @IBOutlet weak var topHeightDescription: NSLayoutConstraint!
    

    @IBOutlet weak var screenTitleLabel: UILabel!
    
    
    //MARK: Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        screenTitleLabel.text = "سجل كصاحب مشروع او باحث عن عمل"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UIAction Method
    
    //This method work for both skip and done button
    @IBAction func doneButtonTapped(sender: AnyObject) {
        
        AppDelegate.presentRootViewController(false, rootViewIdentifier: RootViewControllerIdentifier.fromLogin)
        
    }
    
    
    //MARK: CollectionView DataSource and Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! TutorialCollectionViewCell
        // Configure the cell
        
        if indexPath.row == 0 {
            cell.imageViewTutorialCell.image = UIImage(named: "od1")
            
        }else if indexPath.row == 1 {
            cell.imageViewTutorialCell.image = UIImage(named: "od2")
        
        }else if indexPath.row == 2 {
            
            cell.imageViewTutorialCell.image = UIImage(named: "od4")
            
        }else if indexPath.row == 3 {
            
            cell.imageViewTutorialCell.image = UIImage(named: "od4")
            
        }else if indexPath.row == 4 {
            
            cell.imageViewTutorialCell.image = UIImage(named: "od5")
            
        }else if indexPath.row == 5 {
            
            cell.imageViewTutorialCell.image = UIImage(named: "banner6")
            
        }else if indexPath.row == 6 {
            
            cell.imageViewTutorialCell.image = UIImage(named: "banner7")
            
        }else {
            
            cell.imageViewTutorialCell.image = UIImage(named: "banner8")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return collectionView.frame.size
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let pageWidth = tutorialCollectionView.frame.size.width
        
        //get current page for page control
        let currentPage = tutorialCollectionView.contentOffset.x / pageWidth
        switch currentPage {
        case 0.0 : tutorialPageControl.currentPage = 0
            screenTitleLabel.text = "سجل كصاحب مشروع او باحث عن عمل"
            break
        case 1.0 : tutorialPageControl.currentPage = 1
        screenTitleLabel.text = "اختر القسم المناسب لرفع مشروعك"
            break
        case 2.0 : tutorialPageControl.currentPage = 2
        screenTitleLabel.text = "ابحث عن المشروع المناسب لتقدم عرضك"
            break
        case 3.0 : tutorialPageControl.currentPage = 3
        case 4.0 : tutorialPageControl.currentPage = 4
        case 5.0 : tutorialPageControl.currentPage = 5
        case 6.0 : tutorialPageControl.currentPage = 6
        default : break
        }
    }
    
}
