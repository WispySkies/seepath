//
//  BFS.swift
//  seepath
//
//  Created by Declan McCue on 3/15/25.
//

import Foundation

class BFS: Algorithm {
  func search(grid: GridModel, start: Position, end: Position, onUpdate: @escaping () -> Void) {
    var queue: [Position] = [start]
    var visited: Set<Position> = []

    /* position adjustments for easy math */
    let directions: [Position] = [
      Position(row: -1, col: 0),
      Position(row: 1, col: 0),
      Position(row: 0, col: -1),
      Position(row: 0, col: 1),
    ]
    DispatchQueue.global(qos: .userInitiated).async {
      while !queue.isEmpty {
        let current = queue.removeFirst()

        if current == end {
          break
        }

        for direction in directions {
          let neighbor = Position(
            row: current.row + direction.row, col: current.col + direction.col)
          if neighbor.row >= 0 && neighbor.row < grid.height
            && neighbor.col >= 0 && neighbor.col < grid.width
            && !grid.grid[neighbor.row][neighbor.col].isObstacle
            && !visited.contains(neighbor)
          {
            visited.insert(neighbor)
            queue.append(neighbor)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
              grid.grid[neighbor.row][neighbor.col].isVisited = true
              onUpdate()
            }
          }
        }
      }
    }
  }
}
