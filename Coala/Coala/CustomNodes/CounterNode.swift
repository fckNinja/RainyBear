//
//  CounterNode.swift
//  Coala
//
//  Created by nidangkun on 2017/9/15.
//  Copyright © 2017年 nidangkun. All rights reserved.
//

import UIKit
import SpriteKit


class CounterNode: SKNode {
    ///所有数字的数组
    var numbersArray : Array<SKTexture>!

    //var scoreBG : SKSpriteNode!

    //分数
    var count : Int = 0
    
    var numbersNode = [SKSpriteNode]()
    
    
    var showNumArray = [Int]()

    convenience init(number:Int){
        self.init()
 
        numbersArray = [SKTexture]()
        
        count = number
        
        //showNumber = SKSpriteNode.init()
        
        for i in 0 ... 9 {
            let textName = "num-" + String(i)
            
            let tmpTexture = SKTexture.init(imageNamed: textName)
            
            numbersArray.append(tmpTexture)
        }
        
        self.addNumber(num: number, index: 0)
        
    }
    
    
    func increase(){
        count += 1
        
        self.updateCounter()
    }
    

    
    func updateCounter(){
        
        var displayNum = count
        
        ///把数字截取 成 如[1,2,3] 的数组 
        
        //print("displayNum===>>>\(displayNum)")
        
        showNumArray.removeAll()
        
        while displayNum != 0 {
            
            let digit = displayNum % 10
            
            displayNum /= 10
            
            showNumArray.append(digit)
            
        }
        
        for (index,value) in  showNumArray.enumerated(){
            //let value = tmpArray[index]
            self.addNumber(num: value, index: index)
        }
        
        
        
    }
    
    func addNumber(num:Int ,index:Int){
        //移除第一位数后面的数字
        if  showNumArray.count == 1{
            //scoreBG.removeAllChildren()
            
            for node in self.children{
                if node.name == "number"{
                    node.removeFromParent()
                }
            }
            
        }else if numbersNode.count >= 2 {
            let showNode = numbersNode[index]
            showNode.removeFromParent()
            if  !numbersNode.isEmpty  {
                numbersNode.remove(at: index)
            }
        }
    
        let numTxt = numbersArray[num]
        
        let showNumber = SKSpriteNode.init(texture: numTxt)
        showNumber.name = "number"
        self.addChild(showNumber)
        
        //print("showNumber==>>>>\(showNumber.size.width)")
        
        let numGap = CGFloat(52/2 + 2)
        
        showNumber.position = CGPoint.init(x:  -numGap * CGFloat((index+1)), y: 0)
        
        showNumber.run(self.showAction())
        
        numbersNode.insert(showNumber, at: index)
        
       
    }
    
    func showAction() -> SKAction{
        let scale = SKAction.group([SKAction.scale(by: 1.1, duration: 0),SKAction.scale(by: 1, duration: 0.2)])
        return scale
        
    }
    
}
