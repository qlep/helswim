//
//  SensorMarkerView.swift
//  HelSwim
//
//  Created by GLEB TISHCHENKO on 9.7.2021.
//  Copyright © 2021 GLEB TISHCHENKO. All rights reserved.
//

import MapKit

class SensorMarkerView: MKMarkerAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
