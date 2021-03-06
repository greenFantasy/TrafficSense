//
//  GameScene.swift
//  trafficSense
//
//  Created by Yousef Ahmed on 6/13/19.
//  Copyright © 2019 Yousef Ahmed. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit
import RealmSwift

class GameScene: SKScene {
    var user: User!
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    private var pauseButton = SKShapeNode()
    private var unpauseButton = SKShapeNode()
    private var unpauseButtonInPauseView = UIButton()
    private var endView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
    private var pauseView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
    private var lastUpdateTime : TimeInterval = 0
    private var spinnyNode : SKShapeNode?
    private var light : TrafficLight?
    private var carArray:[Car] = []
    private var lightArray:[TrafficLight] = []
    private var intersectionArray:[Intersection] = []
    private var scoreLabel = SKLabelNode(fontNamed: "Helvetica Neue")
    private var score = 0  // Score variable
    private var timer:Timer?  // Creates optional of type Timer
    private var timeLeft = 60  //Variable used in timer for setting amount of time left
    private var streetArray:[StreetProtocol] = []
    private var twoWayHorizontalArray:[TwoWayHorizontal] = []
    private var twoWayVerticalArray:[TwoWayVertical] = []
    private var gameOverLabel = SKLabelNode(fontNamed: "Helvetica Neue")
    private var hitCounter = 0
    private var carsThrough = 0
    private var isTheGamePaused = false
    private var numberOfPauseClicks = 0

    
    let worldNode = SKNode()
    
    override func sceneDidLoad() {
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
//
        let realm = try! Realm()

        if realm.objects(User.self).count == 0 {
            try! realm.write {
                let newUser = User()
                
                newUser.highScore = 0
                newUser.level = 1
                
                realm.add(newUser)
                user = newUser
            }
        } else {
          user = realm.objects(User.self)[0]
        }
        self.lastUpdateTime = 0
        
        /*  This next block of code sets a few properties for the score label which will also include time left in the game. Currently its position is set relative to the screen size so that multiple devices can be supported.
        */
        addChild(worldNode)
        
        
        gameOverLabel.isHidden = true
        
        createPauseButton()
        
        scoreLabel.text = ""
        scoreLabel.fontSize = 65
        scoreLabel.zPosition = 150
        scoreLabel.fontColor = SKColor.blue
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY * 3/4)
        
        self.addChild(scoreLabel)  // Adds the scoreLabel to the scene
        
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = gameViewSK.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        gameViewSK.addSubview(blurEffectView)
//        blurEffectView.isHidden=true;
//
        
        let firstTwoWay = createTwoWayHorizontal(midline: 100)
        
        createCar(-200, 100, leftStreet: firstTwoWay.getLeftStreet())
        createCar(-100, 200, leftStreet: firstTwoWay.getRightStreet())
        
        let secondTwoWay = createTwoWayVertical(midline: 100)
        
        createCar(200, -100, leftStreet: secondTwoWay.getDownStreet())
        createCar(100, -200, leftStreet: secondTwoWay.getUpStreet())
        
        let third = createTwoWayVertical(midline: -300)
        
        createCar(-400, -100, leftStreet: third.getDownStreet())
        createCar(-500, -200, leftStreet: third.getUpStreet())
        
        let fourth = createTwoWayHorizontal(midline: -200)
        
        
        intersectionCreator() // creates all the intersections based on the horizontal and vertical streets created above
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
        
