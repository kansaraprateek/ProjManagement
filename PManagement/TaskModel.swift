//
//  TaskModel.swift
//  PManagement
//
//  Created by Prateek Kansara on 17/03/17.
//  Copyright © 2017 prateek. All rights reserved.
//

import Foundation

@objc protocol TaskModelDelegate : NSObjectProtocol{
    func reloadTaskData()
}

private let sharedTaskInstance = TaskModel()
class TaskModel: NSObject {
    
    fileprivate let TaskRealm = try! Realm()
    
    var TaskModelList : Results<Tasks>? {
        return TaskRealm.objects(Tasks.self)
    }
    
    var TaskModelDelegateObject : TaskModelDelegate?
    
    fileprivate var TaskWebServiceObject : WebService = WebService()
    
    class var sharedInstance: TaskModel{
        return sharedTaskInstance
    }
    
    fileprivate func TaskAddUpdateURL(_ operation : String) -> String{
        
        if operation == "PUT" {
            return PMURLs().taskUpdateURL
        }
        return PMURLs().taskAddURL
    }
    
    func GlobalFetchTask() {
        
        if UtilityMethods().isInternetAvailable() {
            
            TaskWebServiceObject.sendRequest(PMURLs().taskGETURL, parameters: nil, requestType: .get, success: {
                (response : HTTPURLResponse?, responseObject : Any) in
                
                if let TaskData = responseObject as? NSArray{
                    self.GlobalTaskUpdateInDatabase(TaskData, completed: {
                        (success : Bool) in
                        self.reloadCurrentView()
                    })
                }
                    
                else{
                    
                }
                
            }, failed: {
                (response : HTTPURLResponse?, responseObject : Any?) in
                
            }, encoded: false)
        }
        else
        {
            // Internet not available.
            if TaskModelList?.count == 0{
                SVProgressHUD.showError(withStatus: alertMessages().NoInternet)
            }
        }
    }
    
    func AddUpdateTask() {
        
        let results = TaskRealm.objects(Tasks.self).filter("operationType = 'PUT' OR operationType = 'POST'")
        
        if let object = results.last {
            let param = createParamDataFromObject(object)
            
            TaskWebServiceObject.sendRequest(TaskAddUpdateURL(object.operationType!), parameters: param, requestType: UtilityMethods().requestType(object.operationType!), success: {
                (response : HTTPURLResponse?, responseObject : Any) in
                
                let lRealm = try! Realm()
                
                try! lRealm.write({
                    
                    object.operationType = ""
                    
                    if let respDict = responseObject as? NSDictionary{
                        
                        if let id = respDict.object(forKey: "id") {
                            let TaskObject = self.copyTaskObjectToOther(object)
                            TaskObject.id = id as? String
                            lRealm.add(TaskObject, update: true)
                            lRealm.delete(object)
                        }
                        else{
                            lRealm.add(object, update: true)
                        }
                    }
                })
                
                self.reloadCurrentView()
                self.AddUpdateTask()
                
            }, failed: {
                (response : HTTPURLResponse?, responseObject : Any?) in
                
                if response?.statusCode == 404{
                    self.removeRealmObjectForKey(object.id!)
                    self.reloadCurrentView()
                }
            }, encoded: false)
        }
        
    }
    
    func copyTaskObjectToOther(_ TaskObj : Tasks) -> Tasks {
        
        let TaskObject = Tasks()
        
        //        TaskObject.id = TaskObj.id
        TaskObject.title = TaskObj.title
        TaskObject.taskDescription = TaskObj.taskDescription
        TaskObject.creationDate = TaskObj.creationDate
        TaskObject.operationType = TaskObj.operationType
        
        return TaskObject
    }
    
    fileprivate func createParamDataFromObject(_ TaskObject : Tasks) -> NSDictionary?{
        
        let paramDict = NSMutableDictionary()
        
        paramDict.setObject(TaskObject.id!, forKey: "id" as NSCopying)
        paramDict.setObject(TaskObject.title ?? "", forKey: "title" as NSCopying)
        paramDict.setObject(TaskObject.taskDescription ?? "", forKey: "taskDescription" as NSCopying)
        
        return paramDict
    }
    
    
    fileprivate var globalTaskIndex : NSMutableArray? = nil
    
