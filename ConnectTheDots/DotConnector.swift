//
//  DotConnector.swift
//  ConnectTheDots
//
//  Created by nutterfi on 6/15/21.
//

import SwiftUI

struct DotConnector: Shape {
  var points: [CGPoint] // NORMALIZE
  
  func path(in rect: CGRect) -> Path {
    Path { path in
      if let point = points.first {
        path.move(to: CGPoint(x: rect.width * point.x, y: rect.height * point.y))
        points.forEach { point in
          path.addLine(to: CGPoint(x: rect.width * point.x, y: rect.height * point.y))
        }
        path.closeSubpath()
      }
    }
  }
}

struct DotConnector_Previews: PreviewProvider {
    static var previews: some View {
      DotConnector(points: [.zero,
                            CGPoint(x: 1, y: 0),
                            CGPoint(x: 0.5, y: 0.5),
                            CGPoint(x: 0, y: 1.0),
                            CGPoint(x: 1, y: 1)])
        .stroke(Color.black)
        .frame(width: 100, height: 100)
        .padding()
        .border(Color.black)
    }
}
