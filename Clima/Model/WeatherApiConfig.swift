//
//  WeatherApiConfig.swift
//  Clima
//
//  Created by Raseswari Das on 2/23/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherApiConfig {
    var apiKey: String {
        get {

            guard let filePath = Bundle.main.path(forResource: "Config-Info", ofType: "plist") else {
                fatalError("Couldn't find file 'Config-Info.plist'.")
            }

            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "API_KEY") as? String else {
                fatalError("Couldn't find key 'API_KEY' in 'Config-Info.plist'.")
            }
            return value
        }
    }
}
