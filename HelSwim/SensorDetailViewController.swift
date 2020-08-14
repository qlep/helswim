//
//  SensorDetailViewController.swift
//  HelSwim
//
//  Created by GLEB TISHCHENKO on 13.8.2020.
//  Copyright © 2020 GLEB TISHCHENKO. All rights reserved.
//

import UIKit

class SensorDetailViewController: UITableViewController {
    
    var sensor = Sensor()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var waterTempLabel: UILabel!
    @IBOutlet weak var airTempLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = sensor.subtitle
        waterTempLabel.text = "\(sensor.data.last?.temp_water ?? 0.0)°C"
        airTempLabel.text = "\(sensor.data.last?.temp_air ?? 0.0)°C"
    }
    
    // MARK: - Actions
    @IBAction func ok() {
        self.dismiss(animated: true, completion: nil)
    }
}
