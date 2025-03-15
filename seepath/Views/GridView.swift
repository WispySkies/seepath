//
//  GridView.swift
//  seepath
//
//  Created by Declan McCue on 3/15/25.
//

import SwiftUI

struct GridView: View {
  @ObservedObject var model: GridModel
  let cellSize: CGFloat = 15
  
  var body: some View {
    VStack(spacing: 0) {
      ForEach(0..<model.height, id: \ .self) { row in
        HStack(spacing: 0) {
          ForEach(0..<model.width, id: \ .self) { col in
            Rectangle()
              .fill(colorCell(model.grid[row][col]))
              .frame(width: cellSize, height: cellSize)
              .border(Color.gray, width: 0.25)
              .onTapGesture {
                if model.grid[row][col].mutable {
                  model.grid[row][col].isObstacle.toggle()
                }
              }
          }
        }
      }
    }
  }
  
  func colorCell(_ cell: Cell) -> Color {
    if cell.isObstacle {
      .black
    } else if cell.isEnd {
      .red
    } else if cell.isVisited {
      .blue
    } else if cell.isPath {
      .green
    } else {
      .white
    }
  }
}

#Preview {
  VStack {
    let model = GridModel(width: 20, height: 45)
    GridView(model: model)
    Spacer()
    ControllerView(model: model, algorithm: {}, resetGrid: {model.reset()})
  }
}
