//
//  BFS.swift
//  seepath
//
//  Created by Declan McCue on 3/15/25.
//

import Foundation

class BFS: Algorithm {
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
      var queue: [Position] = [start]
      var visited: Set<Position> = []
      
      let directions: [Position] = [
        Position(row: -1, col: 0),
        Position(row: 1, col: 0),
        Position(row: 0, col: -1),
        Position(row: 0, col: 1),
      ]
      
      while !queue.isEmpty {
        if (searchTask?.isCancelled) == nil {
          break
        }

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
