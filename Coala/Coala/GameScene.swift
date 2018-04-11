//
//  GameScene.swift
//  Coala
//
//  Created by nidangkun on 2017/9/12.
//  Copyright © 2017年 nidangkun. All rights reserved.
//

import UIKit
import SpriteKit

class GameScene: SKScene ,SKPhysicsContactDelegate{
    //当切换到这个场景
    
    var guide : GuideNode!
    
    
    var playNode : PlayerNode!
    
    var rainCount : Int = 0
    
    var counterNd : CounterNode!
    
    var groundNode : SKSpriteNode!
    
    var gameStartTime : NSDate!
    
    var lastUpdateTime : TimeInterval!
    
    var lastRainTime : TimeInterval!
    
    var rainBegin : Bool = false

    var rainArrayTextures : Array<SKTexture>!
    
    var scoreBG : SKSpriteNode!
    
    let saveDefault = UserDefaults.standard
    
    let saveScoreKey = "highScore"
    
    override func didMove(to view: SKView) {
        
        
        self.physicsWorld.gravity = CGVector.zero
        
        self.physicsWorld.contactDelegate = self
        
        
        lastUpdateTime = 0
        
        lastRainTime = 0
        
        let bgTexture = SKTexture.init(imageNamed: "background")
        
        let bgNode = SKSpriteNode.init(texture: bgTexture)
        
        bgNode.size = CGSize.init(width: ScreenWidth, height: ScreenHeight)
        
        bgNode.position = CGPoint.init(x: self.frame.midX, y: self.frame.midY)
        
        self.addChild(bgNode)
        
        
        groundNode = SKSpriteNode.init(texture: SKTexture.init(imageNamed: "ground"))
        groundNode.size.width = ScreenWidth
        
        groundNode.position = CGPoint.init(x: self.frame.midX, y: groundNode.size.height/2)

        self.addChild(groundNode)
        
        var animateArray = [SKTexture]()
        for i in 1 ... 6 {
            let aniText = "koala-walk-" + String(i)
            
            let animate = SKTexture.init(imageNamed: aniText)
            
            animateArray.append(animate)
        }
        
        playNode = PlayerNode.init(defaultTxt: "koala-stop", animateTexture: animateArray)
        self.addChild(playNode)
        
        
        playNode.position = CGPoint.init(x: self.frame.midX, y: groundNode.size.height + playNode.size.height/2 - 15.00 )
        
    
        
        guide = GuideNode.init(title: "text-swipe", indicator: "finger")
        
        self.addChild(guide)
        
        guide.position = CGPoint.init(x: self.frame.midX, y: self.frame.midY)
        
        guide.setBlockMethod {
            self.startGame()
        }
        
        
        let darkCloud = SKSpriteNode.init(texture: SKTexture.init(imageNamed: "cloud-dark"))
        let brightCloud = SKSpriteNode.init(texture: SKTexture.init(imageNamed: "cloud-bright"))
        
        self.addChild(darkCloud)
        self.addChild(brightCloud)
        
        darkCloud.anchorPoint = CGPoint.init(x: 0.5, y: 1)
        darkCloud.zPosition = 20
        brightCloud.anchorPoint = CGPoint.init(x: 0.5, y: 1)
        brightCloud.zPosition = 10
        
        darkCloud.position = CGPoint.init(x: self.frame.midX, y: self.frame.maxY)
        brightCloud.position = CGPoint.init(x: self.frame.midX, y: self.frame.maxY)
        
        
        let moveValue = CGFloat(30)
        let darkCloudWith = darkCloud.size.width
        
        let absValue = ScreenWidth - darkCloudWith + 60
        
        darkCloud.size.width = darkCloudWith + absValue

        
        let moveUpAndDown = SKAction.repeatForever(SKAction.sequence([SKAction.moveBy(x: 0, y: moveValue, duration: 2.5),SKAction.moveBy(x: 0, y: -moveValue, duration: 2.5)]))
        
        let moveLeftAndRight = SKAction.repeatForever(SKAction.sequence([SKAction.moveBy(x: moveValue, y: 0, duration: 3),SKAction.moveBy(x: -moveValue, y: 0, duration: 3)]))
        
        
        
        brightCloud.run(moveUpAndDown)
        darkCloud.run(moveLeftAndRight)
        
        
        rainArrayTextures = Array.init()
        
        for i in 1...4 {
            let txtName = "rain-" + String(i)
            
            let texture = SKTexture.init(imageNamed: txtName)
            
            rainArrayTextures.append(texture)
            
        }
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        playNode.touchesBegan(touches, with: event!)
        
        buttonActionBegan(node: self, touches: touches, event: event!)
        
        //playNode.move()
        //print("player==>>>\(playNode.position.x)")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        playNode.touchesEnded(touches, with: event!)
        
        buttonActionEnded(node: self, touches: touches, event: event!)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guide.touchesMoved(touches, with: event!)
        
        playNode.touchesMoved(touches, with: event!)
        
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        playNode.update(currentTime: currentTime)
        
        var differTime = currentTime - lastUpdateTime
        
        if differTime > 1.0/60.0{
            differTime = 1.0/60.0
        }
        self.updateSinceLastTime(differTime: differTime)
        
        lastUpdateTime = currentTime
        
        
    
    }
    
    
    func fileTime () -> TimeInterval{
        //从开始到现在的时间
        let betweenTime = -ceil(gameStartTime.timeIntervalSinceNow)
        
        var fireTime = 1.0
        //小于20秒 缓慢减少 雨点下来的 间隔时间 最少0.2秒
        if betweenTime < 20 {
            fireTime = (30 - betweenTime) * 0.02
        }else{
            fireTime = 0.2
        }
        
        return fireTime
    }
    
