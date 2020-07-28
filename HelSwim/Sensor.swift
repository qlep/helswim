//
//  Ranta.swift
//  HelSwim
//
//  Created by GLEB TISHCHENKO on 24.7.2020.
//  Copyright © 2020 GLEB TISHCHENKO. All rights reserved.
//

import Foundation
import MapKit

public class Sensor: NSObject, Codable, MKAnnotation {
    
    public var name: String = ""
    public var lat: Double = 0
    public var lon: Double = 0
    public var servicemap_url: String = ""
    public var site_url: String = ""
    
    override public var description: String {
        return "Name: \(name), Latitude: \(lat), Longitude: \(lon), Servicemap URL: \(servicemap_url), Site URL: \(site_url)"
    }
    
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(lat, lon)
    }
    
    public var title: String? {
        if name == "" {
            return ("no name")
        } else {
            return name
        }
    }
}
