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
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var waterTempLabel: UILabel!
    @IBOutlet weak var airTempLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.mapType = .satellite
        
        let mapCenter = sensor.coordinate
        let region = MKCoordinateRegion(center: mapCenter, latitudinalMeters: 70, longitudinalMeters: 50)
        
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
        
        navigationBar.topItem?.title = sensor.subtitle
        waterTempLabel.text = String(format: "%.1f°C", sensor.data.last?.temp_water ?? "")
        airTempLabel.text = String(format: "%.1f°C", sensor.data.last?.temp_water ?? "")
    }
    
    // MARK: - Actions
    @IBAction func ok() {
        self.dismiss(animated: true, completion: nil)
    }
}
