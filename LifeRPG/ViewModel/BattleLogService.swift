//
//  BattleLogService.swift
//  LifeRPG
//
//  Created by Dimitris Poluzos on 23/5/26.
//

import Foundation
import Combine

protocol LogService {
    var battleLog: [String] { get }
    func addLog(_ message: String)
}

class BattleLogService: LogService, ObservableObject {
    
    @Published var battleLog: [String] = ["Battle started"]
    
    func addLog(_ message: String) {
        battleLog.append(message)

        if battleLog.count > 20 {
            battleLog.removeFirst()
        }
    }
}
