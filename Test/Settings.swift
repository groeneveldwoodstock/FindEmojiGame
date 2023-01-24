//
//  Settings.swift
//
//  Created by Richard Groeneveld on 1/17/23.
//

import Foundation

enum KeyUserDefaults{
    static let settingsGame = "settingsGame"
    static let recordGame = "recordGame"
}

struct SettingsGame:Codable{
    var timerState:Bool
    var timeForGame:Int
}


class Settings{

    static var shared = Settings()
    
    let defaultSettings = SettingsGame(timerState: true, timeForGame: 30)
    var currentSettings:SettingsGame{
        get{
            if let data = UserDefaults.standard.object(forKey: KeyUserDefaults.settingsGame) as? Data{
                return try! PropertyListDecoder().decode(SettingsGame.self, from: data)
            }
            else {
                if let data = try? PropertyListEncoder().encode(defaultSettings) {
                    UserDefaults.standard.setValue(data, forKey: KeyUserDefaults.settingsGame)
                }
                return defaultSettings
            }
        }
        set{
            if let data = try? PropertyListEncoder().encode(newValue) {
                UserDefaults.standard.setValue(data, forKey: KeyUserDefaults.settingsGame)
            }
            
        }
    }
    
    func resetSettings() {
        currentSettings = defaultSettings
        
    }
}
