//
//  ControllerView.swift
//  seepath
//
//  Created by Declan McCue on 3/15/25.
//

import SwiftUI

struct ControllerView: View {
  @ObservedObject var model: GridModel
  @Binding var selectedAlgorithm: String
  @Binding var speed_ms: Int
  var isRunning: Bool
  var algorithms: [String]

  var algorithm: () -> Void
  var resetGrid: () -> Void

  var body: some View {
    VStack {
      HStack {
        Picker("Algorithm", selection: $selectedAlgorithm) {
          ForEach(algorithms, id: \.self) { algo in
            Text(algo).tag(algo)
          }
        }
        .pickerStyle(MenuPickerStyle())
        
        Picker("Speed", selection: $speed_ms) {
            Text("1 ms").tag(1)
            Text("25 ms").tag(25)
            Text("50 ms").tag(50)
            Text("100 ms").tag(100)
        }
        .pickerStyle(MenuPickerStyle())
      }

      HStack {
        Button(action: { algorithm() }) {
          Text("Run")
            .padding()
            .background(isRunning ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .disabled(isRunning)

        Button(action: { resetGrid() }) {
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
