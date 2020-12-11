//
//  SensorDetailViewController.swift
//  HelSwim
//
//  Created by GLEB TISHCHENKO on 13.8.2020.
//  Copyright © 2020 GLEB TISHCHENKO. All rights reserved.
//

import UIKit
import MapKit

class SensorDetailViewController: UITableViewController {
    
    var sensor = Sensor()
    
    var suosikki = false
            
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var FavLabel: UILabel!
    @IBOutlet weak var waterTempLabel: UILabel!
    @IBOutlet weak var airTempLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.mapType = .satellite
        
        let region = MKCoordinateRegion(center: sensor.coordinate, latitudinalMeters: 50, longitudinalMeters: 100)
        
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
        
        navigationBar.topItem?.title = sensor.subtitle
        waterTempLabel.text = String(format: "%.1f°C", sensor.data.last?.temp_water ?? "")
        airTempLabel.text = String(format: "%.1f°C", sensor.data.last?.temp_air ?? "")
        
        if sensor.fav {
            FavLabel.text = "★"
        }
    }
    
    // MARK: - TableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        sensor.fav.toggle()
        
        if sensor.fav {
            FavLabel.text = "★"
        } else {
            FavLabel.text = "☆"
        }
    }
}
