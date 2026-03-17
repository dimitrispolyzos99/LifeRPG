//
//  BattleViewModel.swift
//  LifeRPG
//
//  Created by Dimitris Poluzos on 11/3/26.
//

import Foundation
import Combine


class BattleViewModel: ObservableObject {

    @Published var maxPlayerHP: Int
    @Published var maxPlayerMana: Int
    @Published var maxEnemyHP = 50
    @Published var currentArena: String

    private let enemyMana = 10
    private var basicAttackDamage = 10
    private var enemyAttackDamage = 5
    private let judgementDamage = 15
    private let holyLightHeal = 15
    private let potionHeal = 10
    private let manaRegenPerTurn = 3
    private let xpReward = 50
    let judgementManaCost = 5
    private let levelUpCost = 100
    let holyLightManaCost = 10
    private let warriorHP = 60
    private let warriorMana = 10
    private let mageHP = 40
    private let mageMana = 60
    private let paladinHP = 70
    private let paladinMana = 20
    private let rogueHP = 40
    private let rogueMana = 30
    let executeHPCost = 5
    private let executeDamage = 30
    let fireballManaCost = 10
    private let fireballDamage = 40
    let garroteManaCost = 15
    private let garroteDamage = 20
    let frostballManaCost = 20
    private let frostballDamage = 25
    let assassinateManaCost = 20
    private let assassinateDamage = 50
    private let victoryRushDamage = 30
    let victoryRushManaCost = 10
    let victoryRushHeal = 10
    

