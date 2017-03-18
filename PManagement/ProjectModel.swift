//
//  ProjectModel.swift
//  PManagement
//
//  Created by Prateek Kansara on 17/03/17.
//  Copyright © 2017 prateek. All rights reserved.
//

import Foundation

@objc protocol ProjectModelDelegate : NSObjectProtocol{
    func reloadProjectData()
}

private let sharedProjectInstance = ProjectModel()
class ProjectModel: NSObject {
    
    fileprivate let ProjectRealm = try! Realm()
    
    var ProjectModelList : Results<Projects>? {
        return ProjectRealm.objects(Projects.self)
    }
    
    var ProjectModelDelegateObject : ProjectModelDelegate?
    
    fileprivate var ProjectWebServiceObject : WebService = WebService()
    
    class var sharedInstance: ProjectModel{
        return sharedProjectInstance
    }
    
    fileprivate func ProjectAddUpdateURL(_ operation : String) -> String{
        
        if operation == "PUT" {
            return PMURLs().projectUpdateURL
        }
        return PMURLs().projectAddURL
    }
    
    func GlobalFetchProject() {
        
            if UtilityMethods().isInternetAvailable() {
                
                ProjectWebServiceObject.sendRequest(PMURLs().projectsGETURL, parameters: nil, requestType: .get, success: {
                    (response : HTTPURLResponse?, responseObject : Any) in
                    
                    if let ProjectData = responseObject as? NSArray{
                        self.GlobalProjectUpdateInDatabase(ProjectData, completed: {
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
                if ProjectModelList?.count == 0{
                    SVProgressHUD.showError(withStatus: alertMessages().NoInternet)
                }
            }
    }
    
    func AddUpdateProject() {
        
        let results = ProjectRealm.objects(Projects.self).filter("operationType = 'PUT' OR operationType = 'POST'")
        
        if let object = results.last {
            let param = createParamDataFromObject(object)
            
            ProjectWebServiceObject.sendRequest(ProjectAddUpdateURL(object.operationType!), parameters: param, requestType: UtilityMethods().requestType(object.operationType!), success: {
                (response : HTTPURLResponse?, responseObject : Any) in
                
                let lRealm = try! Realm()
                
                try! lRealm.write({
                    
                    object.operationType = ""
                    
                    if let respDict = responseObject as? NSDictionary{
                        
                        if let id = respDict.object(forKey: "id") {
                            let ProjectObject = self.copyProjectObjectToOther(object)
                            ProjectObject.id = id as? String
                            lRealm.add(ProjectObject, update: true)
                            lRealm.delete(object)
                        }
                        else{
                            lRealm.add(object, update: true)
                        }
                    }
                })
                
                self.reloadCurrentView()
                self.AddUpdateProject()
                
            }, failed: {
                (response : HTTPURLResponse?, responseObject : Any?) in
                
                if response?.statusCode == 404{
                    self.removeRealmObjectForKey(object.id!)
                    self.reloadCurrentView()
                }
            }, encoded: false)
        }
        
    }
    
    func copyProjectObjectToOther(_ ProjectObj : Projects) -> Projects {
        
        let ProjectObject = Projects()
        
        //        ProjectObject.id = ProjectObj.id
        ProjectObject.name = ProjectObj.name
        ProjectObject.detail = ProjectObj.detail
        ProjectObject.creationDate = ProjectObj.creationDate
        ProjectObject.operationType = ProjectObj.operationType

        return ProjectObject
    }
    
    fileprivate func createParamDataFromObject(_ ProjectObject : Projects) -> NSDictionary?{
        
        let paramDict = NSMutableDictionary()
        
        paramDict.setObject(ProjectObject.id!, forKey: "id" as NSCopying)
        paramDict.setObject(ProjectObject.name ?? "", forKey: "name" as NSCopying)
        paramDict.setObject(ProjectObject.detail ?? "", forKey: "detail" as NSCopying)
        
        return paramDict
    }
    
    
    fileprivate var globalProjectIndex : NSMutableArray? = nil
    
    fileprivate func GlobalProjectUpdateInDatabase(_ ProjectData : NSArray, completed : @escaping (Bool) -> Void) {
        
        if globalProjectIndex == nil {
            globalProjectIndex = NSMutableArray()
        }
        
        let queue : DispatchQueue  = DispatchQueue.global(qos: .default)
        
        queue.async(execute: {
            
            let lRealm = try! Realm()
            
            try! lRealm.write({

                for i in 0..<ProjectData.count {
                    
                    if let ProjectDict = ProjectData.object(at: i) as? NSDictionary {
                        let ProjectObject = self.CreateProjectObjectFromDict(ProjectDict)
                        lRealm.add(ProjectObject, update: true)
                    }
                }
            })
            DispatchQueue.main.async(execute: {
                
                if let Projects = self.ProjectModelList {
                    for object in Projects{
                        if self.globalProjectIndex?.contains(object.id!) == false {
                            try! self.ProjectRealm.write{
                                self.ProjectRealm.delete(object)
                            }
                        }
                    }
                }
                completed(true)
            })
        })
    }
    
    func CreateProjectObjectFromDict(_ ProjectDict : NSDictionary) -> Projects{
        
        let ProjectObject : Projects = Projects()
        
        ProjectObject.id = (ProjectDict.object(forKey: "id") as? String)!
        globalProjectIndex?.add(ProjectObject.id!)
        
        if let name = ProjectDict.object(forKey: "name") as? String {
            ProjectObject.name = name.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        
        if let detail = ProjectDict.object(forKey: "detail") as? String {
            ProjectObject.detail = detail.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        
        
        // Uncomment when task model completes
//        let lRealm = try! Realm()
//        if let tasks = ProjectDict.object(forKey: "tasks") as? NSArray {
//        for task in tasks{
//            if let taskID = task(forKey: "id"){
//                if let taskObject = lRealm.object(ofType: Tasks.self, forPrimaryKey: taskID as AnyObject){
//                    ProjectObject.tasks = taskObject
//                }
//                else{
//                    ProjectObject.tasks = TaskModel().CreateTaskObjectFromDict(task)
//                }
//            }
//        }
//        }

        
        if let createdDate = ProjectDict.object(forKey: "creationDate") as? Date {
            ProjectObject.creationDate = createdDate
        }

        return ProjectObject
    }
    
    func deleteProjectWithId(_ ProjectID : String) {

            if UtilityMethods().isInternetAvailable() {
                
                let deleteURL = String(format: "%@/%@", PMURLs().projectDeleteURL, ProjectID)
                
                ProjectWebServiceObject.sendRequest(deleteURL, parameters: nil, requestType: .delete, success: {
                    (response : HTTPURLResponse?, responseObject : Any) in
                    
                    self.removeRealmObjectForKey(ProjectID)
                    self.reloadCurrentView()
                    
                    SVProgressHUD.showSuccess(withStatus: alertMessages().ProjectDeleteMessage)
                    
                }, failed: {
                    (response : HTTPURLResponse?, responseObject : Any?) in
                    
                    if response?.statusCode == 404 {
                        self.removeRealmObjectForKey(ProjectID)
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
        
        if let object = ProjectRealm.object(ofType: Projects.self, forPrimaryKey: id as AnyObject){
            try! ProjectRealm.write({
                ProjectRealm.delete(object)
            })
        }
    }
    
    func reloadCurrentView() {
        if ((self.ProjectModelDelegateObject?.responds(to: #selector(ProjectModelDelegate.reloadProjectData))) != nil)
        {
            self.ProjectModelDelegateObject?.reloadProjectData()
        }
    }
}
