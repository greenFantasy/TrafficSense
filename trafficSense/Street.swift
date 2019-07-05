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

class Street:StreetProtocol {
    
    
    func findClosestCar(car: Car) {
        return
    }
    
    internal var direction = 0 // left is 0, right is 1, down is 2, up is 3
    internal var carArray:[Car] = []
    internal var lightArray:[TrafficLight] = []
    internal var position:Int
    internal var lanes = 1
    
    init(heightWidth: Int, direction: Int) {
        position = heightWidth
        self.direction = direction
    }
    
    func getDirection() -> Int {
        return direction
    }
    
    func addCar(car: Car) {
        carArray.append(car)
        updateClosestCar()
    }
    
    func getPosition() -> Int {
        return position
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
    
    func removeCar(car: Car) {
        for i in 0...carArray.count-1 {
            if carArray[i] === car {
                carArray.remove(at: i)
                break
            }
        }
        updateClosestCar()
    }
    
    func updateClosestCar() {
        for vehicle in carArray {
            vehicle.clearClosestCar()
            closestCarChooser(car: vehicle)
        }
    }
    
    func findClosestCarLeft(car:Car) { // when direction == 0
        let x = car.getXPos()
        var closest:Car? = nil
        let streetCarArray = car.getStreet().getCars()
        for vehicle in streetCarArray {
            if (vehicle.getXPos() < x) {
                if let unwrapped = closest {
                    if (vehicle.getXPos() > unwrapped.getXPos()) {
                        closest! = vehicle
                        car.setClosestCar(car: closest!)
                    }
                } else {
                    closest = vehicle
                    car.setClosestCar(car: closest!)
                }
            }
        }
    }
    
    func findClosestCarRight(car:Car) { // when direction == 1
        let x = car.getXPos()
        var closest:Car? = nil
        let streetCarArray = car.getStreet().getCars()
        for vehicle in streetCarArray {
            if (vehicle.getXPos() > x) {
                if let unwrapped = closest {
                    if (vehicle.getXPos() < unwrapped.getXPos()) {
                        closest! = vehicle
                        car.setClosestCar(car: closest!)
                    }
                } else {
                    closest = vehicle
                    car.setClosestCar(car: closest!)
                }
            }
        }
    }
    
    func findClosestCarDown(car:Car) { // when direction == 2
        let y = car.getYPos()
        var closest:Car? = nil
        let streetCarArray = car.getStreet().getCars()
        for vehicle in streetCarArray {
            if (vehicle.getYPos() < y) {
                if let unwrapped = closest {
                    if (vehicle.getYPos() > unwrapped.getYPos()) {
                        closest! = vehicle
                        car.setClosestCar(car: closest!)
                    }
                } else {
                    closest = vehicle
                    car.setClosestCar(car: closest!)
                }
            }
        }
    }
    
    func findClosestCarUp(car:Car) { // when direction == 3
        let y = car.getYPos()
        var closest:Car? = nil
        let streetCarArray = car.getStreet().getCars()
        for vehicle in streetCarArray {
            if (vehicle.getYPos() > y) {
                if let unwrapped = closest {
                    if (vehicle.getYPos() < unwrapped.getYPos()) {
                        closest! = vehicle
                        car.setClosestCar(car: closest!)
                    }
                } else {
                    closest = vehicle
                    car.setClosestCar(car: closest!)
                }
            }
        }
    }
    
    func closestCarChooser(car: Car) {
        switch car.getDirection() {
        case 0:
            findClosestCarLeft(car: car)
        case 1:
            findClosestCarRight(car: car)
        case 2:
            findClosestCarDown(car: car)
        case 3:
            findClosestCarUp(car: car)
        default:
            findClosestCarLeft(car: car)
        }
    }
    
}
