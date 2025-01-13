import SwiftUI

struct GameView: View {
    @StateObject private var manager = GameManager()

    @State private var showGameOverAlert: Bool = false

    var body: some View {
        VStack(spacing: 16) {

            HStack {
                Text("Moves: \(manager.movesCount)")
                Spacer()
                Text("Score: \(manager.score)")
                Spacer()
                Text("Best: \(manager.bestScore)")
            }
            .padding()

            VStack(spacing: 8) {
                ForEach(0..<manager.board.size, id: \.self) { row in
                    HStack(spacing: 8) {
                        ForEach(0..<manager.board.size, id: \.self) { col in
                            let tile = manager.board.tiles[row][col]
                            TileView(tile: tile)
                        }
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.3))
            .cornerRadius(8)

            .animation(.easeInOut, value: manager.board.tiles)

            HStack(spacing: 20) {
                Button("←") { manager.swipeLeft() }
                Button("→") { manager.swipeRight() }
                Button("↑") { manager.swipeUp() }
                Button("↓") { manager.swipeDown() }
            }
            .padding()

            HStack {

                Picker("Board Size", selection: $manager.boardSize) {
                    ForEach([3,4,5,6], id: \.self) { size in
                        Text("\(size)x\(size)").tag(size)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: manager.boardSize) { newSize in

                    manager.restartGame()
                }

                Spacer()

                Button("Restart") {
                    manager.restartGame()
                }
            }
            .padding()
        }
        .padding()

        .alert(isPresented: $showGameOverAlert) {
            Alert(
                title: Text("Game Over"),
                message: Text("Your final score: \(manager.score)"),
                primaryButton: .default(Text("Restart")) {
                    manager.restartGame()
                },
                secondaryButton: .cancel()
            )
        }

        .onReceive(manager.$gameOver) { isOver in
            if isOver {
                showGameOverAlert = true
            }
        }
    }
}
