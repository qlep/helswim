//
//  ViewController.swift
//  HelSwim
//
//  Created by GLEB TISHCHENKO on 24.7.2020.
//  Copyright © 2020 GLEB TISHCHENKO. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var userLocation: CLLocation?
    var mapCenter = CLLocationCoordinate2D(latitude: 60.227704, longitude: 24.983821)    
    var sensorsArray = [Sensor]()
    let dataLoader = SensorDataLoader()
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
               
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataLoader.delegate = self
        dataLoader.getSensorData()
        showMapCenter()
    }

    // MARK: - Actions
    // this goes to user location on map
    @IBAction func showUserLocation() {
        // check for location tracing permissions first
        let authStatus = CLLocationManager.authorizationStatus()

        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }

        if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
            return
        }

        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)

        mapView.setRegion(mapView.regionThatFits(region), animated: true)

        getCoordinates()
    }
    
    @IBAction func showMapCenter() {
        
        mapCenter = CLLocationCoordinate2D(latitude: 60.227704, longitude: 24.983821)
        
        let region = MKCoordinateRegion(center: mapCenter, latitudinalMeters: 7000, longitudinalMeters: 12500)
        
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
    
    // when user taps sensor in sensor list unwinds segue here
    @IBAction func userDidPickSensorFromList(_ segue: UIStoryboardSegue) {
        let controller = segue.source as! SensorListViewController
        
        mapCenter = controller.selectedSensor.coordinate
        
        let region = MKCoordinateRegion(center: mapCenter, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }

    // MARK: - Helper methods
    // handle permission errors
    func showLocationServicesDeniedAlert() {
       
        let alert = UIAlertController(title: "Paikannuspalvelut pois päältä", message: "Ole hyvä ja salli paikannuspalvelut tälle äpille.", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)
    }
    
    // handling networking errors
    func showNetworkError() {
        
        let alert = UIAlertController(title: "Hupsista...", message: "Yhteydessä palveluun on tapahtunut häiriö" + "Ole hyvä ja yritä uudelleen", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    // get user coordinates
    func getCoordinates() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        
        // TODO: - Handle positioning errors
        
        if userLocation != nil {
            locationManager.stopUpdatingLocation()
            print("*** done locating \(String(describing: userLocation))")
        }
    }
    
    // MARK: - Navigation
    // passing sensors array on to SensorListViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowList" {
            let controller = segue.destination as! SensorListViewController
            controller.sensors = sensorsArray
        }
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // 1
        guard annotation is Sensor else {
            return nil
        }
        
        // 2
        let identifier = "Sensor"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            let markerView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            markerView.subtitleVisibility = .visible
            
            annotationView = markerView
        }
        
        return annotationView
    }
    
    // when annotation view is selected
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let annotation = view.annotation as! Sensor
        
        // this is how SensorDetailViewController is instantiated
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Detail") as! SensorDetailViewController
        
        if let index = sensorsArray.firstIndex(of: annotation) {
            controller.sensor = sensorsArray[index]
        }
        // present SensorDetailViewController popover on annotation view tap
        present(controller, animated: true)
        
        // deselecting annotation after controller presented
        mapView.deselectAnnotation(annotation, animated: true)
    }
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("*** Location manager failed with error: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        
        print("*** didUpdateLocations \(newLocation)")
        userLocation = newLocation
    }
}

// MARK: - SensorDataLoaderDelegate
extension MapViewController: SensorDataLoaderDelegate {
    func didUpdateSensors(sensors: [Sensor]) {
        sensorsArray = sensors
        DispatchQueue.main.async {
            self.mapView.addAnnotations(self.sensorsArray)
        }

    }
}
