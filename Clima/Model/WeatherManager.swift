//
//  WeatherManager.swift
//  Clima
//
//  Created by Raseswari Das on 2/22/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//
import Foundation

struct WeatherManager {
    
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?units=metric"
    
    func fetchWeather(cityName: String) {
        
        let appConfig = WeatherApiConfig()
        
        let urlString = "\(weatherUrl)&q=\(cityName)&appid=\(appConfig.apiKey)"
//        print("---->URL is", urlString)
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        //Create a URL
        if let url = URL(string: urlString) {
            //Create a URLsession
            let session = URLSession(configuration: .default)
            
            //Give the session a task
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    parseJSON(weatherData: safeData)
                }
            }
            //Start the task
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) {
//        print("JSON:",String(data: weatherData, encoding: .utf8) ?? "nil")
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print(decodedData)
            
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            print(weather.conditionName)
            print(weather.temperatureString)
            
        } catch {
            print(error)
        }
    }
    
    
}
