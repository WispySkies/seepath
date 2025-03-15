//
//  ControllerView.swift
//  seepath
//
//  Created by Declan McCue on 3/15/25.
//

import SwiftUI

struct ControllerView: View {
  @ObservedObject var model: GridModel
  @State private var selectedAlgorithm = "BFS"
  let algorithms = ["BFS", "DFS", "A*", "Dijkstra"]
  
  var algorithm: () -> Void
  var resetGrid: () -> Void
  
  var body: some View {
    VStack {
      Picker("Algorithm", selection: $selectedAlgorithm) {
        ForEach(algorithms, id: \ .self) { algo in
          Text(algo).tag(algo)
        }
      }
      HStack {
        Button(action: algorithm) {
          Text("Run")
        }
        Button(action: resetGrid) {
          Text("Reset")
        }
      }
    }
  }
}
