//
//  url helper.swift
//  NASAProject
//
//  Created by Karin Prater on 09.09.20.
//  Copyright © 2020 Karin Prater. All rights reserved.
//

import Foundation


extension URL {
    func withQuery(_ query: [String: String]) -> URL? {
        // adds query to URL in correct format
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = query.map { URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
    }
}
