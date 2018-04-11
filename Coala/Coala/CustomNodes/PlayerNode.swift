//
//  PlayerNode.swift
//  Coala
//
//  Created by nidangkun on 2017/9/13.
//  Copyright © 2017年 nidangkun. All rights reserved.
//

import UIKit
import SpriteKit

public let playerCategory : UInt32 = 1 << 1

public let rainCategory : UInt32 = 1 << 2

class PlayerNode: SKSpriteNode {
    
    let playerMoving = "player-moving"
    
    let playerMoved = "player-moved"
    
    let endedAct = "endedAct"
    
    var isALive = true
    
    var animateTextures : Array<SKTexture>!
    
    var defalutTexture : String!
    
    var moveDirection : CGVector!
    
    var currentDirection :CGVector!
    
    var player : SKSpriteNode!
    
    var endedTexture : SKTexture!
    
    var endedExtraTexture : SKTexture!
    
    var clickLocation = CGPoint.zero
    
    var lastUpdateTime : TimeInterval = 0
    
    var lastWalkTime : TimeInterval  = 0
    
    var differ = CGFloat(0)
    
    convenience init(defaultTxt:String , animateTexture:Array<SKTexture>){
        //self.init()
        
        self.init(texture: SKTexture.init(imageNamed: defaultTxt))
        
        defalutTexture = defaultTxt
        
        animateTextures = animateTexture
        
        moveDirection = CGVector.init(dx: 0, dy: 0)
        
        currentDirection = CGVector.init(dx: 0, dy: 0)
        
        //player = SKSpriteNode.init(texture: SKTexture.init(imageNamed: defaultTxt))
        
        
        //self.addChild(player)
        
        var size = self.size
        
        size.width /= 2
        
        size.height /= 2
 
        
        self.physicsBody = SKPhysicsBody.init(rectangleOf: size, center: self.position)
        
        self.physicsBody?.categoryBitMask = playerCategory
        
        //self.physicsBody?.collisionBitMask = 0
        
        self.physicsBody?.contactTestBitMask = rainCategory
        
        self.physicsBody?.usesPreciseCollisionDetection = true
        
        self.physicsBody?.isDynamic = true
        
        self.physicsBody?.allowsRotation = true
        
        endedTexture = SKTexture.init(imageNamed: "koala-wet")
        
        endedExtraTexture = SKTexture.init(imageNamed: "wet")
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if isALive {
            self.updateDirection(touch: touches)
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isALive {
            self.stop()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isALive {
            self.updateDirection(touch: touches)
        }
    }
    
    func updateDirection (touch : Set<UITouch>){
        
        //print("parent==>>>\(String(describing: self.parent))")
        
        let touches = ((touch as NSSet).anyObject() as AnyObject)
        
        let location = touches.location(in: self.parent!)
        
        //print("location.x==>>>>\(location.x),self.position.x===>>>\(self.position.x)")
        
        if location.x > self.position.x{
            moveDirection.dx = 1.0
            
            
            
        }else if location.x < self.position.x{
            moveDirection.dx = -1.0
            
            //differ = abs(location.x - self.position.x) + self.size.width
        }
        
        //print("moveDirection===>>>>\(moveDirection.dx)")
        
        differ = abs(location.x - self.position.x)
        
        clickLocation = location
        
      
    }
    
    func update( currentTime : TimeInterval){
        
        ///每次的时间间隔
        var updateTime = currentTime - lastUpdateTime
        
        lastUpdateTime = currentTime

        if updateTime > 1.0{
            
            updateTime = 1.0/60.0
        }
        
        if isALive{
            self.checkLocation(time: updateTime)
        }
    
    }
    
    func checkLocation( time : TimeInterval){
        lastWalkTime += time
        if time >= 1.0/60.0 {
            lastWalkTime = 0
            
            ///移动方向 和触摸方向相反 ,先停止,currentDirection会设置为0
            ///总之移动到一个地方，会先停止在第一次停止点， 再执行move
            
            //print("currentDirection.dx===>>>\(currentDirection.dx),moveDirection.dx==>>>\(moveDirection.dx)")
            
            //print("clickLocation==>>>>\(clickLocation.x),self.position.x===>>>\(self.position.x)")
            if currentDirection.dx != moveDirection.dx && moveDirection.dx != 0 {
                self.move()
            }else if( currentDirection.dx > 0 && self.position.x > clickLocation.x || currentDirection.dx < 0 && self.position.x < clickLocation.x || moveDirection.dx == 0 && currentDirection.dx != 0){
                self.stop()
            }
            
        }
        
    }
    
    
    
    func end(){
        isALive = false
        
        self.run(SKAction.playSoundFileNamed("wet.m4a", waitForCompletion: false))
        
        if (endedTexture != nil){
            self.run(SKAction.animate(with: [endedTexture], timePerFrame: 0.1), withKey: endedAct)
        }
        
        if (endedExtraTexture != nil){
            
            let dotNd = SKSpriteNode.init(texture: endedExtraTexture)
            
            self.addChild(dotNd)
            
            dotNd.alpha = 0
            
            dotNd.run(SKAction.sequence([SKAction.scale(by: 0.1, duration: 0),SKAction.group([SKAction.fadeIn(withDuration: 0.1),SKAction.scale(by: 20, duration: 0.2)]),SKAction.fadeOut(withDuration: 0.4),SKAction.run {
                    dotNd.removeFromParent()
                }]))
        }
        
        self.stop()
        
    }
    
    func addMoveAciton(){
        if (self.action(forKey: playerMoving) != nil) {
            self.removeAction(forKey: playerMoving)
        }
        
        self.run((SKAction.repeatForever(SKAction.animate(with: animateTextures, timePerFrame: 0.1, resize: true, restore: true))), withKey: playerMoving)
        
    }
    
    func move(){
        
        // t = s/v
        if differ > self.size.width/3 {
        
            self.addMoveAciton()
            
            //改变方向
            if moveDirection.dx * self.xScale < 0{
                self.xScale = -self.xScale
            }
            
            //let moveDuration = differ / (ScreenWidth/1.3)
            
            var targetP : CGFloat!
            
            if moveDirection.dx > 0{
                targetP = ScreenWidth
            }else{
                targetP = 0
            }
            
            //print("self.position.x===>>>\(self.position.x)")
            
            //这样会有移动卡顿的感觉， 就让熊匀速移动。
            //let moveAction = SKAction.moveTo(x: clickLocation.x, duration: TimeInterval(moveDuration))
            
            //let csPointX = self.position.x - ScreenWidth/2
            
            let moveDuration = abs(targetP - self.position.x) / (ScreenWidth/1.3)
            
            let moveAction = SKAction.moveTo(x: targetP, duration: TimeInterval(moveDuration))
            
        
            self.run(SKAction.sequence([moveAction,SKAction.run {
                self.stop()
            }]), withKey: playerMoved)
            
            currentDirection = moveDirection
            
        }
        
    }
    
    func stop(){
        differ = 0
        
        currentDirection.dx = 0
        
        moveDirection.dx = 0
        
        self.removeAction(forKey: playerMoving)
        self.removeAction(forKey: playerMoved)
        
    }
    
    
    
    
    
}
