//
//  DFS.swift
//  seepath
//
//  Created by Declan McCue on 3/15/25.
//

import Foundation

class DFS: Algorithm {
  var searchTask: Task<Void, Never>?

  func search(grid: GridModel, start: Position, end: Position, onUpdate: @escaping () -> Void) {
    searchTask = Task {
      var stack: [Position] = [start]
      var visited: Set<Position> = []

      let directions: [Position] = [
        Position(row: -1, col: 0),
        Position(row: 1, col: 0),
        Position(row: 0, col: -1),
        Position(row: 0, col: 1),
      ]

      while !stack.isEmpty {
        if (searchTask?.isCancelled) == nil {
          return
        }

        let current = stack.removeLast()

        if current == end {
          break
        }

        if visited.contains(current) {
          continue
        }

        visited.insert(current)

        await MainActor.run {
          grid.grid[current.row][current.col].isVisited = true
          onUpdate()
        }
        try? await Task.sleep(for: .milliseconds(50))

        for direction in directions {
          let neighbor = Position(
            row: current.row + direction.row, col: current.col + direction.col)
          if neighbor.row >= 0 && neighbor.row < grid.height
            && neighbor.col >= 0 && neighbor.col < grid.width
            && !grid.grid[neighbor.row][neighbor.col].isObstacle
            && !visited.contains(neighbor)
          {
            stack.append(neighbor)
          }
        }
      }
    }
  }

  func cancel() {
    searchTask?.cancel()
    searchTask = nil
  }
}
