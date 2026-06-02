//
//  LifeRPGTests.swift
//  LifeRPGTests
//
//  Created by Dimitris Poluzos on 31/5/26.
//

@testable import LifeRPG

import Testing
import Foundation

class InMemoryStore: KeyValueStore {
    var storage: [String: Data] = [:]
    func set(_ value: Data, forKey key: String) {
        storage[key] = value
    }
    
    func data(forKey key: String) -> Data? {
        return storage[key]
    }
}

@MainActor
struct LifeRPGTests {

    @Test func saveThenLoad_returnsSameData() async throws {
        // GIVEN: ένας service που γράφει σε καθαρό in-memory store (όχι στο πραγματικό UserDefaults)
        let service = SaveGameService(store: InMemoryStore())

        // ...κι ένα SaveData με αναγνωρίσιμες τιμές
        var player = Player(sellectedClass: warrior)
        player.level = 7
        player.stage = 3
        let enemy = Enemy(hp: 42, mana: 10, isAlive: true, name: "Murloc", attackDamage: 5)

        let original = SaveData(
            player: player,
            enemy: enemy,
            maxPlayerHP: 60,
            maxPlayerMana: 10,
            maxEnemyHP: 55,
            currentArena: "Forest"
        )

        // WHEN: σώζω και μετά φορτώνω
        service.saveGame(original)
        let loaded = service.loadGame()

        // THEN: ό,τι έσωσα, αυτό ακριβώς παίρνω πίσω
        #expect(loaded == original)
    }

    @Test func loadWithoutSave_returnsNil() async throws {
        // GIVEN: καθαρός store, τίποτα δεν έχει σωθεί ποτέ
        let service = SaveGameService(store: InMemoryStore())

        // WHEN: φορτώνω χωρίς να έχω σώσει
        let loaded = service.loadGame()

        // THEN: δεν υπάρχει τίποτα — nil
        #expect(loaded == nil)
    }
    
    @Test func spawnEnemy_atStage1_isMurloc() async throws {
        let service = GameEnemyService()
        let enemy = service.spawnEnemy(for: 1)
        #expect(enemy.name == "Murloc")
    }
    
    @Test func spawnEnemy_atStage4_isGoblin() async throws {
        let service = GameEnemyService()
        let enemy = service.spawnEnemy(for: 4)
        #expect(enemy.name == "Goblin")
    }
    @Test func enemyHpAtStage4() async throws {
        let service = GameEnemyService()
        let enemy = service.spawnEnemy(for: 4)
        #expect(enemy.hp == 65)
    }
    @Test func enemyDamageAtStage8() async throws {
        let service = GameEnemyService()
        let enemy = service.spawnEnemy(for: 8)
        #expect(enemy.attackDamage == 19)
    }
    @Test func spawnEnemy_atStage8_isSkeleton() async throws {
        let service = GameEnemyService()
        let enemy = service.spawnEnemy(for: 8)
        #expect(enemy.name == "Skeleton")
    }
    
    @Test func spawnEnemyAtStage10IsBoss() async throws {
        let service = GameEnemyService()
        let enemy = service.spawnEnemy(for: 10)
        #expect(enemy.name == "Boss")
    }
    @Test func addLogTest() async throws {
        let service = BattleLogService()
        service.addLog("Test Message")
        #expect(service.battleLog.contains("Test Message"))
    }
    @Test func logCapp() async throws {
        let service = BattleLogService()
        for i in 1...30 { service.addLog("message \(i)") }
        #expect(service.battleLog.count == 20)
    }
}
