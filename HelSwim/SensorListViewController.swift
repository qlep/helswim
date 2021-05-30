//
//  SensorListViewController.swift
//  HelSwim
//
//  Created by GLEB TISHCHENKO on 14.8.2020.
//  Copyright © 2020 GLEB TISHCHENKO. All rights reserved.
//

import UIKit
import MapKit

class SensorListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var sensors: [Sensor] = []
    var selectedSensorCoordinate: CLLocationCoordinate2D?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // sort sensors in shorthand closure by water temperature attribute in descending order
        sensors = sensors.sorted { $0.data.last!.temp_water! > $1.data.last!.temp_water! }
    }
    
    // MARK: - Navigation
    // when user taps sensor in sensor list
    // need to remember to give unwind segue id in storyboard
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickedFromList" {
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: cell) {
                if indexPath == IndexPath(row: 0, section: 0) {
                    selectedSensorCoordinate = nil
                } else {
                    selectedSensorCoordinate = sensors[indexPath.row - 1].coordinate
                }
            }
        }
    }
    
    // MARK: - Table View Delegates
    // number of rows in table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sensors.count
    }
    
    // customize cell view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Sensor", for: indexPath) as! SensorTableViewCell
        let mapCenter = CLLocationCoordinate2D(latitude: 60.227704, longitude: 24.983821)
        var region = MKCoordinateRegion(center: mapCenter, latitudinalMeters: 10000, longitudinalMeters: 12500)
        
        if indexPath == IndexPath(row: 0, section: 0) {
            cell.sensorTitleLabel.text = "Show all"
            cell.waterStackView.isHidden = true
            cell.airStackView.isHidden = true
            
        } else {
            let sensor = sensors[indexPath.row - 1]
            
            if sensor.subtitle == "Herttoniemi (Tuorinniemen uimalaituri)" {
                cell.sensorTitleLabel.text = "Herttoniemen uimaranta"
            } else {
                cell.sensorTitleLabel.text = sensor.subtitle
            }
            
            if sensor.fav {
                cell.sensorTitleLabel.text = "★ " + sensor.subtitle!
            }
            
            cell.waterStackView.isHidden = false
            cell.airStackView.isHidden = false
            cell.waterTempLabel.text = String(format: "%.1f°C", sensor.data.last?.temp_water ?? "")
            cell.airTempLabel.text = String(format: "%.1f°C", sensor.data.last?.temp_air ?? "")
            
            region = MKCoordinateRegion(center: sensor.coordinate, latitudinalMeters: 10000, longitudinalMeters: 12500)
        }
        
        
        
        cell.mapView.setRegion(cell.mapView.regionThatFits(region), animated: true)
        cell.mapView.mapType = .satelliteFlyover
        cell.mapView.subviews[1].isHidden = true
        
        return cell
    }
    
    // when cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
