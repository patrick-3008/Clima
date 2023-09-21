import Foundation

struct WeatherManager {
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=935d391d38090c00a2e92f2a0bac251c&units=metric"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherUrl)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        // 1. Create a Url
        if let url = URL(string: urlString) {
            
            // 2. Create a UrlSession
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a task
            let task = session.dataTask(with: url, completionHandler: { (data, reponse, error) in
                if error != nil {
                    print("give a session task error : \(error!)")
                    return
                }
                if let safeData = data {
                    parseJSON(weatherData: safeData)
                }
            })
            
            // 4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data){
        let decoder = JSONDecoder()
        do {
           let decodedData = try decoder.decode(WeatherJson.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            weather.conditionName
        } catch {
            print(error)
        }
    }
        
}
