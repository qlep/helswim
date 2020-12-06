//
//  SensorDataLoader.swift
//  HelSwim
//
//  Created by GLEB TISHCHENKO on 19.10.2020.
//  Copyright © 2020 GLEB TISHCHENKO. All rights reserved.
//

import Foundation

public class SensorDataLoader {
    
    let endpoint = "uiras2_v1"
    public var sensors = [Sensor]()
    
    func random() -> Sensor {
        getSensors()
        let randomIndex = Int.random(in: 0..<sensors.count)
        return sensors[randomIndex]
    }
    
    // Data fetching and parsing class
    public func getSensors(){
        // create URLSession
        let url = uirasURL(with: endpoint)
        let session = URLSession.shared  
            
        // give session task
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print(error as Any)
                return
            }
            if let safeData = data {
                self.parse(responseData: safeData)
            }
        }
        // start the task
        task.resume()
    }
    
     // decoding data JSON
    func parse(responseData: Data) {
        var result = [Sensor]()

        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Response.self, from: responseData)

            for sensor in decodedData.sensors {
                result.append(sensor.value)
            }
        } catch {
            print(error)
        }
    }
    
    // this constructs url string
    func uirasURL(with endPoint: String) -> URL {
        let urlString = String(format: "https://iot.fvh.fi/opendata/uiras/%@.json", endPoint)
        let url = URL(string: urlString)
        
        return url!
    }
    
}
