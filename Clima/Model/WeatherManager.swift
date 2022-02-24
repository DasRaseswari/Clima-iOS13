//
//  WeatherManager.swift
//  Clima
//
//  Created by Raseswari Das on 2/22/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//
import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=\(WeatherApiConfig().apiKey)"

    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        
//        let apiKey = WeatherApiConfig().apiKey
        
        let urlString = "\(weatherUrl)&q=\(cityName)"
//        print("---->URL is", urlString)
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherUrl)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        //Create a URL
        if let url = URL(string: urlString) {
            //Create a URLsession
            let session = URLSession(configuration: .default)
            
            //Give the session a task
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
//        print("JSON:",String(data: weatherData, encoding: .utf8) ?? "nil")
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print(decodedData)
            
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}
