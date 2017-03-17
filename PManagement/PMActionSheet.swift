//
//  PMActionSheet.swift
//  PManagement
//
//  Created by Prateek Kansara on 17/03/17.
//  Copyright © 2017 prateek. All rights reserved.
//

import Foundation
import Foundation
import UIKit

/// Class to add action sheet using block methods
class PMActionSheet: UIAlertController {
    
    var onSelection :  ((_ selectedValue : String, _ selectedIndex : Int) -> Void)?
    var onDismissingActionSheet : ((_ buttonIndex : Int) -> Void)?
    
    
    var dataArray : NSArray!
    
    
    /// Adding action sheet to current view controller
    ///
    /// - Parameters:
    ///   - lTitle: Title for sheet
    ///   - data: data to show within the sheet
    ///   - fromRect: to show action sheet from a button(Only for iPAd)
    ///   - inView: adding action sheet within view
    ///   - selection: Selection block to handle currently selected value and index
    ///   - dismiss: dismiss block if no value is selected
    func showActionSheet(_ lTitle : String, data : NSArray, fromRect : CGRect?, inView : UIView, selection : @escaping ((_ selectedValue : String, _ selectedIndex : Int) -> Void), dismiss : @escaping (_ buttonIndex : Int) -> Void) {
        
        title = lTitle
        onSelection = selection
        onDismissingActionSheet = dismiss
        
        
        for i in 0..<data.count {
            //            addButton(withTitle: buttonName as? String)
            let alertAction = UIAlertAction.init(title: data[i] as? String, style: .default, handler: {
                action in
                self.onSelection!(action.title!, i)
            })
            addAction(alertAction)
        }
        
        dataArray = data
        
        if UtilityMethods().IsIphone(){
            let alertAction = UIAlertAction.init(title: "Cancel", style: .default, handler: {
                action in
                self.onDismissingActionSheet!(-1)
            })
            addAction(alertAction)
        }
        else{
            
            popoverPresentationController?.sourceView = inView
            popoverPresentationController?.sourceRect = fromRect!
        }
        
        DispatchQueue.main.async(execute: {
            
            inView.parentViewController?.present(self, animated: true, completion: nil)
            //                self.show(in: inView)
        })
        
    }
    
    /// showing action sheet from a navigation bar item
    ///
    /// - Parameters:
    ///   - lTitle: Title for sheet
    ///   - data: data to show within the sheet
    ///   - fromBarItem: BarButtonItem from which the action sheet is to be shown
    ///   - inView: showing in View
    ///   - selection: Selection block to handle currently selected value and index
    ///   - dismiss: dismiss block if no value is selected
    func showActionSheetFromNavBar(_ lTitle : String, data : NSArray, fromBarItem : UIBarButtonItem, inView : UIView, selection : @escaping ((_ selectedValue : String, _ selectedIndex : Int) -> Void), dismiss : @escaping (_ buttonIndex : Int) -> Void) {
        
        
        title = lTitle
        onSelection = selection
        onDismissingActionSheet = dismiss
        
        for i in 0..<data.count {
            //            addButton(withTitle: buttonName as? String)
            let alertAction = UIAlertAction.init(title: data[i] as? String, style: .default, handler: {
                action in
                self.onSelection!(action.title!, i)
            })
            addAction(alertAction)
        }
        
        dataArray = data
        if UtilityMethods().IsIphone(){
            let alertAction = UIAlertAction.init(title: "Cancel", style: .default, handler: {
                action in
                self.onDismissingActionSheet!(-1)
            })
            addAction(alertAction)
        }
        else{
            
            popoverPresentationController?.sourceView = inView
            popoverPresentationController?.barButtonItem = fromBarItem
            //            popoverPresentationController?.sourceRect = fromRect!
            
        }
        
        DispatchQueue.main.async(execute: {
            
            inView.parentViewController?.present(self, animated: true, completion: nil)
            //                self.show(in: inView)
        })
    }
}


// MARK: - UIView extension for parent view controller
extension UIView {
    
    /// Method to get UIView's parent view controller
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
