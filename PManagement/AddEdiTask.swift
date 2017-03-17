//
//  AddEdiTask.swift
//  PManagement
//
//  Created by Prateek Kansara on 17/03/17.
//  Copyright © 2017 prateek. All rights reserved.
//

import Foundation

import Foundation
import Eureka
import RealmSwift
import SVProgressHUD

class AddEditTask : FormViewController{
    
    let realm = try! Realm()
    
    var GlobalTaskObject : Tasks?
    var projectName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItemsAndRevealView()
        
        
        initializeForm(GlobalTaskObject)
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
    
    
    func initializeForm(_ taskObject : Tasks?) {
        
        if (taskObject != nil) {
            self.title = "Edit Task"
        }else{
            self.title = "Add Task"
            GlobalTaskObject = Tasks()
        }
        
        let formSection = Section()
        
        form +++ formSection
            
            <<< TextRow("title") { row in
                row.title = "Task Title*"
                if let name = taskObject?.title{
                    row.value = name
                }
                row.add(rule: RuleRequired(msg: "Title Can't be empty"))
                row.onChange({
                    row in
                    try! self.realm.write({
                        self.GlobalTaskObject?.title = ""
                        if row.value != nil {
                            self.GlobalTaskObject?.title = row.value!
                        }
                    })
                })
            }
            
            <<< PickerInlineRow<String>("status") { row in
                row.title = "Status*"
                
                for statusValue in constants().taskStatus{
                    row.options.append(statusValue)
                }
                row.value = taskObject?.status
                row.add(rule: RuleRequired(msg: "Status Can't be empty"))
                
                row.onChange({
                    row in
                    try! self.realm.write({
                        self.GlobalTaskObject?.status = ""
                        if row.value != nil {
                            self.GlobalTaskObject?.status = row.value!
                        }
                    })
                })
 
            }
            
            <<< TextAreaRow("description"){row in
                row.placeholder = "Task Description"
                row.value = taskObject?.taskDescription
                row.onChange({
                    row in
                    try! self.realm.write({
                        self.GlobalTaskObject?.taskDescription = ""
                        if row.value != nil {
                            self.GlobalTaskObject?.taskDescription = row.value!
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
        
        var message = alertMessages().taskUpdated
        
        try! realm.write({
            
            if projectName != nil{
                GlobalTaskObject?.projectName = projectName
            }
            
            GlobalTaskObject?.creationDate = Date()
            
            if let operationType = GlobalTaskObject?.operationType{
                GlobalTaskObject?.operationType = operationType
            }
            if let id = GlobalTaskObject?.id  {
                if id.isEmpty {
                    GlobalTaskObject?.id = String(format: "%f", Date().timeIntervalSince1970)
                    GlobalTaskObject?.operationType = "POST"
                    message = alertMessages().taskAdded
                }
                else{
                    GlobalTaskObject?.operationType = "PUT"
                }
            }
            else if GlobalTaskObject?.id == nil{
                GlobalTaskObject?.id = String(format: "%f", Date().timeIntervalSince1970)
                GlobalTaskObject?.operationType = "POST"
                message = alertMessages().taskAdded
            }
            else{
                GlobalTaskObject?.operationType = "PUT"
            }
            
            realm.add(GlobalTaskObject!, update: true)
        })
        
        SVProgressHUD.showSuccess(withStatus: message)
        let deadlineTime = DispatchTime.now() + .seconds(constants().messageBlockDuration)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            let _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
}
