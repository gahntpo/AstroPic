//
//  NetworkManager.swift
//  AstroPic
//
//  Created by Karin Prater on 10.09.20.
//  Copyright © 2020 Karin Prater. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class NetworkManager: ObservableObject {
    
    @Published var date: Date = Date()
    
    @Published var photoInfo = PhotoInfo()
    @Published var image: UIImage? = nil
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        
        $date.removeDuplicates()
            .sink { (value) in
                self.image = nil
        }.store(in: &subscriptions)
        
        
        $date.removeDuplicates()
            .map {
                API.createURL(for: $0)
        }.flatMap { (url) in
            API.createPublisher(url: url)
        }
        .receive(on: RunLoop.main)
        .assign(to: \.photoInfo, on: self)
        .store(in: &subscriptions)
        
        $photoInfo
            .filter { $0.url != nil }
            .map { photoInfo  -> URL in
                return photoInfo.url!
        }.flatMap { (url) in
            URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .catch({ error in
                    return Just(Data())
                })
        }.map { (out) -> UIImage? in
            UIImage(data: out)
        }
        .receive(on: RunLoop.main)
        .assign(to: \.image, on: self)
        .store(in: &subscriptions)
        
    }
    
   
}
