//
//  SaveService.swift
//  LifeRPG
//
//  Created by Dimitris Poluzos on 30/5/26.
//

import Foundation

protocol SaveService {
    func saveGame(_ currentSituation: SaveData)
    func loadGame() -> SaveData?
}

class SaveGameService: SaveService {
    
    
    func saveGame(_ currentSituation: SaveData) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(currentSituation) {
            UserDefaults.standard.set(data, forKey: "saveData")
        }
    }
    func loadGame() -> SaveData? {
        guard let savedData = UserDefaults.standard.data(forKey: "saveData") else { return nil }
        let decoder = JSONDecoder()
        guard let loadedSave = try? decoder.decode(SaveData.self, from: savedData)
        else { return nil }
        
        return loadedSave
    }
}

