//
//  APJobsDetailVC+Services.swift
//  OnDemandApp
//
//  Created by Shwetabh Singh on 23/08/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation

extension APJobsDetailVC{
    
    func cancelJob() {
        //show loader
        self.navigationController!.view.showLoader(mainTitle: "", subTitle: Localization("please wait"))
        
        self.jobObj!.cancelJob(Int((self.jobObj?.id)!)) { (success, error) -> (Void) in
            // hide loader
            DispatchQueue.main.async {
                self.navigationController!.view.hideLoader()
            
            if let _ = error {
                self.showAlertViewWithMessage((error?.localizedDescription)!, message: "")
            } else {
                
                self.delegate?.cancelAction!(Int((self.jobObj?.id)!))
                self.showAlertViewWithMessageAndActionHandler("Job cancelled.", message: "", actionHandler: {
                    // do nothing
                })
            }
        }
        }
    }
    
    
    func completeJob() {
        //show loader
        self.navigationController!.view.showLoader(mainTitle: "", subTitle: Localization("please wait"))
        
        self.jobObj!.completeJob(Int((self.jobObj?.id)!)) { (success, error) -> (Void) in
            // hide loader
            DispatchQueue.main.async {
                self.navigationController!.view.hideLoader()
            
            if let _ = error {
                self.showAlertViewWithMessage((error?.localizedDescription)!, message: "")
            } else {
                
                self.delegate?.completeAction!(Int((self.jobObj?.id)!))
                self.showAlertViewWithMessageAndActionHandler("Job completed.", message: "", actionHandler: {
                    // do nothing
                })
            }
            }
        }
    }
    
    func acceptJob() {
        //show loader
        self.navigationController!.view.showLoader(mainTitle: "", subTitle: Localization("please wait"))
        
        self.jobObj!.acceptJob(Int((self.jobObj?.id)!)) { (success, error) -> (Void) in
            // hide loader
            DispatchQueue.main.async {
                self.navigationController!.view.hideLoader()
            
            if let _ = error {
                self.showAlertViewWithMessage((error?.localizedDescription)!, message: "")
            } else {
                self.delegate?.acceptAction!(Int((self.jobObj?.id)!))
                self.showAlertViewWithMessageAndActionHandler("Job accepted.", message: "", actionHandler: {
                    // do nothing
                })
                }
            }
        }
    }
    
}
