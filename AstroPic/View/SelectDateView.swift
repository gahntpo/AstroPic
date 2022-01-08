//
//  SelectDateView.swift
//  AstroPic
//
//  Created by Karin Prater on 10.09.20.
//  Copyright © 2020 Karin Prater. All rights reserved.
//

import SwiftUI

struct SelectDateView: View {
    
    @State private var date = Date()
    
    @ObservedObject var manager: NetworkManager
    
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        VStack {
            Text("Select a day").font(.headline)
            
            DatePicker(selection: $date, in: ...Date(), displayedComponents: .date) {
                Text("select")
            }.labelsHidden()
            
            Button(action: {
              
                self.manager.date = self.date
               
                self.presentation.wrappedValue.dismiss()
            }) {
                Text("Done")
            }
            
        }
    }
}

struct SelectDateView_Previews: PreviewProvider {
    static var previews: some View {
        SelectDateView(manager: NetworkManager())
    }
}
