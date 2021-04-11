//
//  SensorWidgetView.swift
//  HelSwim
//
//  Created by GLEB TISHCHENKO on 19.10.2020.
//  Copyright © 2020 GLEB TISHCHENKO. All rights reserved.
//

import SwiftUI
import WidgetKit
import MapKit

struct SensorWidgetView: View {
    
    var body: some View {        
        ZStack {
            Image(uiImage: UIImage(named: "huigovnomuravei")!)
                .resizable()
                .aspectRatio(contentMode: .fill)
            Text("Хуй, говно и муравеее")
                .font(.title)
                .foregroundColor(.white)
        }
    }
}
