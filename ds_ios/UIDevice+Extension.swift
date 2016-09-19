//
//  UIDevice+Extension.swift
//  Digipost
//
//  Created by Håkon Bogen on 05/03/15.
//  Copyright (c) 2015 Posten. All rights reserved.
//

import UIKit

extension UIDevice {
    
    func isIpad() -> Bool {
        if userInterfaceIdiom == .pad {
            return true
        }
        return false
    }
}
