//
//  ButtonNode.swift
//  Coala
//
//  Created by nidangkun on 2017/9/11.
//  Copyright © 2017年 nidangkun. All rights reserved.
//

import UIKit
import SpriteKit


private let buttonAction = "button-touched"


class ButtonNode: SKSpriteNode {
    
    var defaultImgTxt : String!
    var clickImgTxt : String!
    
    var clickBlock : clickBlock?
    
    var button : SKSpriteNode!
    

    convenience init(defaultText:String,clickText : String) {
        self.init()
        
        defaultImgTxt = defaultText
        
        clickImgTxt = clickText
        
        button = SKSpriteNode.init(texture: SKTexture.init(imageNamed: defaultText))
        
        self.addChild(button)
        
        
        button.run(SKAction.repeatForever(SKAction.animate(with: [SKTexture.init(imageNamed: defaultText)], timePerFrame: 10, resize: true, restore: true)), withKey: "button-default")
        
        
    }
    
    // 当一个闭包作为参数传到一个函数中，但是这个闭包在函数返回之后才被执行，我们称该闭包从函数中逃逸
    
    func setMethod(block : @escaping clickBlock){
        
        clickBlock = block
    
    }
    
    func didButtonTouched(){
        
        if (button.action(forKey: buttonAction) != nil){
            button.removeAction(forKey: buttonAction)
        }
        button.run((SKAction.repeatForever(SKAction.animate(with: [SKTexture.init(imageNamed: clickImgTxt)], timePerFrame: 10.0, resize: true, restore: true))), withKey: buttonAction)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.run(SKAction.playSoundFileNamed("button-in.m4a", waitForCompletion: false))
        self.didButtonTouched()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (button.action(forKey: buttonAction) != nil){
            self.run(SKAction.playSoundFileNamed("button-out.m4a", waitForCompletion: false))
            if (clickBlock != nil){
                clickBlock!()
            }
        }
        self.removeButtonKey()
    }
    
    func removeButtonKey(){
        button.removeAction(forKey: buttonAction)
    }
    
    
}

fileprivate func isButtonPressed (array:(Array<Any>)) -> Bool{
    
    for item in array {
        if item is ButtonNode{
            //print("item===>>>\(item)")
            let button = item as! ButtonNode
            if (button.button.action(forKey: buttonAction) != nil){
                return true
            }
        }
    }

    return false
    
}

fileprivate func removeButtonKey (array:(Array<Any>)){
    
    for item in array {
        if item is ButtonNode{
            //print("item===.>>>>\((item as AnyObject).classForCoder)")
            let button = item as! ButtonNode
            button.button.removeAction(forKey: buttonAction)
        }
    }
}


public func buttonActionBegan (node : SKScene,  touches : Set<UITouch> , event: UIEvent ){
    
    if !isButtonPressed(array: node.children){
        let touch = ((touches as NSSet).anyObject() as AnyObject)
        
        let location = touch.location(in: node)
        
        let targetNode = node.atPoint(location)
        
        if node == targetNode.parent{
            targetNode.touchesBegan(touches, with: event)
        }else{
            targetNode.parent?.touchesBegan(touches, with: event)
        }
    }
    
}

public func buttonActionEnded (node : SKScene,  touches : Set<UITouch> , event: UIEvent ){
    let touch = ((touches as NSSet).anyObject() as AnyObject)
    
    let location = touch.location(in: node)
    let targetNode = node.atPoint(location)
    
    if node == targetNode.parent{
        targetNode.touchesEnded(touches, with: event)
    }else{
        targetNode.parent?.touchesEnded(touches, with: event)
    }
    removeButtonKey(array: node.children)
    
}

public func buttonActionMoved (node : SKScene,  touches : Set<UITouch> , event: UIEvent ){
    
}
