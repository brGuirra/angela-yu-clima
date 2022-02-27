//
//  WeatherManager.swift
//  Clima
//
//  Created by Bruno Guirra on 26/02/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    private var apiKey: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "OpenWeather-Info", ofType: "plist") else {
                fatalError("Couldn't find file 'OpenWeather-Info'.")
            }
            
            let plist = NSDictionary(contentsOfFile: filePath)
            
            guard let value = plist?.object(forKey: "API_KEY") as? String else {
                fatalError("Couldn't find 'API_KEY' in 'OpenWeather-Info'.")
            }
            
            return value
        }
    }
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)?q=\(cityName)&appid=\(apiKey)"
        
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    return
                }
                
                if let data = data {
                    self.parseJSON(data: data)
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(data: Data) {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: data)
            let id = decodedData.weather[0].id
            
            print(getConditionName(conditionId: id))
        } catch {
            print(error)
        }
    }
    
    func getConditionName(conditionId: Int) -> String {
        switch conditionId {
            case 200...232:
                return "cloud.bolt"
            case 300...321:
                return "cloud.drizzle"
            case 500...531:
                return "cloud.rain"
            case 600...622:
                return "cloud.snow"
            case 701...781:
                return "cloud.fog"
            case 800:
                return "sun.max"
            case 801...804:
                return "cloud.bolt"
            default:
                return "cloud"
        }

    }
}
