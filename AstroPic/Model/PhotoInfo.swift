//
//  PhotoInfo.swift
//  AstroPic
//
//  Created by Karin Prater on 10.09.20.
//  Copyright © 2020 Karin Prater. All rights reserved.
//

import Foundation
import SwiftUI

struct PhotoInfo: Codable, Identifiable {
    
    var title: String
    var description: String
    var url: URL?
    var copyright: String?
    var date: String
    
    let id = UUID()
    
    var image: UIImage? = nil
    
    var formattedDate: Date {
        let dateFormatter = API.createFormatter()
        return dateFormatter.date(from: self.date) ?? Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case description = "explanation"
        case url = "url"
        case copyright = "copyright"
        case date = "date"
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        self.title = try valueContainer.decode(String.self, forKey: CodingKeys.title)
        self.description = try valueContainer.decode(String.self, forKey: CodingKeys.description)
        self.url = try valueContainer.decode(URL.self, forKey: CodingKeys.url)
        self.copyright = try? valueContainer.decode(String.self, forKey: CodingKeys.copyright)
        self.date = try valueContainer.decode(String.self, forKey: CodingKeys.date)
    }
    
    init() {
        self.description = ""
        self.title = ""
        self.date = ""
        
    }
    
    static func createDefault() -> PhotoInfo {
        var photoInfo = PhotoInfo()
        photoInfo.title = "Jupiter's Swmimming Storm "
        photoInfo.description = "A bright storm head with a long turbulent wake swims across Jupiter in these sharp telescopic images of the Solar System's ruling gas giant. Captured on August 26, 28, and September 1 (left to right) the storm approximately doubles in length during that period. Stretching along the jetstream of the planet's North Temperate Belt it travels eastward in successive frames, passing the Great Red Spot and whitish Oval BA, famous storms in Jupiter's southern hemisphere. Galilean moons Callisto and Io are caught in the middle frame. In fact, telescopic skygazers following Jupiter in planet Earth's night have reported dramatic fast moving storm outbreaks over the past few weeks in Jupiter's North Temperate Belt."
        photoInfo.date = "2020-09-09"
        photoInfo.image = UIImage(named: "preview_image")
        return photoInfo
    }
}













//self.description = "long lasting description"
//       self.title = "title"
//       self.date = "2020-09-09"
