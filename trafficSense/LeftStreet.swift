//
//  LeftStreet.swift
//  trafficSense
//
//  Created by Rajat Mittal on 7/4/19.
//  Copyright © 2019 Yousef Ahmed. All rights reserved.
//

import Foundation
import UIKit


class LeftStreet:StreetProtocol {
    
    internal var direction = 0 // left is 0, right is 1, down is 2, up is 3
    internal var carArray:[Car] = [] // contains all the cars on the street
    internal var lightArray:[TrafficLight] = [] // contains all the lights on the street
    internal var position:Int // is the y-position of the street (x-position in case of up and down streets)
    internal var lanes = 1 // currently this does nothing, will eventually incorporate this in the future
    
    init(streetPos: Int) {
        position = streetPos
    }
    
    func getDirection() -> Int {
        return direction // direction never changes, it is always 0 for a leftstreet
    }
    
    func addCar(car: Car) {
        carArray.append(car)
        updateClosestCar()
    }
    
    func getPosition() -> Int {
        return position
    }
    
    func addLight(trafficLight: TrafficLight) {
        // lightArray is already sorted such that the lights are placed in order of those first on the street are first in the array, and those farther down the street are placed later in the array
        // since lightArray is pre-sorted, when lights are added, the algo just places the new light in the correct "sorted" position in the already sorted array
        var added = false
        if (lightArray.count > 0) {
            for i in 0...lightArray.count-1 {
                if (!added && trafficLight.getXPos() > lightArray[i].getXPos()) {
                    lightArray.insert(trafficLight,at:i)
                    added = true
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
        // finds the light closest to a car on a given street
        for trafficLight in lightArray {
            if (car.getXPos() > trafficLight.getXPos()) {
                return trafficLight
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
            if vehicle.getStreet().getDirection() == self.getDirection() {
                vehicle.clearClosestCar()
                findClosestCar(car: vehicle)
            }
        }
    }
    
    func findClosestCar(car:Car) {
        // finds the closest car directly in front of a certain vehicle
        let x = car.getXPos()
        var closest:Car? = nil
        let streetCarArray = car.getStreet().getCars()
        for vehicle in streetCarArray {
            if (vehicle.getXPos() < x) {
                if let unwrapped = closest {
                    if (vehicle.getXPos() > unwrapped.getXPos()) {
                        closest = vehicle
                        car.setClosestCar(car: closest!)
                    }
                } else {
                    closest = vehicle
                    car.setClosestCar(car: closest!)
                }
            }
        }
    }
    
    func isStreetFree(startingPos: Int, endingPos: Int) -> Car? {
        var lower = 0
        var upper = 0
        var closeCar: Car?
        if (startingPos < endingPos) {
            lower = startingPos
            upper = endingPos
        } else {
            lower = endingPos
            upper = startingPos
        }
        for vehicle in carArray {
            if (lower < vehicle.getXPos() && upper > vehicle.getXPos() && vehicle.getLastTurn() != 2) {
                if let car = closeCar {
                    if vehicle.getXPos() < car.getXPos() {
                        closeCar = vehicle
                    }
                } else {
                    closeCar = vehicle
                }
            }
        }
        return closeCar
    }
}
