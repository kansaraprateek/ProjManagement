//
//  Extenstions.swift
//  PManagement
//
//  Created by Prateek Kansara on 17/03/17.
//  Copyright © 2017 prateek. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController{
    
    /// Setting navigation background color
    ///
    /// - Parameter color: UIColor to be set on navigation bar
    func setNavBackgrounColor(_ color : UIColor)  {
        navigationBar.barTintColor = color
        navigationBar.isTranslucent = false
    }
}
