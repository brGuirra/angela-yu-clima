//
//  WeatherManager.swift
//  Clima
//
//  Created by Bruno Guirra on 26/02/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
}

struct WeatherManager {
    var delegate: WeatherManagerDelegate?

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
        let urlString = "\(weatherURL)?q=\(cityName)&units=metric&appid=\(apiKey)"
        
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    return
                }
                
                if let data = data {
                    if let weather = self.parseJSON(data) {
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: data)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            return weather
        } catch {
            print(error)
            return nil
        }
    }
}
