//
//  LoadingAnimationBox.swift
//  AstroPic
//
//  Created by Karin Prater on 10.09.20.
//  Copyright © 2020 Karin Prater. All rights reserved.
//

import SwiftUI

struct LoadingAnimationBox: View {
    
    let rainbowGradiend = Gradient(colors: [Color(hue: 1, saturation: 0, brightness: 0.7),
                                            Color(hue: 1, saturation: 0, brightness: 0.9),
                                            Color(hue: 1, saturation: 0, brightness: 0.5),
                                            Color(hue: 1, saturation: 0, brightness: 0.4)])
    
    @State private var startRadius: CGFloat = 10
    
    var body: some View {
        
        GeometryReader { geometry in
            
            RadialGradient(gradient: self.rainbowGradiend,
                           center: UnitPoint(x: 0.5, y: 0.5),
                           startRadius: self.startRadius,
                           endRadius: geometry.size.width * 0.5)
                
            .onAppear {
                      withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: true)) {
                        self.startRadius =  geometry.size.width * 0.1
                      }
              }
        }
    }
}


struct LoadingAnimationBox_Previews: PreviewProvider {
    static var previews: some View {
        LoadingAnimationBox()
    }
}

