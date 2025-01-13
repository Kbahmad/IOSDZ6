import SwiftUI

struct Tile: Identifiable, Equatable {
    let id = UUID()
    var value: Int

    var color: Color {
        switch value {
        case 2:      return .yellow
        case 4:      return .orange
        case 8:      return .red
        case 16:     return .pink
        case 32:     return .purple
        case 64:     return .blue
        case 128:    return .cyan
        case 256:    return .green
        case 512:    return .mint
        case 1024:   return .brown
        case 2048:   return .indigo
        case 4096:   return .teal
        case 8192:   return .black
        default:     return .gray
        }
    }

    static func ==(lhs: Tile, rhs: Tile) -> Bool {
        lhs.value == rhs.value
    }
}

struct TileView: View {
    let tile: Tile?

    var body: some View {
        ZStack {
            if let tile = tile {
                RoundedRectangle(cornerRadius: 8)
                    .fill(tile.color)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    )
                    .shadow(color: .black.opacity(0.2), radius: 3, x: 2, y: 2)

                Text("\(tile.value)")
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black.opacity(0.2), lineWidth: 1)
                    )
            }
        }
        .frame(width: 60, height: 60)

        .transition(.scale.combined(with: .opacity))
    }
}
