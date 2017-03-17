//
//  CellData.swift
//  PManagement
//
//  Created by Prateek Kansara on 17/03/17.
//  Copyright © 2017 prateek. All rights reserved.
//

import Foundation
import UIKit

class cellData: NSObject {
    
    func getTaskCellData(taskObject : Tasks) -> NSAttributedString {
        
        let titleString : NSMutableAttributedString = NSMutableAttributedString.init(string: taskObject.title!, attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName:UIFont.init(name: PMFonts().AvenirNextMedium, size: 16.0)!])
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        paragraphStyle.lineHeightMultiple = 0.8
        let statusString = NSAttributedString.init(string: String(format: "\n\n%@", taskObject.status!), attributes: [NSParagraphStyleAttributeName: paragraphStyle, NSForegroundColorAttributeName:UIColor.black, NSFontAttributeName:UIFont.init(name: PMFonts().AvenirNextMedium, size: 14.0)!])
        
        titleString.append(statusString)
        return titleString
    }
    
    
    
}
