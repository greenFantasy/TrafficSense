//
//  Intersection.swift
//  trafficSense
//
//  Created by Rajat Mittal on 6/29/19.
//  Copyright © 2019 Yousef Ahmed. All rights reserved.
//

import Foundation
import UIKit

class Intersection {
    
    private var verticalStreet:Street
    private var horizontalStreet:Street
    private var xCenter:Int
    private var yCenter:Int
    
    init (street1: Street, street2: Street) {
        if (!(street1.getDirection() <= 1 && street2.getDirection() <= 1) && !(street1.getDirection() >= 2 && street2.getDirection() >= 2)) {
            if (street1.getDirection() > street2.getDirection()) {
                verticalStreet = street1
                horizontalStreet = street2
            } else {
                verticalStreet = street2
                horizontalStreet = street1
            }
            xCenter = verticalStreet.getPosition()
            yCenter = horizontalStreet.getPosition()
        } else {
            xCenter = -10000000
            yCenter = -10000000
            verticalStreet = Street(heightWidth: -10000, direction: -2)
            horizontalStreet = Street(heightWidth: -10000, direction: -2)
        }
    }
    
    func isCarAtIntersection(_ car: Car) -> Bool {
        if (car.getStreet() === verticalStreet) {
            return (car.getYPos() - yCenter < 3 && car.getYPos() - yCenter > -3)
        } else if (car.getStreet() === horizontalStreet) {
            return (car.getXPos() - xCenter < 3 && car.getXPos() - xCenter > -3)
        } else {
            return false
        }
    }
    
//    func isCarAtIntersection(_ car: Car) -> Bool {
//        if (car.getStreet() === verticalStreet) {
//            return (car.getYPos() - yCenter == 0)
//        } else if (car.getStreet() === horizontalStreet) {
//            return (car.getXPos() - xCenter == 0)
//        } else {
//            return false
//        }
//    }
    
    func getVerticalStreet() -> Street {
        return verticalStreet
    }
    
    func getHorizontalStreet() -> Street {
        return horizontalStreet
    }
    
    func getPosition() -> [Int] {
        return [xCenter,yCenter]
    }
}
