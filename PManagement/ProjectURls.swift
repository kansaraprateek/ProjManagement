//
//  ProjectURls.swift
//  PManagement
//
//  Created by Prateek Kansara on 17/03/17.
//  Copyright © 2017 prateek. All rights reserved.
//

import Foundation

/// Class to handle all URL used within the application
class PMURLs : NSObject{
    
    let baseURL = "Project Base URL"
    
    var projectsGETURL : String{
        return String(format: "%@/<>", baseURL)
    }
    
    var projectAddURL : String{
        return String(format: "%@/<>", baseURL)
    }
    
    var projectUpdateURL : String{
        return String(format: "%@/<>", baseURL)
    }
    
    var taskGETURL : String{
        return String(format: "%@/<>", baseURL)
    }
    
    var taskAddURL : String{
        return String(format: "%@/<>", baseURL)
    }
    
    var taskUpdateURL : String{
        return String(format: "%@/<>", baseURL)
    }
}
