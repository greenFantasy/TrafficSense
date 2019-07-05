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
    
    // an intersection is created every time two TwoWay intersect
    // each intersection automatically creates 4 traffic lights, which are added to the screen and completely functional
    // each of the 4 traffic lights control one of the 4 directions at the intersection
    // turning while watching cars on other streets has not been implemented, so cars on different streets are completely unaware of each other
    
    private var xCenter:Int
    private var yCenter:Int
    private var horizontalTwoWay:TwoWayHorizontal
    private var verticalTwoWay:TwoWayVertical
    private var width = 60
    private var height = 60
    private var lightLeft:TrafficLight
    private var lightRight:TrafficLight
    private var lightDown:TrafficLight
    private var lightUp:TrafficLight
    private var allFourLights:[TrafficLight] = []
    
    init (horizontal: TwoWayHorizontal, vertical: TwoWayVertical) {
        xCenter = vertical.getMidline()
        yCenter = horizontal.getMidline()
        horizontalTwoWay = horizontal
        verticalTwoWay = vertical
        lightLeft = TrafficLight(x: xCenter - width/2 - 15, y: yCenter + height/2 + 15, location: horizontalTwoWay.getLeftStreet())
        lightRight = TrafficLight(x: xCenter + width/2 + 15, y: yCenter - height/2 - 15, location: horizontalTwoWay.getRightStreet())
        lightDown = TrafficLight(x: xCenter - width/2 - 15, y: yCenter - height/2 - 15, location: verticalTwoWay.getDownStreet())
        lightUp = TrafficLight(x: xCenter + width/2 + 15, y: yCenter + height/2 + 15, location: verticalTwoWay.getUpStreet())
        allFourLights.append(lightLeft)
        allFourLights.append(lightRight)
        allFourLights.append(lightDown)
        allFourLights.append(lightUp)
    }
    
    func getAllLights() -> [TrafficLight] {
        return allFourLights
    }
    
    func getHorizontalTwoWay() -> TwoWayHorizontal {
        return horizontalTwoWay
    }
    
    func getVerticalTwoWay() -> TwoWayVertical {
        return verticalTwoWay
    }
    
    func getWidth() -> Int {
        return width
    }
    
    func getHeight() -> Int {
        return height
    }
    
    func getPosition() -> [Int] {
        return [xCenter, yCenter]
    }
    
    func isCarAtIntersection(_ car: Car) -> Bool {
        
        // this identifies if a car is at the intersection, first by checking if the car is at a street on the intersection before continuing (that might be unneccesary later but its good practice for now)
        
        // if the car within 3 units of the center of the intersection, the car given the option to turn after this method is called
        
        switch car.getDirection() {
        case 0:
            if (car.getStreet() as! LeftStreet === horizontalTwoWay.getLeftStreet()) {
                return (car.getXPos() - xCenter < 3 && car.getXPos() - xCenter > -3)
            }
        case 1:
            if car.getStreet() as! RightStreet === horizontalTwoWay.getRightStreet() {
                return (car.getXPos() - xCenter < 3 && car.getXPos() - xCenter > -3)
            }
        case 2:
            if car.getStreet() as! DownStreet === verticalTwoWay.getDownStreet() {
                return (car.getYPos() - yCenter < 3 && car.getYPos() - yCenter > -3)
            }
        case 3:
            if car.getStreet() as! UpStreet === verticalTwoWay.getUpStreet() {
                return (car.getYPos() - yCenter < 3 && car.getYPos() - yCenter > -3)
            }
        default:
            return false // does nothing on purpose
        }
        return false
    }
    
}
