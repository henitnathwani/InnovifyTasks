//
//  Enums.swift
//  InnovfiyTask
//
//  Created by Henit Nathwani on 24/03/18.
//  Copyright © 2018 Henit Nathwani. All rights reserved.
//

import Foundation
import CoreLocation

enum Speed:Int {
    case none
    case lowSpeed
    case normalSpeed
    case highSpeed
    case overSpeed
    
    func getIntervalInSeconds() -> TimeInterval {
        switch self {
        case .lowSpeed:
            return 5 * 60
        case .normalSpeed:
            return 2 * 60
        case .highSpeed:
            return 1 * 60
        case .overSpeed:
            return 30
        case .none:
            return 5
        }
    }
    
    static func getSpeedType(ForSpeed currentSpeedInKm:CLLocationSpeed) -> Speed {
        if currentSpeedInKm >= 80{
            return .overSpeed
        }else if currentSpeedInKm < 80 && currentSpeedInKm >= 60{
            return .highSpeed
        }else if currentSpeedInKm < 60 && currentSpeedInKm >= 30{
            return .normalSpeed
        }else if currentSpeedInKm < 30 && currentSpeedInKm >= 0{
            return .lowSpeed
        }else{
            return .none
        }
    }
}