    init() {
        let initialClass: PlayerClass = warrior
        
        let initialArena = "Coast"

        let initialMaxHP: Int
        let initialMaxMana: Int
        switch initialClass {
        case warrior:
            initialMaxHP = warriorHP
            initialMaxMana = warriorMana
        case mage:
            initialMaxHP = mageHP
            initialMaxMana = mageMana
        case paladin:
            initialMaxHP = paladinHP
            initialMaxMana = paladinMana
        case rogue:
            initialMaxHP = rogueHP
            initialMaxMana = rogueMana
        default:
            initialMaxHP = 100
            initialMaxMana = 40
        }
        self.currentArena = initialArena
        self.player = Player(sellectedClass: initialClass)
        self.maxPlayerHP = initialMaxHP
        self.maxPlayerMana = initialMaxMana
        self.player.hp = initialMaxHP
        self.player.mana = initialMaxMana

    }

    
    private func updateMaxStats(for playerClass: PlayerClass) {
        switch playerClass {
        case warrior:
            maxPlayerHP = warriorHP
            maxPlayerMana = warriorMana
        case mage:
            maxPlayerHP = mageHP
            maxPlayerMana = mageMana
        case paladin:
            maxPlayerHP = paladinHP
            maxPlayerMana = paladinMana
        case rogue:
            maxPlayerHP = rogueHP
            maxPlayerMana = rogueMana
        default:
            maxPlayerHP = 100
            maxPlayerMana = 40
        }
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

    
    @Published var player: Player
    @Published var enemy = Enemy(
        hp: 50,
        mana: 20,
        isAlive: true,
        name: "Murloc"
    )
    @Published var battleLog: [String] = ["Battle started"]
    @Published var enemyHit = false
    @Published var playerHit = false
    
    

    
    
    var isGameOver: Bool {
        player.hp == 0
    }
    
    
    
    private func respawnEnemy(){
        enemy.isAlive = true
        maxEnemyHP +=  5
        enemyAttackDamage += 2
        enemy.hp = maxEnemyHP
        enemy = enemyForStage(player.stage)
        updateArena()
        maxEnemyHP = enemy.hp
        addLog("A new \(enemy.name) appears")
    }
    private func levelUp() {
        player.level += 1
        player.xp = 0
        maxPlayerHP += 3
        maxPlayerMana +=  2
        player.hp = maxPlayerHP
        player.mana = maxPlayerMana
        saveGame()
        addLog("Congrats you leveled up")
    }
    private func resolveEnemyTurn(){
        if enemy.hp <= 0 {
            enemy.isAlive = false
            saveGame()
            player.stage += 1
            player.xp += xpReward
            addLog("You killed the \(enemy.name)")
            
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
        player.mana = min(player.mana + manaRegenPerTurn, maxPlayerMana)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            self.playerHit = false
        }
        player.hp = max(player.hp - enemyAttackDamage, 0)
        if player.hp == 0{
            addLog("\(player.playerClass.name) was defeated")
        } else {
            addLog("\(enemy.name) attacked \(player.playerClass.name) for \(enemyAttackDamage) dmg")
        }
    }
    private func murlocTakesDamage() {
        enemyHit = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            self.enemyHit = false
        }
    }
    
    
    func victoryRush(){
        if player.mana >= victoryRushManaCost {
            player.mana -= victoryRushManaCost
            let scaledVictoryRushDamage = victoryRushDamage + ((player.level - 1) * 3)
            let scaledVictoryRushHeal = victoryRushHeal + ((player.level - 1) * 2)
            enemy.hp -= scaledVictoryRushDamage
            player.hp += scaledVictoryRushHeal
            addLog("\(player.playerClass.name) used \(player.playerClass.spellTwo) on \(enemy.name) and healed for \(scaledVictoryRushHeal) hp")
            murlocTakesDamage()
            resolveEnemyTurn()
        }
        else {
            addLog("Not enough mana")
        }
    }
    func assasinate(){
        if player.mana >= assassinateManaCost{
            player.mana -= assassinateManaCost
            let scaledAssassinateDamage = assassinateDamage + ((player.level - 1) * 3)
            enemy.hp -= scaledAssassinateDamage
            addLog("\(player.playerClass.name) used \(player.playerClass.spellTwo) and backstabed \(enemy.name) and did \(scaledAssassinateDamage) damage")
            murlocTakesDamage()
            resolveEnemyTurn()
        }
        else {
            addLog("Not enough mana")
        }
    }
    func garrote(){
        if player.mana >= garroteManaCost{
            player.mana -= garroteManaCost
            let scaledGarroteDamage = garroteDamage + ((player.level - 1) * 2)
            enemy.hp -= scaledGarroteDamage
            addLog("\(player.playerClass.name) used \(player.playerClass.spellOne) and backstabed \(enemy.name) and did \(scaledGarroteDamage)")
            murlocTakesDamage()
            resolveEnemyTurn()
        }
        else {
            addLog("Not enough mana")
        }
    }
    func fireball(){
        if player.mana >= fireballManaCost{
            player.mana -= fireballManaCost
            let scaledFireballDamage = fireballDamage + ((player.level - 1) * 2)
            enemy.hp -= scaledFireballDamage
            addLog("\(player.playerClass.name) casted \(player.playerClass.spellOne) on \(enemy.name) and did \(scaledFireballDamage)")
            murlocTakesDamage()
            resolveEnemyTurn()
        }
        else {
            addLog("Not enough mana")
        }
    }
    func frostball(){
        if player.mana >= frostballManaCost{
            player.mana -= frostballManaCost
            let scaledFrostballDamage = frostballDamage + ((player.level - 1) * 3)
            enemy.hp -= scaledFrostballDamage
            addLog("\(player.playerClass.name) casted \(player.playerClass.spellTwo) on \(enemy.name) and did \(scaledFrostballDamage)")
            murlocTakesDamage()
            resolveEnemyTurn()
        }
        else {
            addLog("Not enough mana")
        }
    }
    func execute() {
        if player.hp >= executeHPCost{
            player.hp -= executeHPCost
            let scaledExecuteDamage = executeDamage + ((player.level - 1) * 2)
            enemy.hp -= executeDamage
            addLog("\(player.playerClass.name) sucrificed \(executeHPCost) HP and used \(player.playerClass.spellOne) on \(enemy.name) for \(scaledExecuteDamage) damage")
            murlocTakesDamage()
            resolveEnemyTurn()
        }
        else {
            addLog("Not enough HP")
        }
    }
    func holyLight(){
        if player.mana >= holyLightManaCost{
            player.mana -= holyLightManaCost
            let scaledHolyLightHeal = holyLightHeal + ((player.level - 1) * 2)
            player.hp = min(player.hp + scaledHolyLightHeal, maxPlayerHP)
            addLog("\(player.playerClass.name) used \(player.playerClass.spellOne) and healed for \(scaledHolyLightHeal) HP")
            enemyAttack()
        }
        else {
            addLog("Not enough mana")
        }
    }
    func judgement(){
        if player.mana >= judgementManaCost{
            player.mana -= judgementManaCost
            let scaledJudgementDamage = judgementDamage + ((player.level - 1) * 2)
            enemy.hp -= scaledJudgementDamage
            addLog("\(player.playerClass.name) used \(player.playerClass.spellOne) on \(enemy.name) and did \(scaledJudgementDamage) damage")
            murlocTakesDamage()
            resolveEnemyTurn()
        }
        else {
            addLog("Not enough mana")
        }
    }
    func spellOne(){
        switch player.playerClass {
        case warrior:
            execute()
        case paladin:
            judgement()
        case mage:
            fireball()
        case rogue:
            garrote()
        default :
            break
        }
    }
    func spellTwo(){
        switch player.playerClass {
        case warrior:
            victoryRush()
        case paladin:
            holyLight()
        case mage:
            frostball()
        case rogue:
            assasinate()
        default :
            break
        }
    }
    func saveGame() {
        let encoder = JSONEncoder()

        let saveData = SaveData(
            player: player,
            enemy: enemy,
            maxPlayerHP: maxPlayerHP,
            maxPlayerMana: maxPlayerMana,
            maxEnemyHP: maxEnemyHP,
            currentArena: currentArena
        )

        if let data = try? encoder.encode(saveData) {
            UserDefaults.standard.set(data, forKey: "saveData")
        }
    }
    func loadGame() {
        if let savedData = UserDefaults.standard.data(forKey: "saveData") {
            let decoder = JSONDecoder()

            if let loadedSave = try? decoder.decode(SaveData.self, from: savedData) {
                player = loadedSave.player
                enemy = loadedSave.enemy
                maxPlayerHP = loadedSave.maxPlayerHP
                maxPlayerMana = loadedSave.maxPlayerMana
                maxEnemyHP = loadedSave.maxEnemyHP
                currentArena = loadedSave.currentArena

                enemyHit = false
                playerHit = false
                battleLog = ["Game loaded"]
            }
        }
    }
    func attackMurloc(){
            murlocTakesDamage()
            enemy.hp -= basicAttackDamage
        addLog("\(player.playerClass.name) attacks \(enemy.name) for \(basicAttackDamage) dmg")
            resolveEnemyTurn()
        }
    func addLog(_ message: String) {
        battleLog.append(message)

        if battleLog.count > 20 {
            battleLog.removeFirst()
        }
    }
    func usePotion() {
        player.hp = min(player.hp + potionHeal, maxPlayerHP)
        addLog("\(player.playerClass.name) used Health Potion")
        enemyAttack()
    }
    func restartBattle(){
        enemy.hp = maxEnemyHP
        player.hp = maxPlayerHP
        player.mana = maxPlayerMana
        enemy.isAlive = true
        enemyHit = false
        playerHit = false
        battleLog = ["Battle restarted"]
    }
    func resetGame() {
        maxEnemyHP = 50
        enemy = Enemy(hp: maxEnemyHP , mana: enemyMana , isAlive: true, name: "Murloc")
        enemyAttackDamage = 5
        currentArena = "Coast"
        player.hp = maxPlayerHP
        player.mana = maxPlayerMana
        player.stage = 1

    }
    func applyClass(_ selectedClass: PlayerClass){
        updateMaxStats(for: selectedClass)
        player = Player(sellectedClass: selectedClass)
        
        resetGame()

        battleLog = ["New character created"]
        addLog("Battle started")
        saveGame()
    }
    func enemyForStage(_ stage: Int) -> Enemy {
        switch stage {
        case 1...3:
            return Enemy(hp: maxEnemyHP, mana: 20, isAlive: true, name: "Murloc")
        case 4...6:
            return Enemy(hp: maxEnemyHP, mana: 25, isAlive: true, name: "Goblin")
        case 7...9:
            return Enemy(hp: maxEnemyHP, mana: 30, isAlive: true, name: "Skeleton")
        default:
            return Enemy(hp: maxEnemyHP, mana: 40, isAlive: true, name: "Boss")
        }
    }
    
}