    func updateSinceLastTime(differTime:TimeInterval){
        if playNode.isALive && rainBegin {
            lastRainTime = lastRainTime + differTime
            
            if lastRainTime > self.fileTime(){
                lastRainTime = 0
                
                self.addRainDrop()
                
            }
            
        }
    }
    
    func addRainDrop(){
    
        
        let rain = SKSpriteNode.init(texture: rainArrayTextures[0])
        self.addChild(rain)
        
        rain.run(SKAction.repeatForever(SKAction.animate(with: rainArrayTextures, timePerFrame: 0.1, resize: true, restore: true)), withKey: "rainDropAnimate")
        
        var minX = rain.size.width/2
        
        var maxX = self.frame.maxX - minX
        
        //var minX =
        
        //每 4次 追踪 一次熊的位置
        if rainCount % 4 == 0{
            
            minX = playNode.position.x
            
            maxX = minX + 20
            
        }
        
        let rangeX = maxX - minX
        
        var actualX = (arc4random() % UInt32(rangeX)) + UInt32(minX)
        
        let mX = self.frame.maxX - rain.size.width/2
        let miX = rain.size.width/2
        if CGFloat(actualX) > mX{
            
            actualX = UInt32(mX)
            
        }else if CGFloat(actualX) < miX {
            actualX = UInt32(miX)
        }
        rain.name = "rain"
        rain.physicsBody = SKPhysicsBody.init(rectangleOf: rain.size)
        rain.physicsBody?.categoryBitMask = rainCategory
        rain.physicsBody?.contactTestBitMask = playerCategory
        rain.physicsBody?.isDynamic = true
        
        rain.physicsBody?.usesPreciseCollisionDetection = true
        
        rain.position = CGPoint.init(x: CGFloat(actualX), y: self.frame.maxY + rain.size.height)
        
        
        
        let time = -ceil(gameStartTime.timeIntervalSinceNow)
        
        var minDR = 10
        
        var maxDR = 20
        
        if time > 20 && rainCount % 6 == 0{
            minDR = 20
            maxDR = 25
        }
        
        let rangeDR = maxDR - minDR
        
        let durationDrop = CGFloat(((arc4random() % UInt32(rangeDR)) + UInt32(minDR)) / 10)
        
        let dropAction = SKAction.moveTo(y: groundNode.size.height, duration: TimeInterval(durationDrop))
        
        let countIncreaseAct = SKAction.run {
            self.counterNd.increase()
        }
        
        rain.run(SKAction.sequence([dropAction,countIncreaseAct,SKAction.run {
            rain.removeFromParent()
            }]))
        
        rainCount += 1
        
    }
    
    
    func startGame(){
        
        rainCount = 0
        
        scoreBG = SKSpriteNode.init(texture: SKTexture.init(imageNamed: "score"))
        self.addChild(scoreBG)
        
        scoreBG.position = CGPoint.init(x: self.frame.midX, y: groundNode.size.height - scoreBG.size.height - 50)
        
        counterNd = CounterNode.init(number: 0)
        
        self.addChild(counterNd)
        
        counterNd.position = CGPoint.init(x: scoreBG.frame.maxX , y: scoreBG.position.y)
        
        
        counterNd.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),SKAction.fadeIn(withDuration: 0.3)]))
        
        gameStartTime = NSDate.init()
        
        
        rainBegin = true
        
        //print("gameStartTime==>>>\(gameStartTime)")
        
            
        /*
        let delay = DispatchTime.now() + .seconds(3)
        DispatchQueue.main.asyncAfter(deadline: delay) { 
            print("time1111===>>>>\(self.gameStartTime.timeIntervalSinceNow)")
        }
        */
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyB.categoryBitMask != contact.bodyA.categoryBitMask{
            
            for item in self.children{
                if item.name == "rain" {
                    
                    item.removeAllActions()
                }
            }
            
            if playNode.isALive {
                playNode.end()
                
                counterNd.run(SKAction.fadeOut(withDuration: 0.3))
                scoreBG.run(SKAction.fadeOut(withDuration: 0.3))
                self.run(SKAction.sequence([SKAction.wait(forDuration: 0.8),SKAction.run({
                    self.showGameOverView()
                })]))
                
            }
        
        }
    }
    
    
    func storeHighScore(score:Int){
        guard let highScore = saveDefault.value(forKey: saveScoreKey) else {
            saveDefault.setValue(score, forKey: saveScoreKey)
            return }
        
        if (highScore as! Int) < score{
            saveDefault.setValue(score, forKey: saveScoreKey)
        }
        
    }
    
    func showGameOverView(){
        
        let gameOverText = SKSpriteNode.init(texture: SKTexture.init(imageNamed: "text-gameover"))
        
        gameOverText.position = CGPoint.init(x: self.frame.midX, y: self.frame.midY*1.5)
        
        self.addChild(gameOverText)
        
        
        
        let boardNode = SKSpriteNode.init(texture: SKTexture.init(imageNamed: "scoreboard"))
        
        boardNode.position = CGPoint.init(x: self.frame.midX, y: self.frame.midY)
        
        self.addChild(boardNode)
        
        
        let currentScoreNode = CounterNode.init(number: 0)
        
        currentScoreNode.count = counterNd.count
        
        currentScoreNode.updateCounter()
        
        currentScoreNode.position = CGPoint.init(x: boardNode.frame.maxX - 13, y: boardNode.frame.maxY - boardNode.size.height/3 - 13 )
        
        self.addChild(currentScoreNode)
        
        //currentScoreNode.position = CGPoint
        
        let highScoreNode = CounterNode.init(number: 0)
        
        let historyHigh = saveDefault.value(forKey: saveScoreKey)
        
        var newRecordNode : SKSpriteNode?
        
        if historyHigh != nil{
            highScoreNode.count = historyHigh as! Int
            
            //是否最高分，
            if (historyHigh as! Int) < counterNd.count{
                let animateArr = [SKTexture.init(imageNamed: "text-new-record-pink"),SKTexture.init(imageNamed: "text-new-record-red")]
                newRecordNode = SKSpriteNode.init(texture: animateArr[0])
                newRecordNode?.zPosition = 50
                self.addChild(newRecordNode!)
                
                newRecordNode?.position = CGPoint.init(x: boardNode.frame.maxX - 25, y: boardNode.frame.maxY - 30)
                
                newRecordNode?.run(SKAction.repeatForever(SKAction.animate(with: animateArr, timePerFrame: 0.2)))
                
                newRecordNode?.run(SKAction.repeatForever(SKAction.sequence([SKAction.scale(by: 1.2, duration: 0.1),SKAction.scale(by: 10/12, duration: 0.1)])))
                
                highScoreNode.count = counterNd.count
                
            }
            
        }else{
            highScoreNode.count = counterNd.count
        }
        highScoreNode.updateCounter()
        
        self.addChild(highScoreNode)
        
        highScoreNode.position = CGPoint.init(x: currentScoreNode.position.x, y: boardNode.frame.maxY - boardNode.size.height + 49)
        
        
        self.storeHighScore(score: counterNd.count)
        
        
        
        //四个button
        
        let btnLeftX = self.frame.midX - 10
        
        let btnRightX = self.frame.midX + 10
        
        let homeBtn = ButtonNode.init(defaultText: "button-home-off", clickText: "button-home-on")
        self.addChild(homeBtn)
        
        
        homeBtn.position = CGPoint.init(x:btnLeftX  - homeBtn.button.size.width/2 , y: self.frame.midY - boardNode.size.height/2 - homeBtn.button.size.height)
        
        
        let shareBtn = ButtonNode.init(defaultText: "button-share-off", clickText: "button-share-on")
        
        shareBtn.position = CGPoint.init(x: btnRightX + shareBtn.button.size.width/2 , y: homeBtn.position.y)
        
        self.addChild(shareBtn)
        
        let reTryBtn = ButtonNode.init(defaultText: "button-retry-off", clickText: "button-retry-on")
        
        reTryBtn.position = CGPoint.init(x: btnLeftX - reTryBtn.button.size.width/2, y: homeBtn.position.y - homeBtn.button.size.height/2 - reTryBtn.button.size.height)
        
        self.addChild(reTryBtn)
        
        let rateBtn = ButtonNode.init(defaultText: "button-rate-off", clickText: "button-rate-on")
        rateBtn.position = CGPoint.init(x: btnRightX + rateBtn.button.size.width/2, y: reTryBtn.position.y)
        
        self.addChild(rateBtn)
        
        
        reTryBtn.setMethod {
            let transit = SKTransition.fade(with: UIColor.white, duration: 0.5)
            
            self.view?.presentScene(GameScene.init(size: self.size), transition: transit)
        }
        
        homeBtn.setMethod {
            let transit = SKTransition.fade(withDuration: 0.5)
            self.view?.presentScene(StartScene.init(size: self.size), transition: transit)
        }
        
        
        shareBtn.setMethod {
            let sharetext = "I just scored \(self.counterNd.count) in #KoalaHatesRain!"
            
            let activityVC = UIActivityViewController.init(activityItems: [sharetext], applicationActivities:nil)
            
            
            let rootVC = self.view?.window?.rootViewController
            
            rootVC?.present(activityVC, animated: true, completion: nil)
            
            
        }
        
        ///animation
        gameOverText.alpha = 0
        boardNode.alpha = 0
        currentScoreNode.alpha = 0
        highScoreNode.alpha = 0
        newRecordNode?.alpha = 0
        homeBtn.alpha = 0
        shareBtn.alpha = 0
        reTryBtn.alpha = 0
        rateBtn.alpha = 0
        
        let gameOverAct = SKAction.sequence([SKAction.scale(by: 2, duration: 0),SKAction.group([SKAction.fadeIn(withDuration: 0.5),SKAction.scale(by: 0.5, duration: 0.2)])])
        
        let boardNodeAct = SKAction.sequence([SKAction.wait(forDuration: 0.2),SKAction.fadeIn(withDuration: 0.5)])
        
        let scoreAct = SKAction.sequence([SKAction.wait(forDuration: 0.5),SKAction.fadeIn(withDuration: 0.3)])
        
        let buttonMoveAct = SKAction.sequence([SKAction.wait(forDuration: 0.3),SKAction.moveTo(y: homeBtn.position.y - 10, duration: 0),SKAction.group([SKAction.fadeIn(withDuration: 0.3),SKAction.moveTo(y: homeBtn.position.y, duration: 0.5)])])
        
        let downBtnMoveAct = SKAction.sequence([SKAction.wait(forDuration: 0.3),SKAction.moveTo(y: reTryBtn.position.y - 10, duration: 0),SKAction.group([SKAction.fadeIn(withDuration: 0.3),SKAction.moveTo(y: reTryBtn.position.y, duration: 0.5)])])
        
        
        self.run(SKAction.sequence([SKAction.run {
                gameOverText.run(gameOverAct)
            },SKAction.run {
                boardNode.run(boardNodeAct)
            },SKAction.run {
                currentScoreNode.run(scoreAct)
                highScoreNode.run(scoreAct)
                newRecordNode?.run(scoreAct)
            },SKAction.run {
                homeBtn.run(buttonMoveAct)
                shareBtn.run(buttonMoveAct)
                reTryBtn.run(downBtnMoveAct)
                rateBtn.run(downBtnMoveAct)
            }]))
        
        
        
    }
    
}
