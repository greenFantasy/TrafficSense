//
//  Street.swift
//  trafficSense
//
//  Created by Rajat Mittal on 6/20/19.
//  Copyright © 2019 Yousef Ahmed. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class Street {
    
    private var direction = 0 // left is 0, right is 1, down is 2, up is 3
    private var carArray:[Car] = []
    private var lightArray:[TrafficLight] = []
    private let position:Int
    private var lanes = 1
    
    init(heightWidth: Int, direction: Int) {
        position = heightWidth
        self.direction = direction
    }
    
    func getDirection() -> Int {
        return direction
    }
    
    func addCar(car: Car) {
        carArray.append(car)
    }
    
    func addLight(trafficLight: TrafficLight){
        var added = false
        if (lightArray.count > 0) {
                for i in 0...lightArray.count-1 {
                    switch direction {
                    case 0:
                        if (!added && trafficLight.getXPos() > lightArray[i].getXPos()) {
                            lightArray.insert(trafficLight,at:i)
                            added = true
                        }
                    case 1:
                        if (!added && trafficLight.getXPos() < lightArray[i].getXPos()) {
                            lightArray.insert(trafficLight,at:i)
                            added = true
                        }
                    case 2:
                        if (!added && trafficLight.getYPos() > lightArray[i].getYPos()) {
                            lightArray.insert(trafficLight,at:i)
                            added = true
                        }
                    case 3:
                        if (!added && trafficLight.getYPos() < lightArray[i].getYPos()) {
                            lightArray.insert(trafficLight,at:i)
                            added = true
                        }
                    default:
                        if (!added && trafficLight.getXPos() > lightArray[i].getXPos()) {
                            lightArray.insert(trafficLight,at:i)
                            added = true
                        }
                    }
                }
                if (!added) {
                    lightArray.append(trafficLight)
                }
        } else {
            lightArray.append(trafficLight)
        }
    }
    
    func lightFinder(car: Car) -> TrafficLight {
        for trafficLight in lightArray {
            switch direction {
            case 0:
                if (car.getXPos() > trafficLight.getXPos()) {
                    return trafficLight
                }
            case 1:
                if (car.getXPos() < trafficLight.getXPos()) {
                    return trafficLight
                }
            case 2:
                if (car.getYPos() > trafficLight.getYPos()) {
                    return trafficLight
                }
            case 3:
                if (car.getYPos() < trafficLight.getYPos()) {
                    return trafficLight
                }
            default:
                if (car.getXPos() > trafficLight.getXPos()) {
                    return trafficLight
                }
            }
        }
        return TrafficLight(fakeLight: 0)
    }
    
    func getCars() -> [Car] {
        return carArray
    }
    
    
}
