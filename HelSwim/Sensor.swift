//
//  Ranta.swift
//  HelSwim
//
//  Created by GLEB TISHCHENKO on 24.7.2020.
//  Copyright © 2020 GLEB TISHCHENKO. All rights reserved.
//

import Foundation
import MapKit

public struct Response: Decodable {
    public var comment: String
    public var contact: String
    public var sensors = [String:Sensor]()
}

public struct Meta: Decodable {
    public var name: String = ""
    public var lat: Double = 0
    public var lon: Double = 0
    public var servicemap_url: String = ""
    public var site_url: String = ""
    public var file_created: String = ""
}

public struct SensorData: Decodable {
    public var time: String = ""
    public var temp_air: Double? = 0
    public var temp_water: Double? = 0

}

public class Sensor: NSObject, Decodable, MKAnnotation {

    public var meta = Meta()
    public var data = [SensorData]()
    
    override public var description: String {
        return "Name: \(meta.name), Latitude: \(meta.lat), Longitude: \(meta.lon), Servicemap URL: \(meta.servicemap_url), Site URL: \(meta.site_url)"
    }
    
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(meta.lat, meta.lon)
    }

    public var subtitle: String? {
        if meta.name == "" {
            return ("no name")
        } else {
            return meta.name
        }
    }
    
    public var title: String? {
        if data.last?.temp_water == nil {
            return ("")
        } else {
            return (String(format: "%.1f°C", data.last?.temp_water ?? ""))
        }
    }
    
    lazy var fav = false
}
