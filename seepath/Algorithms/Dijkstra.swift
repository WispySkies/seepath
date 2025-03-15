//
//  Dijkstra.swift
//  seepath
//
//  Created by Declan McCue on 3/15/25.
//

import Foundation

class Dijkstra: Algorithm {
  var searchTask: Task<Void, Never>?
  var speed_ms: Int
  
  required init(speed: Int) {
    speed_ms = speed
  }

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

        let current = openSet.min { gScore[$0] ?? Int.max < gScore[$1] ?? Int.max }!

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

              if !openSet.contains(neighbor) {
                openSet.insert(neighbor)
              }

              await MainActor.run {
                grid.grid[neighbor.row][neighbor.col].isVisited = true
                onUpdate()
              }
              try? await Task.sleep(for: .milliseconds(speed_ms))
            }
          }
        }
      }
    }
  }

  private func reconstructPath(cameFrom: [Position: Position], current: Position, grid: GridModel) {
    var current = current
    while let previous = cameFrom[current] {
      grid.grid[current.row][current.col].isPath = true
      current = previous
    }
  }
}
