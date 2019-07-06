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
    private var height = 50
    private var width = 50
    private var trafficLight0:TrafficLight // light controlling direction = 0 (right to left)
    //private var trafficLight1:TrafficLight // light controlling direction = 1 (left to right)
    private var trafficLight2:TrafficLight // light controlling direction = 2 (up to down)
    //private var trafficLight3:TrafficLight // light controlling direction = 3 (down to up)
    private var allFourTrafficLights:[TrafficLight] = [] // all four lights in one array, could have future use
    
    
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
        trafficLight0 = TrafficLight(x: xCenter - width/2 - 15, y: yCenter + height/2 + 15, location: horizontalStreet)
        trafficLight2 = TrafficLight(x: xCenter + width/2 + 15, y: yCenter - height/2 - 15, location: verticalStreet)
        allFourTrafficLights.append(trafficLight0)
        allFourTrafficLights.append(trafficLight2)
    }
    
    func isCarAtIntersection(_ car: Car) -> Bool {
        if (car.getStreet() === verticalStreet) {
            return (car.getYPos() - yCenter < 2 && car.getYPos() - yCenter > -2)
        } else if (car.getStreet() === horizontalStreet) {
            return (car.getXPos() - xCenter < 2 && car.getXPos() - xCenter > -2)
        } else {
            return false
        }
    }
    
    func getVerticalStreet() -> Street {
        return verticalStreet
    }
    
    func getHorizontalStreet() -> Street {
        return horizontalStreet
    }
    
    func getPosition() -> [Int] {
        return [xCenter,yCenter]
    }
    
    func getAllLights() -> [TrafficLight] {
        return allFourTrafficLights
    }
}
