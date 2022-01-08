//
//  InteractiveImageView.swift
//  NASAProject
//
//  Created by Karin Prater on 09.09.20.
//  Copyright © 2020 Karin Prater. All rights reserved.
//

import SwiftUI

struct InteractiveImageView: View {
    
    let image: UIImage
    
    var body: some View {
        GeometryReader { geometry in
            Image(uiImage: self.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                
                .scaleEffect(self.magnification)
                .offset(self.offset)
                .gesture(self.pinch)
                .gesture(self.doubleTap)
                .gesture(self.drag(in: geometry.size))
                .clipped()
                .animation(.easeInOut)
        }.edgesIgnoringSafeArea([.bottom, .vertical])
            .navigationBarTitle("", displayMode: .inline)
        
    }
    
    @State private var steadyStateMagnifiction: CGFloat = 1
    @GestureState private var gestureMagnification: CGFloat = 1
    
    var magnification: CGFloat {
        steadyStateMagnifiction * gestureMagnification
    }
    
    let minimumScaleFactor: CGFloat = 0.5
    
    var pinch: some Gesture {
        MagnificationGesture()
            .updating($gestureMagnification) { (latestState, gestureMagnification, transaction) in
                if self.steadyStateMagnifiction * latestState >= self.minimumScaleFactor {
                    gestureMagnification = latestState
                }
        }.onEnded { (value) in
            if self.steadyStateMagnifiction * value >= self.minimumScaleFactor {
                self.steadyStateMagnifiction *= value
            }else {
                self.steadyStateMagnifiction = self.minimumScaleFactor
            }
        }
    }
    
       var doubleTap: some Gesture {
           TapGesture(count: 2).onEnded { _ in
               if self.magnification > 1 {
                   self.steadyStateMagnifiction = 1
                   self.steadyStateOffest = .zero
               }else {
                    self.steadyStateMagnifiction = 2
               }
              
               
           }
       }
    
    @State private var steadyStateOffest: CGSize = .zero
    @GestureState private var gesturOffset: CGSize = .zero
    
    var offset: CGSize {
        return (steadyStateOffest + gesturOffset) * magnification
    }
    
    private func drag(in size: CGSize) -> some Gesture {
        
        let imageSize = size.width * self.magnification
        let avaliableWidth = (imageSize - size.width) / 2
        
        return DragGesture(minimumDistance: 10, coordinateSpace: .local)
            .updating($gesturOffset) { (latestState, offset, transaction) in
                
                let newOffset = latestState.translation.width + self.steadyStateOffest.width * self.magnification
                
                if avaliableWidth > newOffset.magnitude {
                    offset = latestState.translation / self.magnification
                }
        }.onEnded { (value) in
            let newValue = value.translation.width + self.steadyStateOffest.width * self.magnification
            
            if avaliableWidth >= newValue.magnitude {
                self.steadyStateOffest = self.steadyStateOffest + (value.translation / self.magnification)
            }else {
                if value.translation.width < 0 {
                      self.steadyStateOffest = CGSize(width: -avaliableWidth / self.magnification, height: self.steadyStateOffest.height)
                }else {
                      self.steadyStateOffest = CGSize(width: avaliableWidth / self.magnification, height: self.steadyStateOffest.height)
                }
              
            }
        }
        
        
    }
}

//struct InteractiveImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        InteractiveImageView()
//    }
//}