        timer?.tolerance = 0.15 // Makes the timer more efficient
        
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common) // Helps UI stay responsive even with timer
        
        /*  The timer above is now initialized using a few key properties: the timeInterval is the interval in which the timer will update, target is where the timer will be applied, selector specifies a function to run when the timer updates based on the time interval, userInfo can supply information to the selector function, and repeats allows the timer to run continuously until invalidated.
        */
    }
    
    /*  The function below is visible in objective-c since the selector is an obj-c concept. The timeLeft variable is deprecated by 1 referencing one second passing. The label is updated, and once the timeLeft variable reaches 0, the timer is invalidated and the label is updated to reflect the game being over.
    */
    @objc func onTimerFires() {
        timeLeft -= 1
        scoreLabel.text = "\(timeLeft) sec left  Score: " + String(carsThrough) + "  Cars Hit: " + String(hitCounter)
        
        if timeLeft <= 0 {
            timer?.invalidate()
            timer = nil
            gameOverScreen()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //    for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    //    for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            let nodeITapped = atPoint(pointOfTouch)
            let nameOfTappedNode = nodeITapped.name
            
            
            if let x = nameOfTappedNode {
            
                if let index = Int(x) {
                    //make it do whatever you want
                    switchLight(trafficLight: lightArray[index - 1])
                    if (index % 2 == 1) {
                        switchLight(trafficLight: lightArray[index])
                    } else {
                        switchLight(trafficLight: lightArray[index - 2])
                    }
                    
                }
                
//                if x == "pause" {
//                    print("chicken")
//                    createunPauseButton()
//                    pauseButton.removeFromParent()
//                    pauseGame()
//                } else {
//                    print(x)
//                }
            }
            
            
            if pauseButton.contains(pointOfTouch) {
                
                numberOfPauseClicks+=1
                
                pauseGame()
                //scene?.view?.isPaused = false
//                if (numberOfPauseClicks%2 == 0){
//                    unpauseButton.removeFromParent()
//                    isTheGamePaused = false
//
//                    pauseGame()
//                }
//                else{
//                    pauseButton.removeFromParent()
//                    isTheGamePaused = true
//
//
//                }
//
//                if unpauseButtonInEndView.contains(pointOfTouch as! UIFocusEnvironment){
//
//
//                    print("hellp")
//
//                }
//                switchImage()
                
                
//                createunPauseButton()
//
//                pauseButton.removeFromParent()
                //unPauseGame()
            }
            
//            if unpauseButton.contains(pointOfTouch) {
//
//                print("unpause clicked")
//                isTheGamePaused = false
//                switchImage()
////                unpauseButton.removeFromParent()
//
//            }
            
            
            
        }

    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    //    for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    func createPauseButton()
        
    {
        
        
        pauseButton = SKShapeNode(rectOf: CGSize(width: 75, height: 75))
        
        pauseButton.fillTexture = SKTexture.init(image: UIImage(named: "pauseButton")!)
        pauseButton.fillColor = UIColor.white
        pauseButton.position = CGPoint(x: 500, y: 300)
        pauseButton.zPosition = 100000
        
        //pauseButton.zPosition = 10
        self.addChild(pauseButton)
        
        
        
    }
    
//    func createunPauseButton(){
//
//
//            unpauseButton = SKShapeNode(rectOf: CGSize(width: 75, height: 75))
//            unpauseButton.fillColor = UIColor.white
//            unpauseButton.fillTexture = SKTexture.init(image: UIImage(named: "unPauseButton")!)
//            unpauseButton.position = CGPoint(x: 500, y: 300)
//
//            self.addChild(unpauseButton)
//            //pauseGame()
//            //scene?.view?.isPaused = true
//
//
//    }
    
    func switchImage() {
        
        if (isTheGamePaused == true){
            
//            pauseButton.removeFromParent()
            
            unpauseButton = SKShapeNode(rectOf: CGSize(width: 75, height: 75))
            unpauseButton.fillColor = UIColor.white
            unpauseButton.fillTexture = SKTexture.init(image: UIImage(named: "unPauseButton")!)
            unpauseButton.position = CGPoint(x: 500, y: 300)
            self.addChild(unpauseButton)
            pauseGame()
            
        }
        else {
            
//            unpauseButton.removeFromParent()
            pauseButton = SKShapeNode(rectOf: CGSize(width: 75, height: 75))
            
            pauseButton.fillTexture = SKTexture.init(image: UIImage(named: "pauseButton")!)
            pauseButton.fillColor = UIColor.white
            pauseButton.position = CGPoint(x: 500, y: 300)
//            pauseButton.zPosition = 100000
            
            
            self.addChild(pauseButton)
//            unPauseGame()
            
        }
        
        
    }
    
    func pauseGame() {//pauses the game and brings up a pause screen
        
        
        
        
        
        
        
        
        pauseView.isHidden = false
        self.view?.isPaused = true
        //        scene.setEndButton(restartButton: UIButton)
//        self.addChild(pauseView)
//        self.addSubview(pauseView)
//        pauseView.isHidden = false
        
        
        
    }
    
    @objc func unPauseGame(_ button: UIButton) {
        
        pauseView.isHidden = true
        self.view?.isPaused = false
        
    }
    
    func switchLight(trafficLight:TrafficLight) {
        trafficLight.changeState()
    }
    
    
    func setView(endView: UIView, pauseView: UIView, unpauseButton: UIButton){
        self.endView = endView
        self.pauseView = pauseView
        self.unpauseButtonInPauseView = unpauseButton
        unpauseButtonInPauseView.addTarget(self, action: #selector(unPauseGame(_ :)), for: UIControl.Event.touchUpInside)
    }
    
    func restartGame(resetButton: UIButton){
        
        
        
        
    }
    
    
    func moveCarForward(vehicle: Car) {
        let vec = vehicle.directionToVector()
        
        vehicle.move(xVel: vec[0] * Int(vehicle.getTopSpeed() * speedModifier(distance: absoluteValue(calcXDistance(car1: vehicle, car2: vehicle.getClosestCar())))), yVel: vec[1] * Int(vehicle.getTopSpeed() * speedModifier(distance: absoluteValue(calcYDistance(car1: vehicle, car2: vehicle.getClosestCar())))))
    }
    
    func move() {
        var elementsToRemove:[Int] = []
        for i in 0...carArray.count-1 {
            let vehicle = carArray[i]
            var moveVehicle = true
            let tempLight = vehicle.findLight()
            if (isVehicleCloseToLight(vehicle: vehicle, light: tempLight) && tempLight.isRed()) {
                moveVehicle = false
            }
            
            if (moveVehicle) {
                
                if let intersection = isCarAtAnyIntersectionChecker(vehicle) {
                    
                    _ = vehicle.addToIntersectionArray(intersection: intersection)
                    if (vehicle.getLastTurn() == 0 || vehicle.isLastTurnCompleted()) {
                        moveCarForward(vehicle: vehicle)
                    } else if vehicle.getLastTurn() == 1 {
                        vehicle.makeRightTurn(intersection: intersection)
                    } else if vehicle.getLastTurn() == 2 {
                        vehicle.makeLeftTurn(intersection: intersection)
                    }
                } else {
                    moveCarForward(vehicle: vehicle)
                }
            }
            if (vehicle.getXPos() <= Int(-self.scene!.size.width/2) && vehicle.getDirection() == 0) {
                createCar(Int(self.scene!.size.width/2) + 100, vehicle.getYPos(), leftStreet: vehicle.getStreet())
                elementsToRemove.append(i)
                removeCar(vehicle)
                if (carArray.count < 25) {
                    createCar(Int(self.scene!.size.width/2) + 200, vehicle.getYPos(), leftStreet: vehicle.getStreet())
                    createCar(Int(self.scene!.size.width/2) + 300, vehicle.getYPos(), leftStreet: vehicle.getStreet())
                }
            }
            else if (vehicle.getYPos() <= Int(-self.scene!.size.height/2) && vehicle.getDirection() == 2) {
                createCar(vehicle.getXPos(), Int(self.scene!.size.height/2), leftStreet: vehicle.getStreet())
                elementsToRemove.append(i)
                removeCar(vehicle)
                if (carArray.count < 25) {
                    //createCar(-vehicle.getXPos(), 1000, leftStreet: vehicle.getStreet())
                }
            }
            else if (vehicle.getYPos() >= Int(self.scene!.size.height/2) && vehicle.getDirection() == 3) {
                createCar(vehicle.getXPos(), Int(-self.scene!.size.height/2), leftStreet: vehicle.getStreet())
                elementsToRemove.append(i)
                removeCar(vehicle)
                if (carArray.count < 25) {
                    //createCar(vehicle.getXPos(), -vehicle.getYPos() - 100, leftStreet: vehicle.getStreet())
                }
            }
            else if (vehicle.getXPos() >= Int(self.scene!.size.width/2) && vehicle.getDirection() == 1) {
                createCar(Int(-self.scene!.size.width/2), vehicle.getYPos(), leftStreet: vehicle.getStreet())
                elementsToRemove.append(i)
                removeCar(vehicle)
            }
        }
        removeElementsFromArray(elementsToRemove: elementsToRemove, array: &carArray)
    }
    
    func removeCar(_ vehicle: Car) {
        vehicle.getNode().removeFromParent()
        vehicle.getStreet().removeCar(car: vehicle)
        carsThrough += 1
    }
    
    
    func removeElementsFromArray(elementsToRemove: [Int], array: inout [Car]) {
        let elementsReversed = elementsToRemove.reversed()
        for i in elementsReversed {
            array.remove(at: i)
        }
    }
    
    func isVehicleCloseToLight(vehicle: Car, light: TrafficLight) -> Bool {
        let width = light.getIntersection().getWidth() + 3 * light.getRadius()
        let height = light.getIntersection().getHeight() + 3 * light.getRadius()
        if vehicle.getDirection() == 0 {
            return vehicle.getXPos() > light.getXPos() + width && vehicle.getXPos() < light.getXPos() + width + 50
        } else if vehicle.getDirection() == 2 {
            return vehicle.getYPos() > light.getYPos() + height && vehicle.getYPos() < light.getYPos() + height + 50
        } else if vehicle.getDirection() == 1 {
            return vehicle.getXPos() < light.getXPos() - width && vehicle.getXPos() > light.getXPos() - width - 50
        } else {
            return vehicle.getYPos() < light.getYPos() - height && vehicle.getYPos() > light.getYPos() - height - 50
        }
    }
    
//    func calcNewOffset(spacing base: Double) -> Double {
//        var newOffset = base
//        for vehicle in carArray {
//            let boundingBox = vehicle.getNode().path!.boundingBox
//            let vehicleWidth = boundingBox.size.width
//            newOffset = newOffset + Double(vehicleWidth) + base
//        }
//        return newOffset
//    }
    
    func calcXDistance(car1: Car?, car2: Car?) -> Int {
//        let boundingBox1 = car1.getNode().path!.boundingBox
//        let vehicleWidth1 = boundingBox1.size.width/2
//        let boundingBox2 = car2.getNode().path!.boundingBox
//        let vehicleWidth2 = boundingBox2.size.width/2
//        return car1.getXPos() - car2.getXPos() - Int(vehicleWidth1) - Int(vehicleWidth2)
        if let vehicle1 = car1 {
            if let vehicle2 = car2 {
                return absoluteValue(vehicle1.getXPos(), vehicle2.getXPos())
            } else {
                return 1000000
            }
        } else {
            return 1000000
        }
    }
    
    func calcYDistance(car1: Car?, car2: Car?) -> Int {
        //        let boundingBox1 = car1.getNode().path!.boundingBox
        //        let vehicleWidth1 = boundingBox1.size.width/2
        //        let boundingBox2 = car2.getNode().path!.boundingBox
        //        let vehicleWidth2 = boundingBox2.size.width/2
        //        return car1.getXPos() - car2.getXPos() - Int(vehicleWidth1) - Int(vehicleWidth2)
        if let vehicle1 = car1 {
            if let vehicle2 = car2 {
                return absoluteValue(vehicle1.getYPos(),vehicle2.getYPos())
            } else {
                return 1000000
            }
        } else {
            return 1000000
        }
    }
    
    func absoluteValue(_ a:Int, _ b:Int) -> Int {
        if (a>b) {
            return a-b
        } else {
            return b-a
        }
    }
    
    func absoluteValue(_ a:Int) -> Int {
        if (a>=0) {
            return a
        } else {
            return -a
        }
    }
    
    func speedModifier(distance:Int) -> Double {
        let minDistance = 50
        let highSpeedDistance = 230
        if distance <= minDistance {
            return 0
        } else if (distance <= highSpeedDistance) {
            return Double((distance - minDistance))/Double(highSpeedDistance-minDistance)
        }
        else {
            return 1
        }
    }
    
    func createCar(_ xPos:Int, _ yPos:Int, leftStreet: StreetProtocol) {
        // let number = Int.random(in: -700 ... 300)
        var create = true
        for vehicle in carArray {
            if (absoluteValue(xPos, vehicle.getXPos()) < 60 && absoluteValue(yPos, vehicle.getYPos()) < 60) {
                create = false
            }
        }
        if (create) {
            let streetCarArray = leftStreet.getCars()
            let number = Int.random(in: 1 ... 2)  // This code generates a random number 1 or 2 to replicate 50% probability for any event
            var car : Car?
            if (number == 1) {
                car = Car(x: xPos, y: yPos, street: leftStreet, imageNamed: "car") // If 1, a Car instance will be created with the image being that of a car
            }
            else {
                car = Car(x: xPos, y: yPos, street: leftStreet, imageNamed: "yellow car") // If 2, a Car instance will be created with the image being that of a pickup truck
            }
            
            self.addChild(car!.getNode())
            carArray.append(car!)
            for vehicle in streetCarArray {
                if let car2 = car!.getClosestCar() {
                    if (leftStreet.getDirection() == 0 && car2.getXPos() < vehicle.getXPos() && car!.getXPos() > vehicle.getXPos()) {
                        vehicle.setClosestCar(car: vehicle)
                    }
                    if (leftStreet.getDirection() == 1 && car2.getXPos() > vehicle.getXPos() && car!.getXPos() < vehicle.getXPos()) {
                        
                        vehicle.setClosestCar(car: vehicle)
                    }
                }
            }
        }
    }
    
    
    func createTwoWayHorizontal(midline: Int) -> TwoWayHorizontal {
        
        let twoWayHorizontal = TwoWayHorizontal(midline: midline)
        
        twoWayHorizontalArray.append(twoWayHorizontal)
        
        self.addChild(twoWayHorizontal.getNode())
        
        
        
        return twoWayHorizontal
        
        
    }
    
    
    func createTwoWayVertical(midline: Int) -> TwoWayVertical {
        
        let twoWayVertical = TwoWayVertical(midline: midline)
        
        twoWayVerticalArray.append(twoWayVertical)
        
        self.addChild(twoWayVertical.getNode())
        
        
        
        return twoWayVertical
    }
    
    
    func createLight(trafficLight: TrafficLight) {
        let light = trafficLight
        self.addChild(light.getNode())
        lightArray.append(light)
        light.getNode().name = String(lightArray.count)
    }
    
    func intersectionCreator() {
        for horizontalTwoWay in twoWayHorizontalArray {
            for verticalTwoWay in twoWayVerticalArray {
                let intersection = Intersection(horizontal: horizontalTwoWay, vertical: verticalTwoWay)
                intersectionArray.append(intersection)
                for trafficLight in intersection.getAllLights() {
                    createLight(trafficLight: trafficLight)
                }
            }
        }
    }
    
    func isCarAtAnyIntersectionChecker(_ car: Car) -> Intersection? {
        for intersection in intersectionArray {
            if (intersection.isCarAtIntersection(car)) {
                return intersection
            }
        }
        return nil
    }
    
    func checkCollisions() {
        
        var hitCars: [Car] = []
        
        for i in 0...carArray.count-2 {
            if (carArray[i].getXPos() > -Int(scene!.size.width)/2 && carArray[i].getXPos() <  Int(scene!.frame.width)/2 && carArray[i].getYPos() > -Int(scene!.size.height)/2 && carArray[i].getYPos() < Int(scene!.size.height)/2)
            {
                for j in i+1...carArray.count-1 {
                    if (carArray[i].getNode().frame.intersects(carArray[j].getNode().frame) && (!carArray[i].getIntersected() || !carArray[j].getIntersected()) )
                    {
                        hitCars.append(carArray[j])
                        hitCars.append(carArray[i])
                    }
                    
                    
                }
            }
            
        }
        
        if (hitCars.count>0){
            
            for i in 0...hitCars.count-1 {
                
                if (i%2==1) {
                    if (hitCars[i].getLastTurn() == 2 && hitCars[i-1].getLastTurn() == 2) {
//                        print("two left turning hit cars, no issue")
                    } else {
                        hitCounter += 1
                        hitCars[i].changeIntersected()
                        hitCars[i-1].changeIntersected()
                        print("Car Hit #" + String(hitCounter))
                        gameOverScreen()
                    }
                }
            
            }
            
        }
        
    }
    
    func gameOverScreen() {
        timer?.invalidate()
        timer = nil
 
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOverLabel.zPosition = 150
        
        endView.isHidden = false
        
        var isHighScore = false
        
        if user.highScore < score {
            isHighScore = true
            let realm = try! Realm()
            
            try! realm.write {
                user.highScore = score
            }
        }
        
        let labels = getLabelsInView(view: endView)
        for label in labels {
            score = carsThrough
            if isHighScore {
                label.text = "Game over!  Score: " + String(score) + "! Highscore"
            } else {
                label.text = "Game over!  Score: " + String(score)
            }
            label.frame.origin = CGPoint(x: frame.midX, y: frame.midY)
        }
    }
    
    func getLabelsInView(view: UIView) -> [UILabel] {
        var results = [UILabel]()
        for subview in view.subviews as [UIView] {
            if let labelView = subview as? UILabel {
                results += [labelView]
            } else {
                results += getLabelsInView(view: subview)
            }
        }
        return results
    }
    
    func getStreetToTurnOn (car: Car, intersection: Intersection) -> StreetProtocol {
        let number = Int.random(in: 0 ... 1)
        if (car.getDirection() <= 1) {
            if number == 0 {
                return intersection.getVerticalTwoWay().getDownStreet()
            } else {
                return intersection.getVerticalTwoWay().getUpStreet()
            }
        } else {
            if number == 0 {
                return intersection.getHorizontalTwoWay().getLeftStreet()
            } else {
                return intersection.getHorizontalTwoWay().getRightStreet()
            }
        }
    }
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        move()
        checkCollisions()
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
