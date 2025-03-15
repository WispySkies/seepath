//
//  ContentView.swift
//  seepath
//
//  Created by Declan McCue on 3/15/25.
//

import SwiftUI

struct ContentView: View {
  @StateObject var viewModel = ContentViewModel()

  var body: some View {
    VStack {
      GridView(model: viewModel.model)

      Spacer()

      ControllerView(
        model: viewModel.model,
        selectedAlgorithm: $viewModel.selectedAlgorithm,
        isRunning: viewModel.isRunning,
        algorithms: viewModel.algorithms,
        algorithm: viewModel.runAlgorithm,
        resetGrid: viewModel.resetGrid
      )
      .padding()
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
