//
//  UtilityMethods.swift
//  PManagement
//
//  Created by Prateek Kansara on 17/03/17.
//  Copyright © 2017 prateek. All rights reserved.
//

import Foundation
import ReachabilitySwift

class UtilityMethods: NSObject {
    
    
    //MARK:- Internet Reachability
    func isInternetAvailable() -> Bool {
        
        let reachability = Reachability.init()!
        
        return reachability.isReachable
    }
    func appBackground() -> CAGradientLayer{
        
        let gradient = CAGradientLayer()
        
        gradient.frame = UIScreen.main.bounds
        gradient.colors = PMColors().AppBkg
        
        return gradient
    }
    
    /// Adding shadows to current views
    ///
    /// - Parameters:
    ///   - view: UIView object for adding shadow effect to
    ///   - cornerRadius: corner radius to be set for uiview
    func addShadowToViews(view: UIView, cornerRadius: CGFloat){
        
        view.layer.cornerRadius = cornerRadius
        view.layer.shadowRadius = cornerRadius
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowOpacity = 0.3
        
        
    }
    
    /// Adding rounded corners to button
    ///
    /// - Parameters:
    ///   - button: Button type object to add rounded corner
    ///   - cornerRadius: CGFloat type value to set corner radius.
    func addRoundedCornerTo(button: UIButton, cornerRadius: CGFloat){
        button.layer.cornerRadius = cornerRadius
        button.layer.shadowRadius = cornerRadius
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 0.3
        button.layer.masksToBounds = false
        
    }
    
    /**
     Method to get the current request type as HTTPMethod value
     
     - parameter type: String type to convert to HTTPMethod
     
     - returns: Return type as HTTPMethod
     */
    func requestType(_ type : String) -> HTTPMethod{
        if type == "PUT" {
            return .put
        }
        return .post
    }
    
    /**
     Method to check weather the device is iPhone or not
     
     - returns: true or false depending upon the device type
     */
    func IsIphone() -> Bool {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: return true
            
        case .pad:
            return false
            
        case .unspecified: break
        // Uh, oh! What could it be?
        default :
            break
        }
        return false
    }
}
