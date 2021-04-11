//
//  GraphView.swift
//  HelSwim
//
//  Created by GLEB TISHCHENKO on 22.3.2021.
//  Copyright © 2021 GLEB TISHCHENKO. All rights reserved.
//

import UIKit

class GraphView: UIView {
    // MARK: - Properties
    var sensorData = [SensorData]()
    
    private enum Constants {
        static let cornerRadiusSize = CGSize(width: 8.0, height: 8.0)
        static let margin: CGFloat = 20.0
        static let topBorder: CGFloat = 50
        static let bottomBorder: CGFloat = 30
        static let colorAlpha: CGFloat = 0.5
        static let circleDiameter: CGFloat = 5.0
    }
    
    // gradient colors
    @IBInspectable var startColor: UIColor = .green
    @IBInspectable var endColor: UIColor = .lightGray

    // MARK: - draw
    override func draw(_ rect: CGRect) {
        let width = rect.width
        let height = rect.height
        
        // make corners round
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: Constants.cornerRadiusSize)
        path.addClip()
        
        // MARK: - gradient
        // make gradient background
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let colors = [startColor.cgColor, endColor.cgColor] as CFArray
        
        // set rgb color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        // define gradient
        guard let gradient = CGGradient(
                colorsSpace: colorSpace,
                colors: colors as CFArray,
                locations: colorLocations) else { return }
        
        // draw gradient
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: bounds.height)
        
        context.drawLinearGradient(gradient,
                                   start: startPoint,
                                   end: endPoint, options: [])
        
        // MARK: - drawing graph
        let dataBegin = sensorData.count - 48
        let last24HData = sensorData[dataBegin...]
        var last24HWater: [Double] = []
        var last24HAir: [Double] = []
    
        for data in last24HData {
            last24HAir.append(data.temp_air!)
            last24HWater.append(data.temp_water!)
        }
        
        let graphPoints = [4, 2, 6, 4, 5, 8, 3]
        
        // x point
        let margin = Constants.margin
        let graphWidth = width - margin * 2 - 4
        let columnXPoint = {
            (column: Int) -> CGFloat in
            // gap between points
            let spacing = graphWidth / CGFloat(graphPoints.count - 1)
            return CGFloat(column) * spacing + margin + 2
        }
        
        // y point
        let topBorder = Constants.topBorder
        let bottomBorder = Constants.bottomBorder
        let graphHeight = height - topBorder - bottomBorder
        
        guard let maxValue = graphPoints.max() else { return }
        
        let columnYPoint = { (graphPoint: Int) -> CGFloat in
            let yPoint = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
            
            return graphHeight + topBorder - yPoint
        }
        
        UIColor.white.setFill()
        UIColor.white.setStroke()
        
        let airGraph = UIBezierPath()
        
        airGraph.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(graphPoints[0])))
        
        for i in 1..<graphPoints.count {
            let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            airGraph.addLine(to: nextPoint)
        }
        
    }

}
