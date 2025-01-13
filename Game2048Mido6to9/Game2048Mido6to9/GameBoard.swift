import Foundation

class GameBoard {
    private(set) var size: Int
    private(set) var tiles: [[Tile?]]

    init(size: Int = 4) {
        self.size = size
        self.tiles = Array(repeating: Array(repeating: nil, count: size), count: size)

        addRandomTile()
        addRandomTile()
    }

    func addRandomTile() {
        var emptyPositions: [(Int, Int)] = []
        for i in 0..<size {
            for j in 0..<size {
                if tiles[i][j] == nil {
                    emptyPositions.append((i, j))
                }
            }
        }
        guard !emptyPositions.isEmpty else { return }

        let randomIndex = Int.random(in: 0..<emptyPositions.count)
        let (row, col) = emptyPositions[randomIndex]

        let newValue = Bool.random() && Bool.random() ? 4 : 2
        tiles[row][col] = Tile(value: newValue)
    }

    func canMove() -> Bool {

        for i in 0..<size {
            for j in 0..<size {
                if tiles[i][j] == nil {
                    return true
                }

                if j < size - 1,
                   let current = tiles[i][j],
                   let right = tiles[i][j+1],
                   current.value == right.value {
                    return true
                }

                if i < size - 1,
                   let current = tiles[i][j],
                   let down = tiles[i+1][j],
                   current.value == down.value {
                    return true
                }
            }
        }
        return false
    }

    func copyState() -> [[Tile?]] {
        var copy = [[Tile?]]()
        for row in tiles {
            copy.append(row)
        }
        return copy
    }

    func swipeLeft() -> Int {
        var pointsEarned = 0
        for i in 0..<size {
            var rowTiles = tiles[i].compactMap { $0 }

            var mergedRow: [Tile] = []
            var skip = false

            for index in 0..<rowTiles.count {
                if skip {
                    skip = false
                    continue
                }

                if index < rowTiles.count - 1,
                   rowTiles[index].value == rowTiles[index + 1].value {
                    let newValue = rowTiles[index].value * 2
                    mergedRow.append(Tile(value: newValue))
                    pointsEarned += newValue
                    skip = true
                } else {
                    mergedRow.append(rowTiles[index])
                }
            }

            let numNils = size - mergedRow.count
            tiles[i] = mergedRow + Array(repeating: nil, count: numNils)
        }
        return pointsEarned
    }

    func swipeRight() -> Int {
        var pointsEarned = 0
        for i in 0..<size {
            tiles[i].reverse()
            pointsEarned += swipeLeft()
            tiles[i].reverse()
        }
        return pointsEarned
    }

    func swipeUp() -> Int {
        var pointsEarned = 0
        for col in 0..<size {

            var column = [Tile]()
            for row in 0..<size {
                if let t = tiles[row][col] {
                    column.append(t)
                }
            }
            var mergedColumn: [Tile] = []
            var skip = false

            for index in 0..<column.count {
                if skip {
                    skip = false
                    continue
                }
                if index < column.count - 1,
                   column[index].value == column[index + 1].value {
                    let newValue = column[index].value * 2
                    mergedColumn.append(Tile(value: newValue))
                    pointsEarned += newValue
                    skip = true
                } else {
                    mergedColumn.append(column[index])
                }
            }

            for row in 0..<mergedColumn.count {
                tiles[row][col] = mergedColumn[row]
            }
            for row in mergedColumn.count..<size {
                tiles[row][col] = nil
            }
        }
        return pointsEarned
    }

    func swipeDown() -> Int {
        var pointsEarned = 0
        for col in 0..<size {

            var column = (0..<size).map { tiles[$0][col] }
            column.reverse()

            var compacted = column.compactMap { $0 }
            var merged: [Tile] = []
            var skip = false

            for i in 0..<compacted.count {
                if skip {
                    skip = false
                    continue
                }
                if i < compacted.count - 1,
                   compacted[i].value == compacted[i+1].value {
                    let newValue = compacted[i].value * 2
                    merged.append(Tile(value: newValue))
                    pointsEarned += newValue
                    skip = true
                } else {
                    merged.append(compacted[i])
                }
            }

            let numNils = size - merged.count
            var reversedMerged = merged + Array(repeating: nil, count: numNils)
            reversedMerged.reverse()

            for row in 0..<size {
                tiles[row][col] = reversedMerged[row]
            }
        }
        return pointsEarned
    }
}
