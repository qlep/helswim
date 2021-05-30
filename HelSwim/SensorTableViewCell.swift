//
//  SensorTableViewCell.swift
//  HelSwim
//
//  Created by GLEB TISHCHENKO on 25.4.2021.
//  Copyright © 2021 GLEB TISHCHENKO. All rights reserved.
//

import UIKit
import MapKit

class SensorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var waterTempLabel: UILabel!
    @IBOutlet weak var airTempLabel: UILabel!
    @IBOutlet weak var sensorTitleLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var waterStackView: UIStackView!
    @IBOutlet weak var airStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()       
        
        mapView.layer.cornerRadius = mapView.bounds.size.width / 2
        mapView.clipsToBounds = true
        separatorInset = UIEdgeInsets(top: 0, left: 80, bottom: 0, right: 0)
    }
}
