//
//  SensorDataLoader.swift
//  HelSwim
//
//  Created by GLEB TISHCHENKO on 19.10.2020.
//  Copyright © 2020 GLEB TISHCHENKO. All rights reserved.
//

import Foundation

protocol SensorDataLoaderDelegate   {
    func didUpdateSensors(sensors: [Sensor])
}

public class SensorDataLoader {
    
    public let endpoint = "uiras2_v1"
    var delegate: SensorDataLoaderDelegate?
    
    // Data fetching and parsing class
    public func getSensorData() {
        // create URLSession
        let url = uirasURL(with: endpoint)
        let session = URLSession(configuration: .default)
        var sensors = [Sensor]()
            
        // give session task
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error as Any)
                return
            }
            
            if let safeData = data {
                let result = self.parse(responseData: safeData)
                
                for sensor in result!.sensors {
                    sensors.append(sensor.value)
                    print(sensor)
                }
                self.delegate?.didUpdateSensors(sensors: sensors)
            }
        }
        // start the task
        task.resume()
    }
    
     // decoding data JSON
    func parse(responseData: Data) -> Response? {
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(Response.self, from: responseData)
            
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }
    
    // this constructs url string
    func uirasURL(with endPoint: String) -> URL {
        let urlString = String(format: "https://iot.fvh.fi/opendata/uiras/%@.json", endPoint)
        let url = URL(string: urlString)
        
        return url!
    }
    
}
