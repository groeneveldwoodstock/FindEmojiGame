//
//  Game.swift
//
//  Created by Richard Groeneveld on 1/17/23.
//


import Foundation
import UIKit
import AVFoundation


enum StatusGame {
    case start
    case win
    case lose
    
}
var audioPlayer : AVPlayer!
var playerLooper: AVPlayerLooper?
var queuePlayer = AVQueuePlayer()
func playYes() {
    guard let url = Bundle.main.url(forResource: "yes", withExtension: "wav") else {
        print("error to get the mp3 file")
        return
    }
    
    do {
        audioPlayer = AVPlayer(url: url)
    }
    audioPlayer?.play()
}

func playNo() {
    guard let url = Bundle.main.url(forResource: "wrong", withExtension: "wav") else {
        print("error to get the mp3 file")
        return
    }
    
    do {
        audioPlayer = AVPlayer(url: url)
    }
    audioPlayer?.play()
}
func playMusic() {
    guard let url = Bundle.main.url(forResource: "bensound-goinghigher", withExtension: "mp3") else {
        print("error to get the mp3 file")
        return
    }
    
    do {
        let playerItem = AVPlayerItem(asset: AVAsset(url: url))
        playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
                queuePlayer.play()
    }
    queuePlayer.play()
}
class Game{
    
    struct Item{
        var title:String
        var isFound = false
        var isError = false
    }
    
    private let allEmojis = ["😀","😁","😂","😃","😄","😅","😆","😇","😈","👿","😉","😊","☺️","😋","😌","😍","😎","😏","😐","😑","😒","😓","😔","😕","😖","😗","😘","😙","😚","😛","😜","😝","😞","😟","😠","😡","😢","😣","😤","😥","😦","😧","😨","😩","😪","😫","😬","😭","😮","😯","😰","😱","😲","😳","😴","😵","😶","😷","😸","😹","😺","😻","😼","😽","😾","😿","🙀","😶‍🌫️","🤬","🥸","🥶","🥵","🫠","🥴","🤢","🤮","🤧","😷","🤒","🤕","😇","🫥","🤫","🤥"]
    
    var items:[Item] = []
    
    private var countItems:Int
    
    var nextItem:Item?
    
    var isNewRecord = false
    
    var status:StatusGame = .start{
        didSet{
            if status != .start{
                if status == .win{
                    let newRecord = timeForGame - secondsGame
                    
                    let record = UserDefaults.standard.integer(forKey: KeyUserDefaults.recordGame)
                    
                    if record == 0 || newRecord < record {
                        UserDefaults.standard.setValue(newRecord, forKey: KeyUserDefaults.recordGame)
                        isNewRecord = true
                    }
                }
                stopGame()
            }
        }
    }
    
    private var timeForGame:Int
    
    private var secondsGame:Int {
        didSet{
            if secondsGame == 0 {
                status = .lose
                queuePlayer.pause()
            }
            updateTimer(status, secondsGame)
        }
    }
    
    private var timer:Timer?
    private var updateTimer:((StatusGame, Int)->Void)
    
    init(countItems:Int, updateTimer:@escaping (_ status:StatusGame,_ seconds:Int)->Void) {
        self.countItems = countItems
        self.timeForGame = Settings.shared.currentSettings.timeForGame
        self.secondsGame = self.timeForGame
        self.updateTimer = updateTimer
        setupGame()
        if status == .start{
            playMusic()
        }
        
    }
    
    private func setupGame() {
        isNewRecord = false
        var emojis = allEmojis.shuffled()
        items.removeAll()
        
        while items.count < countItems {
            let item = Item(title: String(emojis.removeFirst()))
            items.append(item)
        }
        
        nextItem = items.shuffled().first
        updateTimer(status, secondsGame)
        
        if Settings.shared.currentSettings.timerState {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (_) in
                self?.secondsGame -= 1
            })
        }
    }
    
    func newGame() {
        status = .start
        self.secondsGame = self.timeForGame
        setupGame()
    }
    
    func check(index:Int) {
        guard status == .start else {return}
        
        if items[index].title == nextItem?.title{
            items[index].isFound = true
            playYes()
            nextItem = items.shuffled().first(where: { (item) -> Bool in
                item.isFound == false
        })
        } else {
            items[index].isError = true
            playNo()
        }
        
        if nextItem == nil{
            status = .win
            queuePlayer.pause()
        }
}
    
     func stopGame() {
        timer?.invalidate()
         queuePlayer.pause()
    }
}

extension Int {
    func secondsToString()->String{
        let minutes = self / 60
        let seconds = self % 60
        
        return String(format: "%d:%02d", minutes, seconds)
    }
}
