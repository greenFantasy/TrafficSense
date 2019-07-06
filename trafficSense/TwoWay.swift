//
//  TwoWay.swift
//  trafficSense
//
//  Created by Rajat Mittal on 6/30/19.
//  Copyright © 2019 Yousef Ahmed. All rights reserved.
//

import Foundation
import UIKit

class TwoWay {
    init(heightWidth1: Int, direction1: Int, heightWidth2: Int, direction2: Int) {
        
        
        
        if (direction1 == 0 && direction2 == 1 && (heightWidth1 - heightWidth2 == abs(30))) || (direction2 == 0 && direction1 == 1 && (heightWidth1 - heightWidth2 == abs(30))) || (direction1 == 2 && direction2 == 3 && (heightWidth1 - heightWidth2 == abs(30))) || (direction2 == 3 && direction1 == 2 && (heightWidth1 - heightWidth2 == abs(30)))
            
        {
            
            var street1:Street = Street(heightWidth: heightWidth1, direction: direction1)
            
            var street2:Street = Street(heightWidth: heightWidth2, direction: direction2)
            
        }
    }
}
