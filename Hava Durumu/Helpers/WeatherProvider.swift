//
//  JSONService.swift
//  Hava Durumu
//
import CoreLocation

/// API üzerinden gelen bilgileri çekmemizi sağlar.
class WeatherProvider {
    
    // MARK: - Properties tps://api.weatherbit.io/v2.0/forecast/daily
    private let apiKey = "0683c28a9d744b9c978852763802c921"
    private let baseURL = URL(string: "http://api.weatherbit.io/v2.0/current")!
    private let jsonDecoder = JSONDecoder()
    
    // MARK: - Functions
    func getWeather(for location: CLLocationCoordinate2D, completion: @escaping (Weather?) -> Void) {
        let queries: [String : String] = [
            "lat": String(location.latitude),
            "lon": String(location.longitude),
            "lang": "tr",
            "key": apiKey
        ]
        let requestURL = baseURL.withQueries(queries)!
        
        URLSession.shared.dataTask(with: requestURL) { data, _, _ in
            guard let weatherData = data else {
                completion(nil)
                return
            }
            do {
                let weather = try self.jsonDecoder.decode(Weather.self, from: weatherData)
                DispatchQueue.main.async {
                    completion(weather)
                }
            } catch {
                completion(nil)
                print("Error: \(error.localizedDescription)")
            }
        }.resume()
    }
}