    fileprivate func GlobalTaskUpdateInDatabase(_ TaskData : NSArray, completed : @escaping (Bool) -> Void) {
        
        if globalTaskIndex == nil {
            globalTaskIndex = NSMutableArray()
        }
        
        let queue : DispatchQueue  = DispatchQueue.global(qos: .default)
        
        queue.async(execute: {
            
            let lRealm = try! Realm()
            
            try! lRealm.write({
                
                for i in 0..<TaskData.count {
                    
                    if let TaskDict = TaskData.object(at: i) as? NSDictionary {
                        let TaskObject = self.CreateTaskObjectFromDict(TaskDict)
                        lRealm.add(TaskObject, update: true)
                    }
                }
            })
            DispatchQueue.main.async(execute: {
                
                if let Tasks = self.TaskModelList {
                    for object in Tasks{
                        if self.globalTaskIndex?.contains(object.id!) == false {
                            try! self.TaskRealm.write{
                                self.TaskRealm.delete(object)
                            }
                        }
                    }
                }
                completed(true)
            })
        })
    }
    
    func CreateTaskObjectFromDict(_ TaskDict : NSDictionary) -> Tasks{
        
        let TaskObject : Tasks = Tasks()
        
        TaskObject.id = (TaskDict.object(forKey: "id") as? String)!
        globalTaskIndex?.add(TaskObject.id!)
        
        if let name = TaskDict.object(forKey: "title") as? String {
            TaskObject.title = name.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        
        if let detail = TaskDict.object(forKey: "taskDescription") as? String {
            TaskObject.taskDescription = detail.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        
        
        // Uncomment when task model completes
        //        let lRealm = try! Realm()
        //        if let tasks = TaskDict.object(forKey: "tasks") as? NSArray {
        //        for task in tasks{
        //            if let taskID = task(forKey: "id"){
        //                if let taskObject = lRealm.object(ofType: Tasks.self, forPrimaryKey: taskID as AnyObject){
        //                    TaskObject.tasks = taskObject
        //                }
        //                else{
        //                    TaskObject.tasks = TaskModel().CreateTaskObjectFromDict(task)
        //                }
        //            }
        //        }
        //        }
        
        
        if let createdDate = TaskDict.object(forKey: "creationDate") as? Date {
            TaskObject.creationDate = createdDate
        }
        
        return TaskObject
    }
    
    func deleteTaskWithId(_ TaskID : String) {
        
        if UtilityMethods().isInternetAvailable() {
            
            let deleteURL = String(format: "%@/%@", PMURLs().TaskDeleteURL, TaskID)
            
            TaskWebServiceObject.sendRequest(deleteURL, parameters: nil, requestType: .delete, success: {
                (response : HTTPURLResponse?, responseObject : Any) in
                
                self.removeRealmObjectForKey(TaskID)
                self.reloadCurrentView()
                
                SVProgressHUD.showSuccess(withStatus: alertMessages().TaskDeleteMessage)
                
            }, failed: {
                (response : HTTPURLResponse?, responseObject : Any?) in
                
                if response?.statusCode == 404 {
                    self.removeRealmObjectForKey(TaskID)
                    self.reloadCurrentView()
                }
                
            }, encoded: false)
            
        }
        else
        {
            // Internet not available.
            SVProgressHUD.showError(withStatus: alertMessages().NoInternet)
        }
    }
    
    func removeRealmObjectForKey(_ id : String) {
        
        if let object = TaskRealm.object(ofType: Tasks.self, forPrimaryKey: id as AnyObject){
            try! TaskRealm.write({
                TaskRealm.delete(object)
            })
        }
    }
    
    func reloadCurrentView() {
        if ((self.TaskModelDelegateObject?.responds(to: #selector(TaskModelDelegate.reloadTaskData))) != nil)
        {
            self.TaskModelDelegateObject?.reloadTaskData()
        }
    }
}
