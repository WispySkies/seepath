//
//  ContentView.swift
//  seepath
//
//  Created by Declan McCue on 3/15/25.
//

import SwiftUI

struct ContentView: View {
  @StateObject var model = GridModel(width: 20, height: 45)

  @State private var selectedAlgorithm = "BFS"
  @State private var isRunning = false

  var body: some View {
    VStack {
      GridView(model: model)

      Spacer()

      ControllerView(
        model: model,
        algorithm: runAlgorithm,
        resetGrid: {
          model.reset()
          isRunning = false
        }
      )
      .padding()
    }
    .padding()
  }

  func runAlgorithm() {
    guard let start = model.start, let end = model.end else { return }
    isRunning = true

    switch selectedAlgorithm {
    case "BFS":
      let bfs = BFS()
      bfs.search(grid: model, start: start, end: end) {
        DispatchQueue.main.async {
          model.objectWillChange.send()
        }
      }

    case "DFS": break

    case "A*": break

    case "Dijkstra": break

    default:
      break
    }
  }
}

#Preview {
  ContentView()
}
