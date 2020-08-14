//
//  SensorListViewController.swift
//  HelSwim
//
//  Created by GLEB TISHCHENKO on 14.8.2020.
//  Copyright © 2020 GLEB TISHCHENKO. All rights reserved.
//

import UIKit

class SensorListViewController: UITableViewController {
    
    var sensors: [Sensor] = []
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sensors = sensors.sorted(by: {
            return $0.data.last!.temp_water! > $1.data.last!.temp_water! }
        )
    }
    
    // MARK: - Table View Delegates
    // number of rows in table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sensors.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Sensor", for: indexPath)
        let sensor = sensors[indexPath.row]
        
        cell.textLabel?.text = sensor.subtitle
        cell.detailTextLabel?.text = "\(sensor.data.last?.temp_water ?? 0.0)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("*** hui")
    }
}
