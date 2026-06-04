//
//  SaveService.swift
//  LifeRPG
//
//  Created by Dimitris Polyzos on 30/5/26.
//

import Foundation

protocol SaveService {
    func saveGame(_ currentSituation: SaveData)
    func loadGame() -> SaveData?
}

protocol KeyValueStore {
    func set(_ value: Data, forKey key: String)
    func data(forKey key: String) -> Data?
}

extension UserDefaults: KeyValueStore {
    func set(_ value: Data, forKey key: String) {
        self.set(value as Any?, forKey: key)
    }
}

class SaveGameService: SaveService {
    
    private let store: KeyValueStore

    init(store: KeyValueStore = UserDefaults.standard) {
        self.store = store
    }
    
    func saveGame(_ currentSituation: SaveData) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(currentSituation) {
            store.set(data, forKey: "saveData")
        }
    }
    func loadGame() -> SaveData? {
        guard let savedData = store.data(forKey: "saveData") else { return nil }
        let decoder = JSONDecoder()
        guard let loadedSave = try? decoder.decode(SaveData.self, from: savedData)
        else { return nil }
        
        return loadedSave
    }
}


