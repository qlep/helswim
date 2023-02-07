//
//  ViewController.swift
//  HelSwim
//
//  Created by GLEB TISHCHENKO on 24.7.2020.
//  Copyright © 2020 GLEB TISHCHENKO. All rights reserved.
//
import Foundation
import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var userLocation: CLLocation?
    var mapCenter = CLLocationCoordinate2D(latitude: 60.227704, longitude: 24.983821)
    var sensors = [Sensor]()
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let endpoint = "uiras2_v1"
        let url = uirasURL(with: endpoint)
        
        performRequest(url: url)
        
        showMapCenter()
    }
    
    // MARK: - Data fetching and parsing
    func performRequest(url: URL) {
        // create URLSession
        let session = URLSession(configuration: .default)
            
        // give session task
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    self.showNetworkError()
                }
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
    
    // decoding data JSON
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
    // this goes to user location on map
    @IBAction func showUserLocation() {
        // check for location tracing permissions first
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }

        if locationManager.authorizationStatus == .denied || locationManager.authorizationStatus == .restricted {
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
        
        if let mapCenter = controller.selectedSensorCoordinate  {
            let region = MKCoordinateRegion(center: mapCenter, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(mapView.regionThatFits(region), animated: true)
        } else {
            showMapCenter()
        }
    }

    // MARK: - Helper methods
    // handle permission errors
    func showLocationServicesDeniedAlert() {
        let title = NSLocalizedString("Location services denied", comment: "Localized location services alert title")
        let message = NSLocalizedString("Please, allow this app to use your location", comment: "Localized location services alert message")
       
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)
    }
    
    // handling networking errors
    func showNetworkError() {
        let title = NSLocalizedString("Oops...", comment: "Localaized network error alert title")
        let message = NSLocalizedString("An error occured while trying to connect to the server. " + "Please try again later", comment: "Localaized network error alert message")
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
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
            print("*** userLocation not nill")
        }
    }
    
    // this constructs url string
    func uirasURL(with endPoint: String) -> URL {
        let urlString = String(format: "https://iot.fvh.fi/opendata/uiras/%@.json", endPoint)
        let url = URL(string: urlString)
        
        return url!
    }
    
    // MARK: - Navigation
    // passing sensors array on to SensorListViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowList" {
            let controller = segue.destination as! SensorListViewController
            controller.sensors = sensors
        }
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard annotation is Sensor else {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Sensor")
        
        if annotationView == nil {
            let markerView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "Sensor")
            
            markerView.subtitleVisibility = .visible
            markerView.glyphText = ""
            // make invisible marker
            markerView.markerTintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)            
            
            // using customized image for marker
            let pinImage = UIImage(named: "lokkimarker")
            let size = CGSize(width: 35, height: 30)
            UIGraphicsBeginImageContext(size)
            pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            markerView.image = resizedImage
            
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
        
        if let index = sensors.firstIndex(of: annotation) {
            controller.sensor = sensors[index]
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
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        userLocation = newLocation
    }
}
