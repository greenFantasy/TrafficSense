//
//  GameViewController.swift
//  trafficSense
//
//  Created by Yousef Ahmed on 6/13/19.
//  Copyright © 2019 Yousef Ahmed. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    @IBAction func loadLevel1(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        super.view.backgroundColor = UIColor.white
    
        
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
