//
//  GameOverScene.swift
//  solo_mission
//
//  Created by 張世維 on 2022/1/23.
//

import Foundation
import SpriteKit
let defaults = UserDefaults()
var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
var totalMoney = defaults.integer(forKey: "totalMoneySaved")

class GameOverScene: SKScene{
    let restartLabel = SKLabelNode(fontNamed: "The Bold Font")
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameOverLabel = SKLabelNode(fontNamed: "The Bold Font")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 150
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = 125
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.55)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        
        
        if gameScore > highScoreNumber{
            highScoreNumber = gameScore
            defaults.set(highScoreNumber,forKey: "highScoreSaved")
        }
        totalMoney += thisTurnMoney
        defaults.set(totalMoney, forKey: "totalMoneySaved")
        thisTurnMoney = 0
        
        let highScoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        highScoreLabel.text = "High Score: \(highScoreNumber)"
        highScoreLabel.fontSize = 125
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.45)
        highScoreLabel.zPosition = 1
        self.addChild(highScoreLabel)
        
        let totalMoneyLabel = SKLabelNode(fontNamed: "The Bold Font")
        totalMoneyLabel.text = "$: \(totalMoney)"
        totalMoneyLabel.fontSize = 90
        totalMoneyLabel.fontColor = SKColor.white
        totalMoneyLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.15)
        totalMoneyLabel.zPosition = 1
        self.addChild(totalMoneyLabel)
        
        
        restartLabel.text = "Restart"
        restartLabel.fontSize = 90
        restartLabel.fontColor = SKColor.white
        restartLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.3)
        restartLabel.zPosition = 1
        self.addChild(restartLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            if restartLabel.contains(pointOfTouch){
                let sceneToMoveTo = shipSelectScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo,transition: myTransition)
            }
        }
    }
    
}
