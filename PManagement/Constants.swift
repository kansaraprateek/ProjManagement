//
//  Constants.swift
//  PManagement
//
//  Created by Prateek Kansara on 17/03/17.
//  Copyright © 2017 prateek. All rights reserved.
//

import Foundation
import UIKit

class constants: NSObject{
    
    let DEBUG = true
    let navigationTitleFontSize : CGFloat = 18.0

    let navigationTitleFont = UIFont.init(name: PMFonts().AvenirNextDemiBold, size: 18.0)
    
    let messageBlockDuration = 2
    
    let requiredFieldsMessage = "Fields marked with asterisk(*) are required"
    
    let taskStatus = ["NEW", "In Progress", "In Review", "Completed"]
}

///  Storybaord identifier for classes
class storyBoardID: NSObject{
    let projectCell = "projectCell"
    let taskCell = "taskCell"
    
    let addEditTasks = "AddEditTask"
}

class PMSegues : NSObject{
    let projectDetailSegue = "projectTask"
    let taskDetailSegue = "Task Detail"
}

/// App based Colors
class PMColors : NSObject{
    
    //    let navigationColor = UIColor.init(red: 10/255.0, green: 86/255.0, blue: 138/255.0, alpha: 1.0)
    let navigationColor = UIColor.init(red: 50/255.0, green: 20/255.0, blue: 56/255.0, alpha: 1.0)
    
    let appBackgroundColors = [
        UIColor.init(red: 10/255.0, green: 86/255.0, blue: 138/255.0, alpha: 1.0).cgColor,
        UIColor.init(red: 0/255.0, green: 120/255.0, blue: 135/255.0, alpha: 1.0).cgColor,
        UIColor.init(red: 0/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1.0).cgColor,
        UIColor.init(red: 0/255.0, green: 155/255.0, blue: 130/255.0, alpha: 1.0).cgColor
    ]
    
    let AppBkg = [
        UIColor.init(red: 50/255.0, green: 20/255.0, blue: 56/255.0, alpha: 1.0).cgColor,
        UIColor.init(red: 79/255.0, green: 29/255.0, blue: 69/255.0, alpha: 1.0).cgColor,
        UIColor.init(red: 127/255.0, green: 38/255.0, blue: 83/255.0, alpha: 1.0).cgColor,
        UIColor.init(red: 143/255.0, green: 56/255.0, blue: 95/255.0, alpha: 1.0).cgColor
    ]
    
    
}

// App Based font
class PMFonts: NSObject {
    //---Avenir Next Condensed---
    let AvenirNextCondensedBoldItalic = "AvenirNextCondensed-BoldItalic"
    let AvenirNextCondensedHeavy = "AvenirNextCondensed-Heavy"
    let AvenirNextCondensedMedium = "AvenirNextCondensed-Medium"
    let AvenirNextCondensedRegular = "AvenirNextCondensed-Regular"
    let AvenirNextCondensedHeavyItalic = "AvenirNextCondensed-HeavyItalic"
    let AvenirNextCondensedMediumItalic = "AvenirNextCondensed-MediumItalic"
    let AvenirNextCondensedItalic = "AvenirNextCondensed-Italic"
    let AvenirNextCondensedUltraLightItalic = "AvenirNextCondensed-UltraLightItalic"
    let AvenirNextCondensedUltraLight = "AvenirNextCondensed-UltraLight"
    let AvenirNextCondensedDemiBold = "AvenirNextCondensed-DemiBold"
    let AvenirNextCondensedBold = "AvenirNextCondensed-Bold"
    let AvenirNextCondensedDemiBoldItalic = "AvenirNextCondensed-DemiBoldItalic"
    
    //---Avenir Next---
    let AvenirNextUltraLight = "AvenirNext-UltraLight"
    let AvenirNextUltraLightItalic = "AvenirNext-UltraLightItalic"
    let AvenirNextBold = "AvenirNext-Bold"
    let AvenirNextBoldItalic = "AvenirNext-BoldItalic"
    let AvenirNextDemiBold = "AvenirNext-DemiBold"
    let AvenirNextDemiBoldItalic = "AvenirNext-DemiBoldItalic"
    let AvenirNextMedium = "AvenirNext-Medium"
    let AvenirNextHeavyItalic = "AvenirNext-HeavyItalic"
    let AvenirNextHeavy = "AvenirNext-Heavy"
    let AvenirNextItalic = "AvenirNext-Italic"
    let AvenirNextRegular = "AvenirNext-Regular"
    let AvenirNextMediumItalic = "AvenirNext-MediumItalic"
    
    //---Avenir---
    let AvenirMedium = "Avenir-Medium"
    let AvenirHeavyOblique = "Avenir-HeavyOblique"
    let AvenirBook = "Avenir-Book"
    let AvenirLight = "Avenir-Light"
    let AvenirRoman = "Avenir-Roman"
    let AvenirBookOblique = "Avenir-BookOblique"
    let AvenirBlack = "Avenir-Black"
    let AvenirMediumOblique = "Avenir-MediumOblique"
    let AvenirBlackOblique = "Avenir-BlackOblique"
    let AvenirHeavy = "Avenir-Heavy"
    let AvenirLightOblique = "Avenir-LightOblique"
    let AvenirOblique = "Avenir-Oblique"
}

// App Alert and Notificaiton Message
class alertMessages: NSObject {
    
    let NoInternet = "Please check your network!"
    
    let projectAdded = "Project Created!"
    let projectUpdated = "Project Updated!"
    
    let taskAdded = "Task Created!"
    let taskUpdated = "Task Updated!"
    
    let commentAdded = "Comment Added!"
    let commentUpdate = "Comment Updated!"

}
