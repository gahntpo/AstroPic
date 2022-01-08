//
//  MultiNetworkManager.swift
//  AstroPic
//
//  Created by Karin Prater on 10.09.20.
//  Copyright © 2020 Karin Prater. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class MultiNetworkManager: ObservableObject {
    
    @Published var infos = [PhotoInfo]()
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var daysFromToday: Int = 0
    
    init() {
        
//        let times = 0..<10
//       times.publisher
        $daysFromToday
            .map { daysFromToday in
               return API.createDate(daysFromToday: daysFromToday)
        }.map { date in
            return API.createURL(for: date)
        }.flatMap { (url) in
            return API.createPublisher(url: url)
        }.scan([]) { (partialValue, newValue)  in
            return partialValue + [newValue]
        }
            
        .tryMap({ (infos)  in
            infos.sorted { $0.formattedDate > $1.formattedDate }
        })
            .catch { (error)  in
                Just([PhotoInfo]())
        }
        .eraseToAnyPublisher()
        .receive(on: RunLoop.main)
        .assign(to: \.infos, on: self)
        .store(in: &subscriptions)
        
        getMoreData(for: 20)
        
    }
    
    func getMoreData(for times: Int) {
        for _ in 0..<times {
            self.daysFromToday += 1
        }
    }
    
    func fetchImage(for photoInfo: PhotoInfo) {
        //fetch image from photoInfo.url
        //set image to photInfo.image
        
        guard photoInfo.image == nil, let url = photoInfo.url else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("fetch image error: \(error.localizedDescription)")
            }else if let data = data, let image = UIImage(data: data),
                let index = self.infos.firstIndex(where: { $0.id == photoInfo.id }) {
                
                DispatchQueue.main.async {
                      self.infos[index].image = image
                }
            }
            
        }
        task.resume()
    }
    
}
