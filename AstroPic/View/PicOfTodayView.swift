//
//  PicOfTodayView.swift
//  AstroPic
//
//  Created by Karin Prater on 10.09.20.
//  Copyright © 2020 Karin Prater. All rights reserved.
//

import SwiftUI

struct PicOfTodayView: View {
    
    @ObservedObject var manager = NetworkManager()
    
    @State private var showSwitchDate: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            
            Button(action: {
                self.showSwitchDate.toggle()
            }) {
                Image(systemName: "calendar")
                Text("switch day")
            }
            .padding(.trailing)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .popover(isPresented: $showSwitchDate) {
                SelectDateView(manager: self.manager)
            }
            
            
            if manager.image != nil {
                Image(uiImage: self.manager.image!)
                .resizable()
                .scaledToFit()
            }else {
               LoadingAnimationBox()
                .padding()
                    .frame(height: 300)
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text(manager.photoInfo.date).font(.title)
                    Text(manager.photoInfo.title).font(.headline)
                    Text(manager.photoInfo.description)
                }
            }.padding()
           
        }
    }
}

struct PicOfTodayView_Previews: PreviewProvider {
    static var previews: some View {
        
        let view = PicOfTodayView()
        view.manager.photoInfo = PhotoInfo.createDefault()
        view.manager.image = UIImage(named: "preview_image")
        return view
    }
}
