//
//  AddEditProject.swift
//  PManagement
//
//  Created by Prateek Kansara on 17/03/17.
//  Copyright © 2017 prateek. All rights reserved.
//

import Foundation
import Eureka
import RealmSwift
import SVProgressHUD

class AddEditProject : FormViewController{
    
    let realm = try! Realm()
    
    var GlobalProjectObject : Projects?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItemsAndRevealView()
        
        
        initializeForm(GlobalProjectObject)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setupNavigationItemsAndRevealView() {
        
        navigationController?.setNavBackgrounColor(PMColors().navigationColor)
        navigationController?.navigationBar.tintColor = UIColor.white
        let titleAttributes : NSDictionary = [
            NSFontAttributeName : constants().navigationTitleFont!,
            NSForegroundColorAttributeName : UIColor.white
        ]
        
        self.navigationController!.navigationBar.titleTextAttributes = titleAttributes as? [String : AnyObject]
        self.navigationItem.rightBarButtonItem?.target = self
        self.navigationItem.rightBarButtonItem?.action = #selector(self.saveButtonPressed)
    }

    
    func initializeForm(_ projectObject : Projects?) {
        
        if (projectObject != nil) {
            self.title = "Edit Project"
        }else{
            self.title = "Add Project"
            GlobalProjectObject = Projects()
        }
        
        let formSection = Section()
        
        form +++ formSection
            
            <<< TextRow("name") { row in
                row.title = "Project Name*"
                if let name = projectObject?.name{
                    row.value = name
                }
                
                row.add(rule: RuleRequired(msg: "Name Can't be empty"))
                row.onChange({
                    row in
                    try! self.realm.write({
                        self.GlobalProjectObject?.name = ""
                        if row.value != nil {
                            self.GlobalProjectObject?.name = row.value!
                        }
                    })
                })
            }

            <<< TextAreaRow("detail"){row in
                row.placeholder = "Project Detail"
                row.value = projectObject?.detail
                row.onChange({
                    row in
                    try! self.realm.write({
                        self.GlobalProjectObject?.detail = ""
                        if row.value != nil {
                            self.GlobalProjectObject?.detail = row.value!
                        }
                    })
                })
        }
            
        
        form +++ Section(constants().requiredFieldsMessage)
    }
    func backButtonPressed () {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    func saveButtonPressed (){
        for rows in form.allRows{
            if rows.isHighlighted {
                rows.reload()
            }
        }
        
        var message = alertMessages().projectUpdated
        
        try! realm.write({
            
            GlobalProjectObject?.creationDate = Date()
            
            if let operationType = GlobalProjectObject?.operationType{
                GlobalProjectObject?.operationType = operationType
            }
            if let id = GlobalProjectObject?.id  {
                if id.isEmpty {
                    GlobalProjectObject?.id = String(format: "%f", Date().timeIntervalSince1970)
                    GlobalProjectObject?.operationType = "POST"
                    message = alertMessages().projectAdded
                }
                else{
                    GlobalProjectObject?.operationType = "PUT"
                }
            }
            else if GlobalProjectObject?.id == nil{
                GlobalProjectObject?.id = String(format: "%f", Date().timeIntervalSince1970)
                GlobalProjectObject?.operationType = "POST"
                message = alertMessages().projectAdded
            }
            else{
                GlobalProjectObject?.operationType = "PUT"
            }
            
            realm.add(GlobalProjectObject!, update: true)
        })
        
        SVProgressHUD.showSuccess(withStatus: message)
        let deadlineTime = DispatchTime.now() + .seconds(constants().messageBlockDuration)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            let _ = self.navigationController?.popViewController(animated: true)
        }
    }

}
