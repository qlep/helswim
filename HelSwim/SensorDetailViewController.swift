//
//  SensorDetailViewController.swift
//  HelSwim
//
//  Created by GLEB TISHCHENKO on 13.8.2020.
//  Copyright © 2020 GLEB TISHCHENKO. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SensorDetailViewController: UITableViewController {
    
    var sensor = Sensor()
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var waterTempLabel: UILabel!
    @IBOutlet weak var airTempLabel: UILabel!
    @IBOutlet weak var mapSnapshot: UIImageView!
    
    override func viewDidLoad() {
        
        navigationBar.topItem?.title = sensor.subtitle
        waterTempLabel.text = String(format: "%.1f°C", sensor.data.last?.temp_water ?? "")
        airTempLabel.text = String(format: "%.1f°C", sensor.data.last?.temp_air ?? "")
        
        makeMapSnapshot()
    }
    
    func makeMapSnapshot() {
        let rect = mapSnapshot.bounds
        let region = MKCoordinateRegion(center: sensor.coordinate, latitudinalMeters: 50, longitudinalMeters: 200)
        
        let options = MKMapSnapshotter.Options()
        options.region = region
        options.mapType = .satelliteFlyover
        
        let snapshot = MKMapSnapshotter(options: options)
        
        snapshot.start {
            snapshot, error in
            guard let snapshot = snapshot, error == nil else {return}
            
            let image = UIGraphicsImageRenderer(size: options.size).image {
                _ in
                
                snapshot.image.draw(at: .zero)
                
                let pinView = MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)
                let pinImage = pinView.image
                
                var point = snapshot.point(for: self.sensor.coordinate)
                
                if rect.contains(point) {
                    point.x -= pinView.bounds.width / 2
                    point.y -= pinView.bounds.height / 2
                    point.x += pinView.centerOffset.x
                    point.y += pinView.centerOffset.y
                    pinImage?.draw(at: point)
                }
            }
            
            DispatchQueue.main.async {
                self.mapSnapshot.image = image
            }
        }
    }
}
