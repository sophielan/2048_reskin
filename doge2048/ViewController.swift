//
//  ViewController.swift
//  doge2048
//
//  Created by Sophie Lan on 11/27/16.
//

import UIKit
import FontAwesome
// import FLAnimatedImage


class ViewController: UIViewController {
    
    let tilesInRow = 4
    let padding = 5
    let yOffset = 100
    var tileSize : Int!
    var tileCenterPositionArray = [Int]()
    
    var gameBackground: UIView!
    var gameEndLabel: UILabel!
    var scoreCounterLabel: UILabel!
    var newGameButton: UIButton!
    var undoButton: UIButton!
    var swipeUp: UISwipeGestureRecognizer!
    var swipeDown: UISwipeGestureRecognizer!
    var swipeLeft: UISwipeGestureRecognizer!
    var swipeRight: UISwipeGestureRecognizer!
    
    var scoreCounter = Int()
    var wonGame = Bool()
    var undoWasPressed = Bool()
    
    var tiles = [[Int]]()
    var tileViews = [[Any]]()
    var oldTiles = [[Int]]()
    var notCombined = [[Bool]]()
    var direction = String()
    var numToImageDictionary = [Int: [UIImage]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = .white
        
        initializeVariables()
        addLayoutViews()
        
        startGame()
        
    }
    
    func initializeVariables() {
        tileSize = (Int(view.frame.width) - padding * (tilesInRow + 3)) / tilesInRow
        for i in 1...tilesInRow {
            tileCenterPositionArray.append((i + 1) * padding + (i - 1) * tileSize + tileSize / 2)
        }
        numToImageDictionary[2] = [UIImage(named: "doge2-1")!, UIImage(named: "doge2-1")!, UIImage(named: "doge2-1")!, UIImage(named: "doge2-1")!, UIImage(named: "doge2-2")!]
        numToImageDictionary[4] = [UIImage(named: "doge4")!]
        numToImageDictionary[8] = [UIImage(named: "doge8")!]
        numToImageDictionary[16] = [UIImage(named: "doge16")!]
        numToImageDictionary[32] = [UIImage(named: "doge32-1")!, UIImage(named: "doge32-2")!]
        numToImageDictionary[64] = [UIImage(named: "doge64")!]
        numToImageDictionary[128] = [UIImage(named: "doge128-1")!, UIImage(named: "doge128-2")!]
        numToImageDictionary[256] = [UIImage(named: "doge256-1")!, UIImage(named: "doge256-2")!]
        numToImageDictionary[512] = [UIImage(named: "doge512")!]
        numToImageDictionary[1024] = [UIImage(named: "doge1024")!]
        numToImageDictionary[2048] = [UIImage(named: "doge2048-1")!, UIImage(named: "doge2048-2")!, UIImage(named: "doge2048-3")!, UIImage(named: "doge2048-4")!, UIImage(named: "doge2048-5")!]
        resetVariables()
    }
    
    func resetTilesData() -> [[Int]] {
        var tileRow = [Int]()
        var tiles = [[Int]]()
        for _ in 1...tilesInRow {
            tileRow.append(0)
        }
        for _ in 1...tilesInRow {
            tiles.append(tileRow)
        }
        return tiles
    }
    
