/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Memento
 - - - - - - - - - -
 ![Memento Diagram](Memento_Diagram.png)
 
 The memento pattern allows an object to be saved and restored. It involves three parts:
 
 (1) The **originator** is the object to be saved or restored.
 
 (2) The **memento** is a stored state.
 
 (3) The **caretaker** requests a save from the originator, and it receives a memento in response. The care taker is responsible for persisting the memento, so later on, the care taker can provide the memento back to the originator to request the originator restore its state.
 
 ## Code Example
 */

import Foundation

//MARK:- Oiginator
class Game: Codable {
  
  class State: Codable {
    var score = 0
    var level = 1
    var attemptsRemaining = 3
  }
  
  var state = State()
  
  func rackUpMassivePoints() {
    state.score += 1000
  }
  func monsterEatPlayer() {
    state.attemptsRemaining -= 1
  }
  
}

//MARK:- Memento (the stored object)
typealias GameMemento = Data

//MARK:- Care Taker (takes originator converts into memento and persist onto disk, alternatively retrieves memento from disk converts it and returns the originator)
class GameSystem {
  
  enum GameError: Error {
    case gameNotFound
    
  }
  //Save Game:- takes the originator, encodes it and persists the encoded state onto the disk
  func save(_ game: Game, title: String) throws {
    let encoder = JSONEncoder()
    let data = try encoder.encode(game)
    UserDefaults.standard.set(data, forKey: title)
  }
  
  //Load Game:- retrieves the saved statefrom the disk, decodes it and returns to the originator
  func load(title: String) throws -> Game {
    let decoder = JSONDecoder()
    guard let data = UserDefaults.standard.data(forKey: title),
       let game = try? decoder.decode(Game.self, from: data) else {
        throw GameError.gameNotFound
    }
    return game
  }
}

var game = Game()
game.monsterEatPlayer()
game.rackUpMassivePoints()

let gameSystem = GameSystem()
try gameSystem.save(game, title: "Best Game Ever")

game = Game()
print("New Game Score: \(game.state.score)")

game = try! gameSystem.load(title: "Best Game Ever")
print("Loaded Game Score: \(game.state.score)")
