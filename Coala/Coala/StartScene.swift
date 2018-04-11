//
//  StartScene.swift
//  Coala
//
//  Created by nidangkun on 2017/9/8.
//  Copyright © 2017年 nidangkun. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class StartScene: SKScene {
    
    //var bgMusic : AVAudioPlayer!
    
    let defaultUser = UserDefaults.standard

    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.white
        
        
        
        
        let bgTexture = SKTexture.init(imageNamed: "background")
        
        let bgNode = SKSpriteNode.init(texture: bgTexture)
        
        if #available(iOS 10.0, *) {
            bgNode.scale(to: CGSize.init(width: ScreenWidth, height: ScreenHeight))
        } else {
            bgNode.size = CGSize.init(width: ScreenWidth, height: ScreenHeight)
        }
        
        bgNode.position = CGPoint.init(x: self.frame.midX, y: self.frame.midY)
        
        self.addChild(bgNode)
        
        let logoTexture = SKTexture.init(imageNamed: "text-logo")
        
        let logoNode = SKSpriteNode.init(texture: logoTexture)
        
        logoNode.position = CGPoint.init(x: self.frame.midX, y: self.frame.maxY - 200)
        
        self.addChild(logoNode)
        
        
        logoNode.run(SKAction.repeatForever(SKAction.sequence([SKAction.moveBy(x: 0, y: -10, duration: 0.3),SKAction.moveBy(x: 0, y: 10, duration: 0.3)])))
        
        
        /*
        let startBtnDefalut = SKTexture.init(imageNamed: "button-start-off")
        
        let startBtnClicked = SKTexture.init(imageNamed: "button-start-on")
        */
        
        let startBtnNode = ButtonNode.init(defaultText: "button-start-off", clickText: "button-start-on")
    
        startBtnNode.setMethod {
            self.fuck()
        }
        
        startBtnNode.position = CGPoint.init(x: self.frame.midX, y: self.frame.minY + startBtnNode.size.height + 100)
        
        //startBtnNode.anchorPoint = CGPoint.init(x: 1, y: 1)
        
        self.addChild(startBtnNode)
        
        //startBtnNode.run(SKAction.repeatForever(SKAction.sequence([SKAction.moveBy(x: 80, y: 0, duration: 2),SKAction.moveBy(x: -80, y: 0, duration: 2)])))
        
        
        let music = ButtonNode.init(defaultText: "button-music-off", clickText: "button-music-on")
        self.addChild(music)
        
        music.position = CGPoint.init(x: self.frame.midX, y: startBtnNode.position.y + 60)
        
        music.setMethod {
            self.switchMusic()
        }
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        buttonActionBegan(node: self, touches: touches, event: event!)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        buttonActionEnded(node: self, touches: touches, event: event!)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    
    
    func fuck(){
        let transit = SKTransition.fade(withDuration: 0.5)
        let game = GameScene.init(size: self.size)
        
        self.view?.presentScene(game, transition: transit)
        
    }
    
    func switchMusic(){
//        let defalut = UserDefaults.standard
        let sound = defaultUser.object(forKey: Sound) as! Bool
        
        let viewcontroller = self.view?.window?.rootViewController as? ViewController
        
        
        
        if (sound) == true {
            
            do{
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
                
                viewcontroller?.bgMusic.stop()
                
                defaultUser.setValue(false, forKey: Sound)
                
            }catch( _){
                
            }
        }else{
            do{
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategorySoloAmbient)
                
                viewcontroller?.bgMusic.play()
                
                defaultUser.setValue(true, forKey: Sound)
                
            }catch( _){
                
            }
        }
    }
    
   
    
   
}
