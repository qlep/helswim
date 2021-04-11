//
//  SensorController.swift
//  HelSwim
//
//  Created by GLEB TISHCHENKO on 20.12.2020.
//  Copyright © 2020 GLEB TISHCHENKO. All rights reserved.
//

import Foundation

class SensorController {
    
    let url = URL(string: "https://iot.fvh.fi/opendata/uiras/uiras2_v1.json")!
    static let shared = SensorController()
    
    // load a dictionary of sensors
    func getSensors(completion: @escaping([Sensor]) -> Void) {
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            let decodedData = try! JSONDecoder().decode(Response.self, from: data)
            var sensors = [Sensor]()
            
            for sensor in decodedData.sensors {
                sensors.append(sensor.value)
            }
            
            completion(sensors)
        }
        
        task.resume()
    }
}
