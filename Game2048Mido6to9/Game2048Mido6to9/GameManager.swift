import Foundation
import AVFoundation
import SwiftUI

class GameManager: ObservableObject {
    @Published var board: GameBoard

    @Published var movesCount: Int = 0
    @Published var score: Int = 0

    @Published var bestScore: Int = 0 {
        didSet {
            UserDefaults.standard.set(bestScore, forKey: "BestScore")
        }
    }

    @Published var boardSize: Int

    @Published var gameOver: Bool = false

    private var audioPlayer: AVAudioPlayer?

    init(boardSize: Int = 4) {

        self.boardSize = boardSize
        self.bestScore = UserDefaults.standard.integer(forKey: "BestScore")

        self.board = GameBoard(size: boardSize)
    }

    func restartGame() {
        self.board = GameBoard(size: boardSize)
        self.movesCount = 0
        self.score = 0
        self.gameOver = false
    }

    func swipeLeft() {
        playSwipeSound()
        let oldBoard = board.copyState()
        let pointsEarned = board.swipeLeft()
        finishMove(pointsEarned: pointsEarned, oldBoard: oldBoard)
    }

    func swipeRight() {
        playSwipeSound()
        let oldBoard = board.copyState()
        let pointsEarned = board.swipeRight()
        finishMove(pointsEarned: pointsEarned, oldBoard: oldBoard)
    }

    func swipeUp() {
        playSwipeSound()
        let oldBoard = board.copyState()
        let pointsEarned = board.swipeUp()
        finishMove(pointsEarned: pointsEarned, oldBoard: oldBoard)
    }

    func swipeDown() {
        playSwipeSound()
        let oldBoard = board.copyState()
        let pointsEarned = board.swipeDown()
        finishMove(pointsEarned: pointsEarned, oldBoard: oldBoard)
    }

    private func finishMove(pointsEarned: Int, oldBoard: [[Tile?]]) {

        if pointsEarned > 0 {
            score += pointsEarned
            if score > bestScore {
                bestScore = score
            }
        }

        let changed = boardHasChanged(oldState: oldBoard, newState: board.tiles)
        if changed {
            movesCount += 1
            board.addRandomTile()
        }

        if !board.canMove() {
            gameOver = true
        }
    }

    private func boardHasChanged(oldState: [[Tile?]], newState: [[Tile?]]) -> Bool {
        guard oldState.count == newState.count else { return true }
        for i in 0..<oldState.count {
            if oldState[i].count != newState[i].count { return true }
            for j in 0..<oldState[i].count {
                if oldState[i][j]?.value != newState[i][j]?.value {
                    return true
                }
            }
        }
        return false
    }

    private func playSwipeSound() {
        guard let url = Bundle.main.url(forResource: "swipeSound", withExtension: "mp3") else {
            print("Swipe sound file not found in bundle.")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing swipe sound: \(error.localizedDescription)")
        }
    }
}
