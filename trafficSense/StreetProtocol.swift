//
//  StreetProtocol.swift
//  trafficSense
//
//  Created by Rajat Mittal on 6/30/19.
//  Copyright © 2019 Yousef Ahmed. All rights reserved.
//

import Foundation
import UIKit

protocol StreetProtocol {
    
    var direction:Int { get set } // left is 0, right is 1, down is 2, up is 3
    var carArray:[Car] { get set }
    var lightArray:[TrafficLight] { get set }
    var position:Int { get set }
    var lanes:Int { get set }
    
    func getDirection() -> Int
    
    func addCar(car: Car)
    
    func getPosition() -> Int
    
    func addLight(trafficLight: TrafficLight)
    
    func lightFinder(car: Car) -> TrafficLight
    
    func getCars() -> [Car]
    
    func removeCar(car: Car)
    
    func updateClosestCar()
    
    func findClosestCarLeft(car:Car)
    
    func findClosestCarRight(car:Car)
    
    func findClosestCarDown(car:Car)
    
    func findClosestCarUp(car:Car)
    
    func closestCarChooser(car: Car)
    
}
