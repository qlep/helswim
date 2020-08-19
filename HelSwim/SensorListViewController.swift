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
    var selectedSensor = Sensor()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sort sensors in shorthand closure by water temperature attribute in descending order
        sensors = sensors.sorted { $0.data.last!.temp_water! > $1.data.last!.temp_water! }
    }
    
    // MARK: - Actions
    @IBAction func ok() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    // when user taps sensor in sensor list
    // need to remember to give unwind segue id in storyboard
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickedFromList" {
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: cell) {
                selectedSensor = sensors[indexPath.row]
            }
        }
    }
    
    // MARK: - Table View Delegates
    // number of rows in table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sensors.count
    }
    
    // customize cell view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Sensor", for: indexPath)
        let sensor = sensors[indexPath.row]
        
        cell.textLabel?.text = sensor.subtitle
//        cell.detailTextLabel?.text = "\(sensor.data.last?.temp_water ?? 0.0)"
        cell.detailTextLabel?.text = String(format: "%.1f°C", sensor.data.last?.temp_water! ?? "")
        
        return cell
    }
    
    // when cell is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
