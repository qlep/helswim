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
    @IBOutlet weak var navigationBar: UINavigationBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.topItem?.title = sensor.subtitle
        titleLabel.text = sensor.subtitle
        waterTempLabel.text = String(format: "%.1f°C", sensor.data.last?.temp_water ?? "")
        airTempLabel.text = String(format: "%.1f°C", sensor.data.last?.temp_water ?? "")
    }
    
    // MARK: - Actions
    @IBAction func ok() {
        self.dismiss(animated: true, completion: nil)
    }
}
