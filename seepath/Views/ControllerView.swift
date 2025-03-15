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
  @State private var isRunning = false
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
      .pickerStyle(MenuPickerStyle())

      HStack {
        Button(action: {algorithm()}) {
          Text("Run")
            .padding()
            .background(isRunning ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .disabled(isRunning)
        }
        Button(action: resetGrid) {
          Text("Reset")
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
      }
    }
    .padding()
  }
}
