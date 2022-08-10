//
//  shipSelectScene.swift
//  solo_mission
//
//  Created by 張世維 on 2022/1/24.
//

import Foundation
import SpriteKit

var ownship2 = 0
var ownship3 = 0
class shipSelectScene: SKScene{
    
    let ship1Label = SKLabelNode(fontNamed: "The Bold Font")
    let ship2Label = SKLabelNode(fontNamed: "The Bold Font")
    let ship3Label = SKLabelNode(fontNamed: "The Bold Font")
    let buyShip2Label = SKLabelNode(fontNamed: "The Bold Font")
    let buyShip3Label = SKLabelNode(fontNamed: "The Bold Font")
    let GMsetLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let TopicLabel = SKLabelNode(fontNamed: "The Bold Font")
        TopicLabel.text = "Choose A Ship To Start"
        TopicLabel.fontSize = 70
        TopicLabel.fontColor = SKColor.white
        TopicLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.65)
        TopicLabel.zPosition = 1
        self.addChild(TopicLabel)
        
        let ship1 = SKSpriteNode(imageNamed: "playerShip")
        ship1.setScale(1)
        ship1.position = CGPoint(x: self.size.width*0.25, y: self.size.height*0.5)
        ship1.zPosition = 1
        self.addChild(ship1)
        
        ship1Label.text = "ship1"
        ship1Label.fontSize = 100
        ship1Label.fontColor = SKColor.white
        ship1Label.position = CGPoint(x: self.size.width*0.25, y: self.size.height*0.4)
        ship1Label.zPosition = 1
        self.addChild(ship1Label)
        
        let ship2 = SKSpriteNode(imageNamed: "Ship2")
        let ship2Shadow = SKSpriteNode(imageNamed: "explosion")
        ship2.setScale(1)
        ship2.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        ship2.zPosition = 1
        
        ship2Shadow.setScale(1)
        ship2Shadow.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        ship2Shadow.zPosition = 1
        
        if ownship2 == 1{
            self.addChild(ship2)
        }else if ownship2 == 0{
            self.addChild(ship2Shadow)
        }
        
        ship2Label.text = "ship2"
        ship2Label.fontSize = 100
        ship2Label.fontColor = SKColor.white
        ship2Label.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.4)
        ship2Label.zPosition = 1
        if ownship2 == 1{
            self.addChild(ship2Label)
        }
//for ship 3 in future
        let ship3 = SKSpriteNode(imageNamed: "bullet")
        let ship3Shadow = SKSpriteNode(imageNamed: "explosion")
        ship3.setScale(1)
        ship3.position = CGPoint(x: self.size.width*0.75, y: self.size.height*0.5)
        ship3.zPosition = 1
        
        ship3Shadow.setScale(1)
        ship3Shadow.position = CGPoint(x: self.size.width*0.75, y: self.size.height*0.5)
        ship3Shadow.zPosition = 1
        
        if ownship3 == 1{
            self.addChild(ship3)
        }else if ownship3 == 0{
            self.addChild(ship3Shadow)
        }
        
        ship3Label.text = "ship3"
        ship3Label.fontSize = 100
        ship3Label.fontColor = SKColor.white
        ship3Label.position = CGPoint(x: self.size.width*0.75, y: self.size.height*0.4)
        ship3Label.zPosition = 1
        if ownship3 == 1{
            self.addChild(ship3Label)
        }
//for ship 3 in future
        
        buyShip2Label.text = "BUY($100)"
        buyShip2Label.fontSize = 60
        buyShip2Label.fontColor = SKColor.white
        buyShip2Label.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.35)
        buyShip2Label.zPosition = 1
        if ownship2 == 0{
            self.addChild(buyShip2Label)
        }else{
            self.removeFromParent()
        }
        buyShip3Label.text = "BUY($1000)"
        buyShip3Label.fontSize = 60
        buyShip3Label.fontColor = SKColor.white
        buyShip3Label.position = CGPoint(x: self.size.width*0.75, y: self.size.height*0.35)
        buyShip3Label.zPosition = 1
        if ownship3 == 0{
            self.addChild(buyShip3Label)
        }else{
            self.removeFromParent()
        }
        
        
        let totalMoneyLabel = SKLabelNode(fontNamed: "The Bold Font")
        totalMoneyLabel.text = "$: \(totalMoney)"
        totalMoneyLabel.fontSize = 90
        totalMoneyLabel.fontColor = SKColor.white
        totalMoneyLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.8)
        totalMoneyLabel.zPosition = 1
        self.addChild(totalMoneyLabel)
        
        GMsetLabel.text = "GM Set"
        GMsetLabel.fontSize = 100
        GMsetLabel.fontColor = SKColor.white
        GMsetLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.9)
        GMsetLabel.zPosition = 1
        self.addChild(GMsetLabel)
        
    }
    func buysystem(){
        if totalMoney >= 100 && ownship2 == 0{
            totalMoney-=100
            defaults.set(totalMoney, forKey: "totalMoneySaved")
            ownship2 = 1
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            if GMsetLabel.contains(pointOfTouch){
                totalMoney = 2000
                defaults.set(totalMoney, forKey: "totalMoneySaved")
                ownship2 = 0
                ownship3 = 0
                let sceneToMoveTo = shipSelectScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo,transition: myTransition)
            }
            if buyShip2Label.contains(pointOfTouch){
                if totalMoney >= 100 && ownship2 == 0{
                    totalMoney-=100
                    defaults.set(totalMoney, forKey: "totalMoneySaved")
                    ownship2 = 1
                    let sceneToMoveTo = shipSelectScene(size: self.size)
                    sceneToMoveTo.scaleMode = self.scaleMode
                    let myTransition = SKTransition.fade(withDuration: 0.5)
                    self.view!.presentScene(sceneToMoveTo,transition: myTransition)
                }
            }
            if buyShip3Label.contains(pointOfTouch){
                if totalMoney >= 1000 && ownship3 == 0{
                    totalMoney-=1000
                    defaults.set(totalMoney, forKey: "totalMoneySaved")
                    ownship3 = 1
                    let sceneToMoveTo = shipSelectScene(size: self.size)
                    sceneToMoveTo.scaleMode = self.scaleMode
                    let myTransition = SKTransition.fade(withDuration: 0.5)
                    self.view!.presentScene(sceneToMoveTo,transition: myTransition)
                }
            }
            
            if ship1Label.contains(pointOfTouch){
                
                let sceneToMoveTo = GameScene_ship1(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo,transition: myTransition)
            }
            
            if ownship2 == 1{
                if ship2Label.contains(pointOfTouch){
                    let sceneToMoveTo = GameScene_ship2(size: self.size)
                    sceneToMoveTo.scaleMode = self.scaleMode
                    let myTransition = SKTransition.fade(withDuration: 0.5)
                    self.view!.presentScene(sceneToMoveTo,transition: myTransition)
                }
            }
            if ownship3 == 1{
                if ship3Label.contains(pointOfTouch){
                    let sceneToMoveTo = GameScene_ship3(size: self.size)
                    sceneToMoveTo.scaleMode = self.scaleMode
                    let myTransition = SKTransition.fade(withDuration: 0.5)
                    self.view!.presentScene(sceneToMoveTo,transition: myTransition)
                }
            }
            
        }
    }
    
}
