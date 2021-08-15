//
//  QuadCurveIllustrator.swift
//  QuadCurveIllustrator
//
//  Created by nutterfi on 8/14/21.
//

import SwiftUI



struct QuadCurveCanvas: Shape {
  // normalized (0...1)
  var start: CGPoint
  var control: CGPoint
  var end: CGPoint
  
  func path(in rect: CGRect) -> Path {
    Path { path in
      path.move(to: CGPoint(x: rect.width * start.x, y: rect.height * start.y))
      
      path.addQuadCurve(
        to: CGPoint(x: rect.width * end.x, y: rect.height * end.y),
        control: CGPoint(x: rect.width * control.x, y: rect.height * control.y))
    }
  }
}

struct CurveCanvas: Shape {
  // normalized (0...1)
  var start: CGPoint
  var control1: CGPoint
  var control2: CGPoint

  var end: CGPoint
  
  func path(in rect: CGRect) -> Path {
    Path { path in
      path.move(to: CGPoint(x: rect.width * start.x, y: rect.height * start.y))
      
      path.addCurve(
        to: CGPoint(x: rect.width * end.x, y: rect.height * end.y),
        control1: CGPoint(x: rect.width * control1.x, y: rect.height * control1.y),
      control2: CGPoint(x: rect.width * control2.x, y: rect.height * control2.y))
    }
  }
}

class QuadCurveIllustratorViewModel: ObservableObject {
  @Published var start: CGPoint = .zero
  @Published var control1: CGPoint = CGPoint(x: 0.5, y: 0.5)
  @Published var control2: CGPoint = CGPoint(x: 0.5, y: 0.5)
  @Published var end: CGPoint = CGPoint(x: 1, y: 1)
}

struct QuadCurveIllustrator: View {
  @StateObject private var viewModel = QuadCurveIllustratorViewModel()
  @State private var drag: CGPoint = .zero
  
  var body: some View {
    
    VStack {
      VStack {
        Text("Drag: (\(drag.x), \(drag.y)")

        Text("Start: (\(viewModel.start.x), \(viewModel.start.y)")
        Text("Control1: (\(viewModel.control1.x), \(viewModel.control1.y)")
        Text("Control2: (\(viewModel.control2.x), \(viewModel.control2.y)")

        Text("End: (\(viewModel.end.x), \(viewModel.end.y)")
        
      }
      
      GeometryReader { proxy in
        let dim = min(proxy.size.width, proxy.size.height)
        ZStack {
          CurveCanvas(start: viewModel.start, control1: viewModel.control1,
                      control2: viewModel.control2, end: viewModel.end)
            .stroke(Color.purple)
            .frame(width: dim, height: dim)
            .border(Color.orange)
          
          // START
          Circle()
            .fill(Color.blue)
            .frame(width: 10, height: 10)
            .offset(x: -dim * 0.5 + dim * viewModel.start.x, y: -dim * 0.5 + dim * viewModel.start.y)
            .gesture(
              DragGesture()
                .onChanged { info in
                  drag = info.location
                  viewModel.start.x = (info.location.x + dim / 2) / dim
                  viewModel.start.y = (info.location.y + dim / 2) / dim
                }
            )
          
          
          // CONTROL1
          Circle()
            .fill(Color.purple)
            .frame(width: 10, height: 10)
            .offset(x: -dim * 0.5 + dim * viewModel.control1.x, y: -dim * 0.5 + dim * viewModel.control1.y)
            .gesture(
              DragGesture()
                .onChanged { info in // 0,0 is in the center and it is NOT normalized
                  drag = info.location

                  viewModel.control1.x = (info.location.x + dim / 2) / dim
                  viewModel.control1.y = (info.location.y + dim / 2) / dim
                }
            )
          
          // CONTROL2
          Circle()
            .fill(Color.red)
            .frame(width: 10, height: 10)
            .offset(x: -dim * 0.5 + dim * viewModel.control2.x, y: -dim * 0.5 + dim * viewModel.control2.y)
            .gesture(
              DragGesture()
                .onChanged { info in // 0,0 is in the center and it is NOT normalized
                  drag = info.location

                  viewModel.control2.x = (info.location.x + dim / 2) / dim
                  viewModel.control2.y = (info.location.y + dim / 2) / dim
                }
            )
          
          
          // END
          Circle()
            .fill(Color.green)
            .frame(width: 10, height: 10)
            .offset(x: -dim * 0.5 + dim * viewModel.end.x, y: -dim * 0.5 + dim * viewModel.end.y)
            .gesture(
              DragGesture()
                .onChanged { info in
                  drag = info.location

                  viewModel.end.x = (info.location.x + dim / 2) / dim
                  viewModel.end.y = (info.location.y + dim / 2) / dim
                }
            )
          
        }
        .frame(width: proxy.size.width, height: proxy.size.height)
      }
      .padding()
    }
  }
}

struct QuadCurveIllustrator_Previews: PreviewProvider {
  static var previews: some View {
    QuadCurveIllustrator()
  }
}
