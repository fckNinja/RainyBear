//
//  GuideNode.swift
//  Coala
//
//  Created by nidangkun on 2017/9/13.
//  Copyright © 2017年 nidangkun. All rights reserved.
//

import UIKit
import SpriteKit


class GuideNode: SKSpriteNode {
    
    var ifClicked = false
    
    var clickBlock : clickBlock?
    
    var  titleNode : SKSpriteNode!
    var indicatorNode : SKSpriteNode!
    
    convenience init (title:String , indicator:String ){
        self.init()
        
        titleNode = SKSpriteNode.init(texture: SKTexture.init(imageNamed: title))
        self.addChild(titleNode)
        
        titleNode.position = CGPoint.init(x: 0, y: 80)
        
        indicatorNode = SKSpriteNode.init(texture: SKTexture.init(imageNamed: indicator))
        self.addChild(indicatorNode)
        
        indicatorNode.position = CGPoint.init(x: 0, y: -120)
        
        indicatorNode.run(SKAction.repeatForever(SKAction.sequence([SKAction.moveTo(x: -100, duration: 1),SKAction.moveTo(x: 100, duration: 1)])))
        
    }
    
    func setBlockMethod (block : @escaping () -> ()){
        
        clickBlock = block
        
    }
    
    func didGuide(){
        
        ifClicked = true
        
        let fadeAct = SKAction.fadeOut(withDuration: 0.3)
        let removeAct = SKAction.removeFromParent()
        
        titleNode.run(SKAction.sequence([fadeAct,removeAct]))
        
        indicatorNode.run(SKAction.sequence([fadeAct,removeAct]))
        
        if (clickBlock != nil){
            clickBlock!()
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !ifClicked{
            self.didGuide()
        }
    }
    
    
}


