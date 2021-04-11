//  Sensor_Widget.swift
//  Sensor Widget
//  Created by GLEB TISHCHENKO on 19.10.2020.
//  Copyright © 2020 GLEB TISHCHENKO. All rights reserved.
//

import WidgetKit
import SwiftUI
import MapKit

// timeline builder creates instances of TimelineEntry
struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> SensorsEntry {
        let entry = SensorsEntry(date: Date(), sensors: [Sensor]())
        
        return entry
    }
    
    typealias Entry = SensorsEntry
    
    var loader = SensorController()
    var sensorDataLoader = SensorDataLoader()
    var sensorsArray = [Sensor]()
    
    // snapshot of a widget for the library
    func getSnapshot(in context: Context, completion: @escaping (SensorsEntry) -> Void) {
        let entry = SensorsEntry(date: Date(), sensors: [Sensor]())
        
        completion(entry)
    }
    
    // timeline for widget updates every 30 mins
    func getTimeline(in context: Context, completion: @escaping (Timeline<SensorsEntry>) -> Void) {
        let dateComponents = DateComponents(minute: 1)
        let dateInFuture = Calendar.current.date(byAdding: dateComponents, to: Date())
        
        sensorDataLoader.getSensorData()
        
        // load sensors
        loader.getSensors {
            (sensors) in            
            let entry = SensorsEntry(date: Date(), sensors: sensors)
            let timeline = Timeline(entries: [entry], policy: .after(dateInFuture!))
            
            completion(timeline)
        }
    }
}


// data model to present in widget view
struct SensorsEntry: TimelineEntry {
    let date: Date
    let sensors: [Sensor]
}

// widget view presenting TimelineEntry
struct SensorWidgetEntryView : View {
    var entry: SensorsEntry
    
    var body: some View {
        ZStack {
            Image(uiImage: UIImage(named: "huigovnomuravei")!)
                .resizable()
                .aspectRatio(contentMode: .fill)
            Text(returnRandomSensor()!.title!)
                .font(.subheadline)
                .foregroundColor(.white)
        }
    }
    
    func returnRandomSensor() -> Sensor? {
        let sensors = entry.sensors
        
        if  sensors.count != 0 {
            for sensor in sensors {
                print(sensor.subtitle!)
            }
            
            return sensors[Int.random(in: 0..<sensors.count)]
            
        } else {
            print("no data")
        }
        
        return nil
    }
    
    func makeMapSnapshot() {
        let sensor = returnRandomSensor()
        
        if sensor != nil {
            print("*** making snapshot for \(sensor?.subtitle ?? " ")")
            
            let region = MKCoordinateRegion(center: sensor!.coordinate, latitudinalMeters: 50, longitudinalMeters: 200)
            let options = MKMapSnapshotter.Options()
            
            options.region = region
            options.mapType = .satellite
            
            let snapshotter = MKMapSnapshotter(options: options)
            
            snapshotter.start {
                snapshot, error in
                guard let snapshot = snapshot, error == nil else {return}
                
                let image = UIGraphicsImageRenderer(size: options.size).image {
                    _ in
                    
                    snapshot.image.draw(at: .zero)
                    
                    let point = snapshot.point(for: sensor!.coordinate)
                    
                    // marker annotation view implementation on snapshot
                    let annotationView = MKMarkerAnnotationView(annotation: nil, reuseIdentifier: "test")
                    annotationView.subtitleVisibility = .visible
                    annotationView.titleVisibility = .visible
                    annotationView.contentMode = .scaleAspectFit
                    annotationView.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
                    annotationView.drawHierarchy(in: CGRect(
                            x: point.x - annotationView.bounds.size.width / 2.0,
                            y: point.y - annotationView.bounds.size.height,
                            width: annotationView.bounds.width,
                            height: annotationView.bounds.height), afterScreenUpdates: true)
                }
                
                DispatchQueue.main.async {
                    // display snapshot image here
                    print(image)
                    
                }
            }
        }
    }
}

// widget's main app entry point
@main
struct SensorWidget: Widget {
    let kind: String = "SensorWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            SensorWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct SensorWidgetPreviews: PreviewProvider {
    static var previews: some View {
        SensorWidgetEntryView(entry: SensorsEntry(date: Date(), sensors: [Sensor]()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
