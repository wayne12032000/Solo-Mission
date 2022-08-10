//
//  GameScene.swift
//  solo_mission
//
//  Created by 張世維 on 2022/1/22.
//

import SpriteKit
import GameplayKit


class GameScene_ship2: SKScene,SKPhysicsContactDelegate {
    
    
    
    let thisTurnMoneyLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    
    let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    var levelNumber = 0
    
    var livesNumber  = 50
    let livesLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    let player = SKSpriteNode(imageNamed: "Ship2")
    
    let bulletSound = SKAction.playSoundFileNamed("Machine gun.wav", waitForCompletion: false)
    
    let explosionSound = SKAction.playSoundFileNamed("Explosion.wav", waitForCompletion: false)
    
    let tapToStartLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    enum gameState{
        case preGame // when the game state is before th start of the game
        case inGame  // when the game state is during the game
        case afterGame  //when the game state is after the game
    }
    
    var currentGameState = gameState.preGame
    
    
    
    struct PhysicsCategories{
        static let None : UInt32 = 0
        static let Player : UInt32 = 0b1  //1
        static let Bullet : UInt32 = 0b10 //2
        static let Enemy : UInt32 = 0b100 //4
        
        
    }
    
    
    func random()->CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min min:CGFloat,max:CGFloat)-> CGFloat{
        return random() * (max - min) + min
    }
    
    
    var gameArea:CGRect
    
    override init(size: CGSize){
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playerableWidth = size.height / maxAspectRatio
        let margin = (size.width - playerableWidth)/2
        gameArea = CGRect(x: margin, y: 0, width: playerableWidth, height: size.height)
        super.init(size: size)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not implemented")
    }
    
    override func didMove(to view: SKView) {
        
        gameScore = 0
        
        self.physicsWorld.contactDelegate = self
        
        for i in 0...1{
            let background = SKSpriteNode(imageNamed: "background")
            background.size = self.size
            background.anchorPoint = CGPoint(x: 0.5, y: 0)
            background.position = CGPoint(x: self.size.width/2, y: self.size.height*CGFloat(i))
            background.zPosition = 0
            background.name = "Background"
            self.addChild(background)
        }
       
        player.setScale(1)
        player.position = CGPoint(x: self.size.width/2, y: 0 - self.size.height)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(player)
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width * 0.22, y: self.size.height + scoreLabel.frame.size.height)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        thisTurnMoneyLabel.text = "$\(thisTurnMoney)"
        thisTurnMoneyLabel.fontSize = 70
        thisTurnMoneyLabel.fontColor = SKColor.white
        thisTurnMoneyLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        thisTurnMoneyLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height + thisTurnMoneyLabel.frame.size.height)
        thisTurnMoneyLabel.zPosition = 100
        self.addChild(thisTurnMoneyLabel)
        
        livesLabel.text = "Lives: \(livesNumber)"
        livesLabel.fontSize = 70
        livesLabel.fontColor = SKColor.white
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        livesLabel.position = CGPoint(x: self.size.width * 0.78, y: self.size.height + livesLabel.frame.size.height)
        livesLabel.zPosition = 100
        self.addChild(livesLabel)
        
        let moveOnToScreenAction = SKAction.moveTo(y: self.size.height*0.9, duration: 0.3)
        scoreLabel.run(moveOnToScreenAction)
        livesLabel.run(moveOnToScreenAction)
        thisTurnMoneyLabel.run(moveOnToScreenAction)
        
        tapToStartLabel.text = "Tap to Begin"
        tapToStartLabel.fontSize = 100
        tapToStartLabel.fontColor = SKColor.white
        tapToStartLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        tapToStartLabel.zPosition = 1
        tapToStartLabel.alpha = 0
        self.addChild(tapToStartLabel)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        tapToStartLabel.run(fadeInAction)
    }
    
    var lastUpdateTime : TimeInterval = 0
    var deltaFrameTime : TimeInterval = 0
    var amountToMovePerSecond : CGFloat = 600.0
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime == 0{
            lastUpdateTime = currentTime
        }
        else{
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        
        let amountToMoveBackground = amountToMovePerSecond * CGFloat(deltaFrameTime)
        
        self.enumerateChildNodes(withName: "Background"){
            (background, stop) in
            if self.currentGameState == gameState.inGame{
                background.position.y -= amountToMoveBackground
            }
            if background.position.y < -self.size.height{
                background.position.y += self.size.height * 2
            }
        }
        
        
    }
    
    
    
    func startGame(){
        currentGameState = gameState.inGame
        thisTurnMoney = 0
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction,deleteAction])
        tapToStartLabel.run(deleteSequence)
        
        let moveShipOnToScreenAction = SKAction.moveTo(y: self.size.height * 0.2, duration: 0.5)
        let startLevelAction = SKAction.run(startNewLevel)
        let startGameSequence = SKAction.sequence([moveShipOnToScreenAction,startLevelAction])
        player.run(startGameSequence)
    }
    
    
    func loseLive(){
        livesNumber-=1
        livesLabel.text = "Lives: \(livesNumber)"
        
        let scaleup = SKAction.scale(to: 1.5, duration: 0.2)
        let scaledown = SKAction.scale(to: 1, duration: 0.2)
        let scalesequence = SKAction.sequence([scaleup,scaledown])
        livesLabel.run(scalesequence)
        
        if livesNumber == 0{
            runGameOver()
        }
    }
    
    
    func addMoney(){
        thisTurnMoney+=1
        thisTurnMoneyLabel.text = "+\(thisTurnMoney)"
        let scaleup = SKAction.scale(to: 1.5, duration: 0.2)
        let scaledown = SKAction.scale(to: 1, duration: 0.2)
        let scalesequence = SKAction.sequence([scaleup,scaledown])
        thisTurnMoneyLabel.run(scalesequence)
    }
    
    func addScore(){
        gameScore+=1
        scoreLabel.text = "Score: \(gameScore)"
        
        if gameScore == 10 || gameScore == 20 || gameScore == 30 || gameScore == 50{
            startNewLevel()
        }
    }
    
    func runGameOver(){
        currentGameState = gameState.afterGame
        
        self.removeAllActions()
        
        self.enumerateChildNodes(withName: "Bullet") {
            (bullet, stop) in
            bullet.removeAllActions()
        }
        self.enumerateChildNodes(withName: "Enemy") {
            (enermy, stop) in
            enermy.removeAllActions()
        }
        
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene,changeSceneAction])
        self.run(changeSceneSequence)
        
    }
    
    func changeScene(){
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo,transition: myTransition)
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            body1 = contact.bodyA
            body2 = contact.bodyB
        }else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy{
            //if the player has hit the enemy
            if body1.node != nil{
                spawnExplosion(spawnPosition: body1.node!.position)
            }
            if body2.node != nil{
                spawnExplosion(spawnPosition: body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
            runGameOver()
        }
        if( (body1.categoryBitMask == PhysicsCategories.Bullet) && (body2.categoryBitMask == PhysicsCategories.Enemy)){
            //if the bullet has hit the enemy
            // && (body2.node!.position.y <  self.size.height)
            addScore()
            addMoney()
            
            if body2.node != nil{
                spawnExplosion(spawnPosition: body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
        }
    }
    func spawnExplosion(spawnPosition: CGPoint){
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fadeout = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        
        let explosionSequence = SKAction.sequence([explosionSound,scaleIn,fadeout,delete])
        explosion.run(explosionSequence)
        
        
    }
    
    func startNewLevel(){
        
        levelNumber+=1
        
        if self.action(forKey: "spawningEnemies") != nil{
            self.removeAction(forKey: "spawningEnemies")
        }
        var levelDuration = TimeInterval()
        switch levelNumber{
        case 1 : levelDuration = 1.2
        case 2 : levelDuration = 1
        case 3 : levelDuration = 0.8
        case 4 : levelDuration = 0.5
        default:
            levelDuration=0.5
            print("Cannot find level info.")
        }
        
        let spawn = SKAction.run(spawnEnermy)
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
        let spawnsequence = SKAction.sequence([waitToSpawn,spawn])
        let spawnforever = SKAction.repeatForever(spawnsequence)
        self.run(spawnforever,withKey: "spawningEnemies")
        
        
         
    }
    
    
    
    
    func fireBullet(){
        if levelNumber == 1{
            let bullet = SKSpriteNode(imageNamed: "bullet")
            bullet.name = "Bullet"
            bullet.setScale(1)
            bullet.position = player.position
            bullet.zPosition = 1
            bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
            bullet.physicsBody!.affectedByGravity = false
            bullet.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
            
            bullet.physicsBody!.collisionBitMask = PhysicsCategories.None
            bullet.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
            self.addChild(bullet)
            
            let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
            let deleteBUllet = SKAction.removeFromParent()
            let bulletSequence = SKAction.sequence([bulletSound,moveBullet,deleteBUllet])
            bullet.run(bulletSequence)
        }else if levelNumber == 2{
            let bullet = SKSpriteNode(imageNamed: "bu2")
            bullet.name = "Bullet"
            bullet.setScale(1)
            bullet.position = player.position
            bullet.zPosition = 1
            bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
            bullet.physicsBody!.affectedByGravity = false
            bullet.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
            
            bullet.physicsBody!.collisionBitMask = PhysicsCategories.None
            bullet.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
            self.addChild(bullet)
            
            let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
            let deleteBUllet = SKAction.removeFromParent()
            let bulletSequence = SKAction.sequence([bulletSound,moveBullet,deleteBUllet])
            bullet.run(bulletSequence)
        }else if levelNumber == 3{
            let bullet = SKSpriteNode(imageNamed: "bu3")
            bullet.name = "Bullet"
            bullet.setScale(1)
            bullet.position = player.position
            bullet.zPosition = 1
            bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
            bullet.physicsBody!.affectedByGravity = false
            bullet.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
            
            bullet.physicsBody!.collisionBitMask = PhysicsCategories.None
            bullet.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
            self.addChild(bullet)
            
            let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
            let deleteBUllet = SKAction.removeFromParent()
            let bulletSequence = SKAction.sequence([bulletSound,moveBullet,deleteBUllet])
            bullet.run(bulletSequence)
        }else if levelNumber >= 4{
            let bullet = SKSpriteNode(imageNamed: "bufinal")
            bullet.name = "Bullet"
            bullet.setScale(1)
            bullet.position = player.position
            bullet.zPosition = 1
            bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
            bullet.physicsBody!.affectedByGravity = false
            bullet.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
            
            bullet.physicsBody!.collisionBitMask = PhysicsCategories.None
            bullet.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
            self.addChild(bullet)
            
            let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
            let deleteBUllet = SKAction.removeFromParent()
            let bulletSequence = SKAction.sequence([bulletSound,moveBullet,deleteBUllet])
            bullet.run(bulletSequence)
        }
                  
     
       
    }
    
    func spawnEnermy(){
        let randomXStart = random(min: gameArea.minX, max: gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX, max: gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        let enermy = SKSpriteNode(imageNamed: "enemyShip")
        enermy.name = "Enemy"
        enermy.setScale(1)
        enermy.position = startPoint
        enermy.zPosition = 2
        enermy.physicsBody = SKPhysicsBody(rectangleOf: enermy.size)
        enermy.physicsBody!.affectedByGravity = false
        enermy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enermy.physicsBody!.collisionBitMask = PhysicsCategories.None
        enermy.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
        self.addChild(enermy)
        
        let moveEnermy = SKAction.move(to: endPoint, duration: 1.3 )
        let deleteenermy = SKAction.removeFromParent()
        let losealiveaction = SKAction.run(loseLive)
        let enermysequence = SKAction.sequence([moveEnermy,deleteenermy,losealiveaction])
        
        if currentGameState == gameState.inGame{
            enermy.run(enermysequence)
        }
       
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amounttoratate = atan2(dy, dx)
        enermy.zRotation = amounttoratate
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentGameState == gameState.preGame{
            startGame()
        }else if currentGameState == gameState.inGame{
            fireBullet()
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let amountDraggedx = pointOfTouch.x - previousPointOfTouch.x
            let amountDraggedy = pointOfTouch.y - previousPointOfTouch.y
            
            if currentGameState == gameState.inGame{
                player.position.x += amountDraggedx
                player.position.y += amountDraggedy
            }
            
            
            if player.position.x > gameArea.maxX - player.size.width*2{
                player.position.x = gameArea.maxX - player.size.width*2
            }
            if player.position.x < gameArea.minX + player.size.width*2 {
                player.position.x = gameArea.minX + player.size.width*2
            }
            if player.position.y > gameArea.maxY - player.size.height*2{
                player.position.y = gameArea.maxY - player.size.height*2
            }
            if player.position.y < gameArea.minY + player.size.height/2{
                player.position.y = gameArea.minY + player.size.height/2
            }
        }
    }
}
