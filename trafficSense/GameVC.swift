//
//  GameVC.swift
//  trafficSense
//
//  Created by Rajat Mittal on 6/19/19.
//  Copyright © 2019 Yousef Ahmed. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import GameplayKit

class GameVC: UIViewController {
    
    @IBOutlet var gameView: SKView!
    
    @IBOutlet weak var gameViewSK: SKView!
    
    @IBOutlet var viewScreen: UIView!
    @IBOutlet weak var gameOverLabel: UILabel!
    
    @IBOutlet weak var restartButton: UIButton!
    
    private var unpauseButton = UIView()
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        super.view.backgroundColor = UIColor.white
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                if let view = self.gameViewSK {
                    editGameOverScreen(scene: sceneNode)
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    
                    view.showsNodeCount = true
                }
                
            }
        }
        
        
    }
    
    func editGameOverScreen(scene: GameScene){
        
        let restartButton = UIButton(frame: CGRect(x: 350, y: 200, width: 300, height: 300))
        
        
        
        
        let pauseView = UIView(frame: view.frame)
        
        pauseView.addSubview(restartButton)
        
        restartButton.isHidden = false
        restartButton.setTitle("Restart", for: .normal)
        restartButton.setTitleColor(UIColor.white, for: .normal)
        
        
        
        let image = UIImage(named: "unPauseButton") as UIImage?
        let unpauseButton = UIButton(type: UIButton.ButtonType.custom) as UIButton
        unpauseButton.frame = CGRect(x: 675, y: 35, width: 45, height: 45)
        unpauseButton.setImage(image, for: .normal)
//        unpauseButton.addTarget(self, action: "btnTouched:", forControlEvents:.TouchUpInside)
//        viewScreen.addSubview(unpauseButton)
//        self.view.addSubview(unpauseButton)
        
        
//        unpauseButton = UIButton(frame: CGRect(x: 250, y: 250, width: 75, height: 75))
        unpauseButton.tintColor = UIColor.white
        
//        unpauseButton.position = CGPoint(x: 500, y: 300)
        pauseView.addSubview(unpauseButton)
        
        
        
        //        scene.setEndButton(restartButton: UIButton)
        
        viewScreen.addSubview(pauseView)
        pauseView.isHidden = true
        pauseView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
        
        
        
        
        let gameOverLabel = UILabel(frame: CGRect(x: scene.size.width/4, y: scene.size.height/4, width: 1000, height: 50))
        
        
        
//        let restartButton = UIButton(frame: CGRect(x: 300, y: 300, width: 200, height: 40))
//
//        restartButton.setTitle("Restart", for: .normal)
        
        
        
        
        print(scene.size.width/2)
        print(scene.size.height/2)
        let endView = UIView(frame: view.frame)
        endView.addSubview(gameOverLabel)
        endView.addSubview(restartButton)
        
        restartButton.isHidden = false
        restartButton.setTitle("Restart", for: .normal)
        restartButton.setTitleColor(UIColor.white, for: .normal)
        
        
        gameOverLabel.isHidden = false
        gameOverLabel.text = "Game Over!"
        gameOverLabel.font = UIFont(name: "Times New Roman", size: 70)
        
        gameOverLabel.textColor = UIColor.red
        
//        scene.setEndButton(restartButton: UIButton)
        
        viewScreen.addSubview(endView)
        endView.isHidden = true
        endView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
        
        scene.setView(endView: endView, pauseView: pauseView, unpauseButton: unpauseButton)
        
        
        
    }
    
    
    
//    func createRestartButton(){
//
//        restartButton = SKSpriteNode(imageNamed: "restartButton")
//        restartButton.position = CGPoint(x: 0, y: 0)
//        restartButton.size = CGSize(width: 150, height: 150)
//
//
//
//    }
    
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

