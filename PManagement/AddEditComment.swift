//
//  AddEditComment.swift
//  PManagement
//
//  Created by Prateek Kansara on 17/03/17.
//  Copyright © 2017 prateek. All rights reserved.
//

import Foundation
import Eureka
import RealmSwift
import SVProgressHUD

class AddEditComment : FormViewController{
    
    let realm = try! Realm()
    
    var GlobalCommentObject : Comments?
    var taskObject : Tasks!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItemsAndRevealView()
        
        
        initializeForm(GlobalCommentObject)
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
    
    
    func initializeForm(_ commentObject : Comments?) {
        
        if (commentObject != nil) {
            self.title = "Edit Comment"
        }else{
            self.title = "Add Comment"
            GlobalCommentObject = Comments()
        }
        
        let formSection = Section()
        
        form +++ formSection
            
            <<< TextAreaRow("title") { row in
                row.placeholder = "Type Comment Here*"
                if let comment = commentObject?.comment{
                    row.value = comment
                }
                row.add(rule: RuleRequired(msg: "Comment Can't be empty"))
                row.onChange({
                    row in
                    try! self.realm.write({
                        self.GlobalCommentObject?.comment = ""
                        if row.value != nil {
                            self.GlobalCommentObject?.comment = row.value!
                        }
                    })
                })
            }
            
            
            <<< TextRow("name"){row in
                row.title = "Name*"
                row.value = commentObject?.commentBy
                row.add(rule: RuleRequired(msg: "Name Can't be empty"))
                row.onChange({
                    row in
                    try! self.realm.write({
                        self.GlobalCommentObject?.commentBy = ""
                        if row.value != nil {
                            self.GlobalCommentObject?.commentBy = row.value!
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
        
        var message = alertMessages().commentUpdate
        
        try! realm.write({

            
            GlobalCommentObject?.creationDate = Date()
            
            if let operationType = GlobalCommentObject?.operationType{
                GlobalCommentObject?.operationType = operationType
            }
            if let id = GlobalCommentObject?.id  {
                if id.isEmpty {
                    GlobalCommentObject?.id = String(format: "%f", Date().timeIntervalSince1970)
                    GlobalCommentObject?.operationType = "POST"
                    message = alertMessages().commentAdded
                }
                else{
                    GlobalCommentObject?.operationType = "PUT"
                }
            }
            else if GlobalCommentObject?.id == nil{
                GlobalCommentObject?.id = String(format: "%f", Date().timeIntervalSince1970)
                GlobalCommentObject?.operationType = "POST"
                message = alertMessages().commentAdded
            }
            else{
                GlobalCommentObject?.operationType = "PUT"
            }
            
            if GlobalCommentObject?.operationType == "POST"{
                taskObject.comments.append(GlobalCommentObject!)
            }
            
            realm.add(GlobalCommentObject!, update: true)
        })
        
        SVProgressHUD.showSuccess(withStatus: message)
        let deadlineTime = DispatchTime.now() + .seconds(constants().messageBlockDuration)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            let _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
}
