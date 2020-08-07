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
    var sensors = [Sensor]()
    
    let mapCenter = CLLocationCoordinate2D(latitude: 60.227704, longitude: 24.983821)
    var region = MKCoordinateRegion()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let endpoint = "uiras2_v1"
        let url = uirasURL(with: endpoint)
        
        performRequest(url: url)
        
        region = MKCoordinateRegion(center: mapCenter, latitudinalMeters: 7000, longitudinalMeters: 12500)
        
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
        mapView.showsUserLocation = true
    }
    
    // MARK: - TODO data fetching
    func performRequest(url: URL) {
        // create URLSession
        let session = URLSession(configuration: .default)
            
        // give session task
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error as Any)
                return
            }
                
            if let safeData = data {
                self.parseJSON(responseData: safeData)
            }
        }
        // start the task
        task.resume()
    }

    func parseJSON(responseData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Response.self, from: responseData)
            for sensor in decodedData.sensors {
                sensors.append(sensor.value)
            }
            
            DispatchQueue.main.async {
                self.mapView.addAnnotations(self.sensors)
            }
            
        } catch {
            print(error)
        }
    }

    // MARK: - Actions
    // this puts user location on map
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
    
    // this constructs url string
    func uirasURL(with endPoint: String) -> URL {
        let urlString = String(format: "https://iot.fvh.fi/opendata/uiras/%@.json", endPoint)
        let url = URL(string: urlString)
        
        return url!
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKAnnotationView?
        
        return annotationView
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
