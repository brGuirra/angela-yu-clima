//
//  WeatherManager.swift
//  Clima
//
//  Created by Bruno Guirra on 26/02/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=324a72909dbe3b99ad76db523966f8e1"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        
        // 1. Create an URL
        if let url = URL(string: urlString) {
            
            // 2. Create an URLSession
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    return
                }
                
                if let data = data {
                    let dataString = String(data: data, encoding: .utf8 )
                    print(dataString!)
                }
            }
            
            // 4. Start the task
            task.resume()
        }
    }
}
