//
//  APODListView.swift
//  AstroPic
//
//  Created by Karin Prater on 10.09.20.
//  Copyright © 2020 Karin Prater. All rights reserved.
//

import SwiftUI

struct APODListView: View {
    
    @ObservedObject var manager = MultiNetworkManager()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(manager.infos) { info in
                    
                    NavigationLink(destination: APODDetailView(photoInfo: info, manager: self.manager)) {
                        APODRow(photoInfo: info)
                    }
                        
                    .onAppear {
                        
                        if let index = self.manager.infos.firstIndex(where: { $0.id == info.id }),
                            index == self.manager.infos.count - 1 && self.manager.daysFromToday == self.manager.infos.count - 1 {
                            self.manager.getMoreData(for: 10)
                        }
                    }
                }
                
                
                ForEach(0..<15) { _ in
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 50)
                }
            }.navigationBarTitle("Picture of the Day")
        }
    }
    
}

struct APODListView_Previews: PreviewProvider {
    static var previews: some View {
        APODListView()
    }
}
