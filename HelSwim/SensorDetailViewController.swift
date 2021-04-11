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
    @IBOutlet weak var graphView: GraphView!
    
    override func viewWillAppear(_ animated: Bool) {
        graphView.sensorData = sensor.data
    }
    
    override func viewDidLoad() {
        
        navigationBar.topItem?.title = sensor.subtitle
        waterTempLabel.text = String(format: "%.1f°C", sensor.data.last?.temp_water ?? "")
        airTempLabel.text = String(format: "%.1f°C", sensor.data.last?.temp_air ?? "")
        
        makeMapSnapshot()
        
    }
    
    func makeMapSnapshot() {
        let region = MKCoordinateRegion(center: sensor.coordinate, latitudinalMeters: 50, longitudinalMeters: 200)
        let options = MKMapSnapshotter.Options()
        
        options.region = region
        options.mapType = .satellite
        
        let snapshotter = MKMapSnapshotter(options: options)
        
        snapshotter.start {
            snapshot, error in
            guard let snapshot = snapshot, error == nil else {return}
            
            let image = UIGraphicsImageRenderer(size: options.size).image {
                _ in
                
                snapshot.image.draw(at: .zero)
                
                let point = snapshot.point(for: self.sensor.coordinate)
                
                // marker annotation view implementation on snapshot
                let annotationView = MKMarkerAnnotationView(annotation: nil, reuseIdentifier: "test")
                annotationView.subtitleVisibility = .visible
                annotationView.titleVisibility = .visible
                annotationView.contentMode = .scaleAspectFit
                annotationView.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
                annotationView.drawHierarchy(in: CGRect(
                        x: point.x - annotationView.bounds.size.width / 2.0,
                        y: point.y - annotationView.bounds.size.height,
                        width: annotationView.bounds.width,
                        height: annotationView.bounds.height), afterScreenUpdates: true)
            }
            
            DispatchQueue.main.async {
                self.mapSnapshot.image = image
            }
        }
    }
}