    func addLayoutViews() {
        gameBackground = UIView(frame: CGRect(x: padding, y: yOffset + padding, width: tileSize * 4 + padding * 5, height:  tileSize * 4 + padding * 5))
        gameBackground.backgroundColor = .black
        gameBackground.clipsToBounds = true
        gameBackground.layer.cornerRadius = 5
        view.addSubview(gameBackground)
        
        for y in 0...(tilesInRow - 1) {
            for x in 0...(tilesInRow - 1) {
                let tileBackground = UIView(frame: CGRect(x: 0, y: 0, width: tileSize, height: tileSize))
                tileBackground.center = CGPoint(x: tileCenterPositionArray[x], y: tileCenterPositionArray[y] + yOffset)
                tileBackground.backgroundColor = .white
                tileBackground.alpha = 0.15
                tileBackground.clipsToBounds = true
                tileBackground.layer.cornerRadius = 5
                view.addSubview(tileBackground)
            }
        }
        
        let titleLabel = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width * 0.75, height: 65))
        titleLabel.frame.origin.y = gameBackground.frame.origin.y - CGFloat(padding) * 2 - titleLabel.frame.height
        titleLabel.text = "2048"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 47.0)
        view.addSubview(titleLabel)
        
        let scoreBackground = UIView(frame: CGRect(x: 0, y: 0, width: tileSize + 4 * padding, height: 65))
        scoreBackground.frame.origin.x = gameBackground.frame.origin.x + gameBackground.frame.width - scoreBackground.frame.width
        scoreBackground.frame.origin.y = gameBackground.frame.origin.y - CGFloat(padding) * 2 - scoreBackground.frame.height
        scoreBackground.backgroundColor = .black
        scoreBackground.clipsToBounds = true
        scoreBackground.layer.cornerRadius = 5
        view.addSubview(scoreBackground)
        
        let scoreLabel = UILabel(frame: CGRect(x: scoreBackground.frame.origin.x + CGFloat(padding), y: scoreBackground.frame.origin.y + CGFloat(padding), width: scoreBackground.frame.width - 2 * CGFloat(padding), height: scoreBackground.frame.height / 3))
        scoreLabel.text = "SCORE"
        scoreLabel.textAlignment = .center
        scoreLabel.textColor = .white
        scoreLabel.font = scoreLabel.font.withSize(15)
        view.addSubview(scoreLabel)
        
        scoreCounterLabel = UILabel(frame: CGRect(x: scoreLabel.frame.origin.x, y: scoreLabel.frame.origin.y + scoreLabel.frame.height + 0.5 * CGFloat(padding), width: scoreLabel.frame.width, height: scoreBackground.frame.height - scoreLabel.frame.height - 3 * CGFloat(padding)))
        scoreCounterLabel.textAlignment = .center
        scoreCounterLabel.textColor = .white
        scoreCounterLabel.font = UIFont.boldSystemFont(ofSize: 30.0)
        view.addSubview(scoreCounterLabel)
        
        newGameButton = UIButton(frame: CGRect(x: 0, y: scoreBackground.frame.origin.y, width: (scoreBackground.frame.height - CGFloat(padding)) / 2, height: (scoreBackground.frame.height - CGFloat(padding)) / 2))
        newGameButton.frame.origin.x = scoreBackground.frame.origin.x - CGFloat(padding) - newGameButton.frame.width
        newGameButton.backgroundColor = .black
        newGameButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        newGameButton.clipsToBounds = true
        newGameButton.layer.cornerRadius = 5
        newGameButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 18.0)
        newGameButton.setTitle(String.fontAwesomeIcon(name: .refresh), for: .normal)
        view.addSubview(newGameButton)
        
        undoButton = UIButton(frame: CGRect(x: newGameButton.frame.origin.x, y: newGameButton.frame.origin.y + newGameButton.frame.height + CGFloat(padding), width: newGameButton.frame.width, height: newGameButton.frame.height))
        undoButton.backgroundColor = .black
        undoButton.clipsToBounds = true
        undoButton.layer.cornerRadius = 5
        undoButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 18.0)
        undoButton.setTitle(String.fontAwesomeIcon(name: .undo), for: .normal)
        view.addSubview(undoButton)
        
        gameEndLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.75, height: CGFloat(tileSize)))
        gameEndLabel.center = CGPoint(x: view.frame.width / 2, y: gameBackground.frame.height + gameBackground.frame.origin.y + CGFloat(padding) * 2 + gameEndLabel.frame.height / 2)
        gameEndLabel.font = UIFont.boldSystemFont(ofSize: 45.0)
        gameEndLabel.textAlignment = .center
        gameEndLabel.alpha = 0
    }
    
    func startGame() {
        newGameButton.setTitleColor(.white, for: .normal)
        newGameButton.titleLabel?.layer.removeAllAnimations()
        undoButton.setTitleColor(.gray, for: .normal)
        undoButton.addTarget(self, action: #selector(undoLastStep), for: .touchUpInside)
        clearAllTiles()
        resetVariables()
        scoreCounterLabel.text = String(scoreCounter)
        addSwipeRecognizers()
        gameEndLabel.removeFromSuperview()
        
        addTileToRandomPlace()
        addTileToRandomPlace()
    }
    
    func undoLastStep() {
        if !(oldTiles.isEmpty) && !undoWasPressed {
            tiles = oldTiles
            clearAllTiles()
            tileViews = resetTilesData()
            for y in 0...(tilesInRow - 1) {
                for x in 0...(tilesInRow - 1) {
                    if tiles[y][x] != 0 {
                        createTile(emptySpace: [x, y], startingValue: tiles[y][x], image: numToImage(num: tiles[y][x]))
                    }
                }
            }
        }
        undoWasPressed = true
        undoButton.setTitleColor(.gray, for: .normal)
    }
    
    func resetVariables() {
        scoreCounter = 0
        wonGame = false
        tiles = resetTilesData()
        tileViews = resetTilesData()
        notCombined = resetNotCombined()
    }
    
    func clearAllTiles() {
        for tileViewRow in tileViews {
            for tv in tileViewRow {
                if let tileView = tv as? UIImageView {
                    tileView.removeFromSuperview()
                }
            }
        }
    }
    
    func addSwipeRecognizers() {
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        view.addGestureRecognizer(swipeRight)
        
        swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        view.addGestureRecognizer(swipeDown)
        
        swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        view.addGestureRecognizer(swipeUp)
        
        swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        view.addGestureRecognizer(swipeLeft)
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                direction = "r"
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
                direction = "d"
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
                direction = "l"
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
                direction = "u"
            default:
                break
            }
            updateGame()
            print(tiles)
        }
    }
    
    func updateGame() {
        oldTiles = tiles
        moveTiles()
        if tilesChanged() {
            addTileToRandomPlace()
            undoWasPressed = false
            undoButton.setTitleColor(.white, for: .normal)
        }
        notCombined = resetNotCombined()
        
        if wonGame {
            endGame(message: "You Win!")
        } else if lostGame() {
            endGame(message: "You Lose!")
        }
    }
    
    func moveTiles() {
        if direction == "r" {
            for x in stride(from: tilesInRow - 2, through: 0, by: -1) {
                for y in 0...(tilesInRow - 1) {
                    if tiles[y][x] != 0 {
                        moveTile(x: x, y: y, start: x + 1, end: tilesInRow - 1, increment: 1)
                    }
                }
            }
        } else if direction == "l" {
            for x in 1...(tilesInRow - 1) {
                for y in 0...(tilesInRow - 1) {
                    if tiles[y][x] != 0 {
                        moveTile(x: x, y: y, start: x - 1, end: 0, increment: -1)
                    }
                }
            }
            
        } else if direction == "u" {
            for y in 1...(tilesInRow - 1) {
                for x in 0...(tilesInRow - 1) {
                    if tiles[y][x] != 0 {
                        moveTile(x: x, y: y, start: y - 1, end: 0, increment: -1)
                    }
                }
            }
        } else if direction == "d" {
            for y in stride(from: tilesInRow - 2, through: 0, by: -1) {
                for x in 0...(tilesInRow - 1) {
                    if tiles[y][x] != 0 {
                        moveTile(x: x, y: y, start: y + 1, end: tilesInRow - 1, increment: 1)
                    }
                }
            }
        }
    }
    
    func tilesChanged() -> Bool {
        var changed = true
        for y in 0...(tilesInRow - 1) {
            changed = changed && (oldTiles[y] == tiles[y])
        }
        changed = !changed
        return changed
    }
    
    func resetNotCombined() -> [[Bool]] {
        var notCombinedRow = [Bool]()
        var notCombinedTable = [[Bool]]()
        for _ in 1...tilesInRow {
            notCombinedRow.append(true)
        }
        for _ in 1...tilesInRow {
            notCombinedTable.append(notCombinedRow)
        }
        return notCombinedTable
    }
    
    func lostGame() -> Bool {
        if tilesAreFilled() {
            if noPossibleMoves() {
                return true
            }
        }
        return false
    }
    
    func endGame(message: String) {
        view.removeGestureRecognizer(swipeRight)
        view.removeGestureRecognizer(swipeLeft)
        view.removeGestureRecognizer(swipeUp)
        view.removeGestureRecognizer(swipeDown)
        
        for tileRow in tileViews {
            for t in tileRow {
                if let tile = t as? UIImageView {
                    UIView.animate(withDuration: 0.5) {
                        tile.alpha = 0.5
                    }
                }
            }
        }
        gameEndLabel.text = message
        view.addSubview(gameEndLabel)
        UIView.animate(withDuration: 0.5, animations: {
            self.gameEndLabel.alpha = 1
        })
        undoButton.setTitleColor(.gray, for: .normal)
        newGameButton.setTitleColor(.yellow, for: .normal)
        
        undoButton.removeTarget(self, action: #selector(undoLastStep), for: .touchUpInside)
        UIView.animate(withDuration: 0.2, delay: 0.0, options:[UIViewAnimationOptions.repeat, UIViewAnimationOptions.autoreverse], animations: {
            self.newGameButton.titleLabel?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: nil)
        
    }
    
    func tilesAreFilled() -> Bool {
        let emptySpaces = getEmptySpaces()
        return emptySpaces.count == 0
    }
    
    func noPossibleMoves() -> Bool {
        for y in 0...(tilesInRow - 1) {
            for x in 0...(tilesInRow - 1) {
                let tile = tiles[y][x]
                var tileUp : Bool
                var tileDown : Bool
                var tileRight : Bool
                var tileLeft : Bool
                if x == 0 {
                    tileLeft = false
                } else {
                    tileLeft = tiles[y][x - 1] == tile
                }
                if y == 0 {
                    tileUp = false
                } else {
                    tileUp = tiles[y - 1][x] == tile
                }
                if x == tilesInRow - 1 {
                    tileRight = false
                } else {
                    tileRight = tiles[y][x + 1] == tile
                }
                if y == tilesInRow - 1 {
                    tileDown = false
                } else {
                    tileDown = tiles[y + 1][x] == tile
                }
                if tileUp || tileDown || tileRight || tileLeft {
                    return false
                }
            }
        }
        return true
    }
    
    func moveTile(x: Int, y: Int, start: Int, end: Int, increment: Int) {
        let newPos = getNewPosition(x: x, y: y, start: start, end: end, increment: increment)
        if newPos[2] == 1 { // if tile should be combined
            combineTile(oldX: x, oldY: y, newX: newPos[0], newY: newPos[1])
        } else if newPos[2] == 0 { // if tile should be updated
            updateTile(oldX: x, oldY: y, newX: newPos[0], newY: newPos[1])
        }
    }
    
    func getNewPosition(x: Int, y: Int, start: Int, end: Int, increment: Int) -> [Int] {
        // returns a list of integers in format [new x position of tile, new y position of tile, whether tile should be updated, combined, or kept the same]
        
        // check if tile should be combind
        var t = start
        var tileValue = 0
        while tileValue == 0 && (end - t) * increment >= 0 {
            if direction == "r" || direction == "l" {
                tileValue = tiles[y][t]
            } else if direction == "u" || direction == "d" {
                tileValue = tiles[t][x]
            }
            t += increment
        }
        if tileValue == tiles[y][x] {
            if (direction == "r" || direction == "l") && notCombined[y][t - increment] {
                return [t - increment, y, 1]
            } else if (direction == "u" || direction == "d") && notCombined[t - increment][x] {
                return [x, t - increment, 1]
            }
        }
        
        // if not move the tile to farthest empty spot
        for t in stride(from: end, through: start, by: -1 * increment) {
            if direction == "r" || direction == "l" {
                if tiles[y][t] == 0 {
                    return [t, y, 0]
                }
            } else if direction == "u" || direction == "d" {
                if tiles[t][x] == 0 {
                    return [x, t, 0]
                }
            }
        }
        
        // if not keep the same position
        return [x, y, 2]
    }
    
    func updateTile(oldX: Int, oldY: Int, newX: Int, newY: Int) {
        changePositionOfTileInTileData(oldX: oldX, oldY: oldY, newX: newX, newY: newY, newTileValueMultiplier: 1)
        changePositionOfTileView(oldX: oldX, oldY: oldY, newX: newX, newY: newY)
    }
    
    func combineTile(oldX: Int, oldY: Int, newX: Int, newY: Int) {
        let tileValue = tiles[oldY][oldX]
        changePositionOfTileInTileData(oldX: oldX, oldY: oldY, newX: newX, newY: newY, newTileValueMultiplier: 2)
        changeScoreCounterBy(num: tileValue * 2)
        combineTileView(oldX: oldX, oldY: oldY, newX: newX, newY: newY, tileValue: tileValue)
        
        if tileValue * 2 == 2048 {
            wonGame = true
        }
        
        notCombined[newY][newX] = false
    }
    
    func changePositionOfTileInTileData(oldX: Int, oldY: Int, newX: Int, newY: Int, newTileValueMultiplier: Int) {
        let tileValue = tiles[oldY][oldX]
        tiles[oldY][oldX] = 0
        tiles[newY][newX] = tileValue * newTileValueMultiplier
    }
    
    func changePositionOfTileView(oldX: Int, oldY: Int, newX: Int, newY: Int) {
        if let unwrappedTileView = tileViews[oldY][oldX] as? UIImageView {
            let tileView = unwrappedTileView
            UIView.animate(withDuration: 0.2, animations: {
                tileView.center = CGPoint(x: self.tileCenterPositionArray[newX], y: self.tileCenterPositionArray[newY] + self.yOffset)
                
            })
            tileViews[oldY][oldX] = 0
            tileViews[newY][newX] = tileView
        }
    }
    
    func combineTileView(oldX: Int, oldY: Int, newX: Int, newY: Int, tileValue: Int) {
        if let unwrappedTileView = tileViews[oldY][oldX] as? UIImageView {
            let tileView = unwrappedTileView
            UIView.animate(withDuration: 0.2, animations: {
                tileView.center = CGPoint(x: self.tileCenterPositionArray[newX], y: self.tileCenterPositionArray[newY] + self.yOffset)
                
            }, completion: { _ in
                tileView.removeFromSuperview()
                let image = self.numToImage(num: tileValue * 2)
                if let tileImageView = self.tileViews[newY][newX] as? UIImageView {
                    self.changeImage(tileImageView: tileImageView, image: image)
                    self.tilePopEffect(tileImageView:tileImageView)
                }
            })
            tileViews[oldY][oldX] = 0
        }
    }
    
    func changeScoreCounterBy(num: Int) {
        scoreCounter += num
        scoreCounterLabel.text = String(scoreCounter)
        scorePopEffect()
    }
    
    func addTileToRandomPlace() {
        let emptySpace = getRandomEmptySpace()
        let startingValue = getRandomStartingValue()
        let image = numToImage(num: startingValue)
        createTile(emptySpace: emptySpace, startingValue: startingValue, image: image)
    }
    
    func getRandomEmptySpace() -> [Int] {
        
        var emptySpaces = getEmptySpaces()
        
        let randNum = Int(arc4random_uniform(UInt32(emptySpaces.count - 1)))
        let x = emptySpaces[randNum][0]
        let y = emptySpaces[randNum][1]
        
        return [x,y]
    }
    
    func getEmptySpaces() -> [[Int]] {
        var emptySpaces = [[Int]]()
        for y in 0...(tilesInRow - 1) {
            for x in 0...(tilesInRow - 1) {
                if tiles[y][x] == 0 {
                    emptySpaces.append([x,y])
                }
            }
        }
        return emptySpaces
    }
    
    func getRandomStartingValue() -> Int {
        let randNum = Int(arc4random_uniform(10))
        var startingValue : Int!
        if randNum < 9 {
            startingValue = 2
        } else {
            startingValue = 4
        }
        return startingValue
    }
    
    func numToImage(num: Int) -> [UIImage] {
        if let imageList = numToImageDictionary[num] {
            return imageList
        }
        return [UIImage(named: "doge")!]
    }
    
    func createTile(emptySpace: [Int], startingValue: Int, image: [UIImage]) {
        let tileImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: tileSize, height: tileSize))
        tileImageView.center = CGPoint(x: tileCenterPositionArray[emptySpace[0]], y: tileCenterPositionArray[emptySpace[1]] + yOffset)
        changeImage(tileImageView: tileImageView, image: image)
        tileImageView.layer.cornerRadius = 5
        tileImageView.clipsToBounds = true
        tileImageView.alpha = 0
        view.addSubview(tileImageView)
        UIView.animate(withDuration: 0.5) {
            tileImageView.alpha = 1
        }
        tileViews[emptySpace[1]][emptySpace[0]] = tileImageView
        tiles[emptySpace[1]][emptySpace[0]] = startingValue
    }
    
    func changeImage(tileImageView: UIImageView, image: [UIImage]) {
        tileImageView.animationImages = image
        tileImageView.animationDuration = 1.5
        tileImageView.startAnimating()
    }
    
    /*func changeImage1(tileImageView: UIImageView, imageURLString: String) {
        if let url = URL(string: imageURLString) {
            do {
                let image = try FLAnimatedImage.init(animatedGIFData: Data(contentsOf: url))
                // tileImageView.animatedImage = image
                
            } catch {
                print("lol")
            }
        }
    }
    
    func numToImageURL(num: Int) -> String {
        if let imageURl = numToImageURLDictionary[num] {
            return imageURl
        }
        return "no way this will ever be returned"
    }*/
    
    func tilePopEffect(tileImageView: UIImageView) {
        UIView.animate(withDuration: 0.05, animations: {
            tileImageView.center = tileImageView.center
            tileImageView.transform = CGAffineTransform(scaleX: 1.06, y: 1.06)
            
        }, completion: { _ in
            UIView.animate(withDuration: 0.05, animations: {
                tileImageView.transform = CGAffineTransform.identity
                self.scoreCounterLabel.transform = CGAffineTransform.identity
            })
        })
    }
    
    func scorePopEffect() {
        UIView.animate(withDuration: 0.05, animations: {
            self.scoreCounterLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            
        }, completion: { _ in
            UIView.animate(withDuration: 0.05, animations: {
                self.scoreCounterLabel.transform = CGAffineTransform.identity
            })
        })
    }
}
