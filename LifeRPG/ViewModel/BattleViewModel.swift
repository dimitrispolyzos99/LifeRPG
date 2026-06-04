//
//  BattleViewModel.swift
//  LifeRPG
//
//  Created by Dimitris Poluzos on 11/3/26.
//

import Foundation
import Combine

@MainActor
class BattleViewModel: ObservableObject {


    @Published var maxEnemyHP = 50
    @Published var currentArena: String
    @Published var player: Player
    @Published var enemy: Enemy
    @Published var enemyHit = false
    @Published var playerHit = false


    private var basicAttackDamage = 10
    private let potionHeal = 10
    private let manaRegenPerTurn = 3
    private let xpReward = 50
    private let levelUpCost = 100
    var classColor = "warriorColor"
   
    let battleLog: LogService
    let saveDataService: SaveService
    let enemyService: EnemyService
    let playerStatsService: PlayerStatsService
    let spellService: SpellService
    
    init(battleLog: LogService? = nil, saveDataService: SaveService? = nil, enemyService: EnemyService? = nil, playerStatsService: PlayerStatsService? = nil, spellService: SpellService? = nil) {
        self.battleLog = battleLog ?? BattleLogService()
        self.saveDataService = saveDataService ?? SaveGameService()
        self.enemyService = enemyService ?? GameEnemyService()
        self.playerStatsService = playerStatsService ?? GamePlayerStatsService()
        self.spellService = spellService ?? GameSpellService()

        let initialClass: PlayerClass = warrior
        let initialArena = "Coast"
        self.currentArena = initialArena
        self.player = Player(sellectedClass: initialClass)
        self.enemy = self.enemyService.spawnEnemy(for: 1)
    }

    
    func updateArena(){
        switch player.stage{
        case 1...3:
            currentArena = "Coast"
        case 4...6:
            currentArena = "Forest"
        case 7...9:
            currentArena = "HauntedHouse"
        default:
            currentArena = "Volcano"
        }
    }
    
    var isGameOver: Bool {
        player.hp == 0
    }
    
    func respawnEnemy(){
        enemy = enemyService.spawnEnemy(for: player.stage)
        maxEnemyHP = enemy.hp
        updateArena()
        battleLog.addLog("\(enemy.name) has appeared")
    }
    private func levelUp() {
        player = playerStatsService.levelUp(player)
        saveGame()
        battleLog.addLog("Congrats you leveled up")
    }
    private func resolveEnemyTurn(){
        if enemy.hp <= 0 {
            enemy.isAlive = false
            saveGame()
            player.stage += 1
            player.xp += xpReward
            battleLog.addLog("You killed the \(enemy.name)")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6){
                self.respawnEnemy()
            }
            if player.xp >= levelUpCost * player.level {
                levelUp()
            }
        } else {
            enemyAttack()
        }
    }
    private func enemyAttack() {
        
        playerHit = true
        player.mana = min(player.mana + manaRegenPerTurn, player.maxMana)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            self.playerHit = false
        }
        player.hp = max(player.hp - enemy.attackDamage, 0)
        if player.hp == 0{
            battleLog.addLog("\(player.playerClass.name) was defeated")
        } else {
            battleLog.addLog("\(enemy.name) attacked \(player.playerClass.name) for \(enemy.attackDamage) dmg")
        }
    }
    private func enemyTakesDamage() {
        enemyHit = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            self.enemyHit = false
        }
    }
    


    func saveGame() {
        let saveData = SaveData(
            player: player,
            enemy: enemy,
            maxEnemyHP: maxEnemyHP,
            currentArena: currentArena
        )
        saveDataService.saveGame(saveData)
    }
    func loadGame() {
        if let loadedSave = saveDataService.loadGame(){
                player = loadedSave.player
                enemy = loadedSave.enemy
                player.maxHP = loadedSave.player.maxHP
                player.maxMana = loadedSave.player.maxMana
                maxEnemyHP = loadedSave.maxEnemyHP
                currentArena = loadedSave.currentArena
                
                enemyHit = false
                playerHit = false
                battleLog.addLog("Game loaded")
            }
        }
    
    
    func attackEnemy(){
            enemyTakesDamage()
            enemy.hp -= basicAttackDamage
        battleLog.addLog("\(player.playerClass.name) attacks \(enemy.name) for \(basicAttackDamage) dmg")
            resolveEnemyTurn()
        }

    
    func usePotion() {
        player.hp = min(player.hp + potionHeal, player.maxHP)
        battleLog.addLog("\(player.playerClass.name) used Health Potion")
        enemyAttack()
    }
    func restartBattle(){
        enemy.hp = maxEnemyHP
        player.hp = player.maxHP
        player.mana = player.maxMana
        enemy.isAlive = true
        enemyHit = false
        playerHit = false
        battleLog.addLog("Battle restarted")
    }
    func resetGame() {
        player.stage = 1
        respawnEnemy()
        player.hp = player.maxHP
        player.mana = player.maxMana
    }
    func applyClass(_ selectedClass: PlayerClass){
        player = Player(sellectedClass: selectedClass)
        applyClassColor()
        resetGame()

        battleLog.addLog("New character created")
        battleLog.addLog("Battle started")
        saveGame()
    }

    func applyClassColor(){
        switch player.playerClass {
        case warrior:
            classColor = "warriorColor"
        case rogue:
            classColor = "rogueColor"
        case mage:
            classColor = "mageColor"
        default:
            classColor = "paladinColor"
        }
    }
    func castSpell(_ spell: Spell) {
        guard player.mana >= spell.manaCost && player.hp > spell.hpCost else {
            battleLog.addLog("Not enough resources")
            return
        }
        spellService.cast(spell, player: &player, enemy: &enemy)
        battleLog.addLog("\(player.playerClass.name) used \(spell.name) on \(enemy.name)")
        enemyTakesDamage()
        resolveEnemyTurn()
    }
    
}

