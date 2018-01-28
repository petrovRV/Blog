//
//  InternalHelper.swift
//  testBlog
//
//  Created by Mac on 25.01.18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import UIKit

class InternalHelper {
    
    //MARK:- Shared Instance Implementation
    static let sharedInstance = InternalHelper()
    
    enum StoryboardType {
        case main
        
        func getStoryboard() -> UIStoryboard {
            switch self {
            case .main:
                return UIStoryboard(name: "Main", bundle: nil)
            }
        }
    }
}
