//
//  ContentView.swift
//  ConnectTheDots
//
//  Created by nutterfi on 6/15/21.
//

import SwiftUI

/**
  TODO
  Add buttons for point select, line select, line style change (e.g. arc, quadcurve)
   Control point dragging
    Import/Export Path
 */

class ViewModel: ObservableObject {
  @Published var points: [CGPoint] = []
  
  func addPoint() {
    points.append(CGPoint(x: 0.5, y: 0.5))
  }
}

struct ContentView: View {
  @StateObject private var viewModel = ViewModel()
  
  var body: some View {
    VStack {
      Button {
        viewModel.addPoint()
      } label: {
        Image(systemName: "plus")
      }
      .padding()
      
      Divider()
      
      GeometryReader { proxy in
        let dim = min(proxy.size.width, proxy.size.height)
        ZStack {
          DotConnector(points: viewModel.points)
            .fill(Color.purple)
            .scaleEffect(1/dim)
            .frame(width: dim, height: dim)
            .border(Color.orange)
          
          ForEach(0..<viewModel.points.count, id: \.self) { index in
            let point = viewModel.points[index]
            
            
            Circle()
              .frame(width: 10, height: 10)
              .offset(x: point.x, y: point.y)
              .gesture(
                DragGesture()
                  .onChanged { info in
                viewModel.points[index] = info.location
              }
              )
          }
          
        }
        .frame(width: proxy.size.width, height: proxy.size.height)
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
