//
//  SensorDataLoader.swift
//  HelSwim
//
//  Created by GLEB TISHCHENKO on 19.10.2020.
//  Copyright © 2020 GLEB TISHCHENKO. All rights reserved.
//

import Foundation

public class SensorDataLoader {
    
    init() {
        print("*** data loader init now")
    }
    
    let endpoint = "uiras2_v1"
    
    // Data fetching and parsing class
    public func getSensors() -> [Sensor] {
        // create URLSession
        let url = uirasURL(with: endpoint)
        let session = URLSession.shared
        var sensors = [Sensor]()
        
        // give session task
        let task = session.dataTask(with: url) { [self] (data, response, error) in
            
            if error != nil {
                print(error as Any)
                return
            }
            DispatchQueue.main.async {
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode(Response.self, from: safeData)

                        for sensor in decodedData.sensors {
                            sensors.append(sensor.value)
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
        // start the task
        task.resume()
        return sensors
    }
    
    // this constructs url string
    func uirasURL(with endPoint: String) -> URL {
        let urlString = String(format: "https://iot.fvh.fi/opendata/uiras/%@.json", endPoint)
        let url = URL(string: urlString)
        
        return url!
    }
    
}
