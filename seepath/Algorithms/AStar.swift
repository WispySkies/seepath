//
//  AStar.swift
//  seepath
//
//  Created by Declan McCue on 3/15/25.
//

import Foundation

class AStar: Algorithm {
  var searchTask: Task<Void, Never>?

  func cancel() {
    searchTask?.cancel()
    searchTask = nil
  }

  func search(grid: GridModel, start: Position, end: Position, onUpdate: @escaping () -> Void) {
    searchTask = Task {
      var openSet: Set<Position> = [start]
      var cameFrom: [Position: Position] = [:]

      var gScore: [Position: Int] = [:]
      gScore[start] = 0

      var fScore: [Position: Int] = [:]
      fScore[start] = heuristic(start, end)

      let directions: [Position] = [
        Position(row: -1, col: 0),
        Position(row: 1, col: 0),
        Position(row: 0, col: -1),
        Position(row: 0, col: 1),
      ]

      while !openSet.isEmpty {
        if (searchTask?.isCancelled) == nil {
          return
        }

        let current = openSet.min { fScore[$0] ?? Int.max < fScore[$1] ?? Int.max }!

        if current == end {
          reconstructPath(cameFrom: cameFrom, current: current, grid: grid)
          break
        }

        openSet.remove(current)

        for direction in directions {
          let neighbor = Position(
            row: current.row + direction.row, col: current.col + direction.col)
          if neighbor.row >= 0 && neighbor.row < grid.height
            && neighbor.col >= 0 && neighbor.col < grid.width
            && !grid.grid[neighbor.row][neighbor.col].isObstacle
          {
            let tentativeGScore = gScore[current, default: Int.max] + 1
            if tentativeGScore < gScore[neighbor, default: Int.max] {
              cameFrom[neighbor] = current
              gScore[neighbor] = tentativeGScore
              fScore[neighbor] = tentativeGScore + heuristic(neighbor, end)

              if !openSet.contains(neighbor) {
                openSet.insert(neighbor)
              }

              await MainActor.run {
                grid.grid[neighbor.row][neighbor.col].isVisited = true
                onUpdate()
              }
              try? await Task.sleep(for: .milliseconds(50))
            }
          }
        }
      }
    }
  }

  private func heuristic(_ start: Position, _ end: Position) -> Int {
    return abs(start.row - end.row) + abs(start.col - end.col)
  }

  private func reconstructPath(cameFrom: [Position: Position], current: Position, grid: GridModel) {
    var current = current
    while let previous = cameFrom[current] {
      grid.grid[current.row][current.col].isPath = true
      current = previous
    }
  }
}
