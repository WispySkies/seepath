//
//  ContentViewModel.swift
//  seepath
//
//  Created by Declan McCue on 3/15/25.
//

import SwiftUI

class ContentViewModel: ObservableObject {
  @Published var model = GridModel(width: 20, height: 45)
  @Published var selectedAlgorithm = "BFS"
  @Published var isRunning = false
  let algorithms = ["BFS", "DFS", "A*", "Dijkstra"]

  private var currentAlgorithm: (any Algorithm)?

  func runAlgorithm() {
    guard let start = model.start, let end = model.end else { return }
    isRunning = true

    currentAlgorithm?.cancel()

    switch selectedAlgorithm {
    case "BFS":
      currentAlgorithm = BFS()
    case "DFS":
      currentAlgorithm = DFS()
    case "A*":
      currentAlgorithm = AStar()
    case "Dijkstra":
      currentAlgorithm = Dijkstra()
    default:
      resetGrid()
      return
    }

    currentAlgorithm?.search(grid: model, start: start, end: end) {
      DispatchQueue.main.async {
        self.model.objectWillChange.send()
      }
    }
  }

  func resetGrid() {
    currentAlgorithm?.cancel()
    currentAlgorithm = nil
    model.reset()
    isRunning = false
  }
}
