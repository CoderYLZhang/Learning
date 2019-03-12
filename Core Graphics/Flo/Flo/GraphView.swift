//
//  GraphView.swift
//  Flo
//
//  Created by 张银龙 on 2019/3/10.
//  Copyright © 2019 yinlong. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView {

    private struct Constants {
        static let cornerRadiusSize = CGSize(width: 8.0, height: 8.0)
        static let margin: CGFloat = 20.0
        static let topBorder: CGFloat = 60
        static let bottomBorder: CGFloat = 50
        static let colorAlpha: CGFloat = 0.3
        static let circleDiameter: CGFloat = 5.0
    }
    
    @IBInspectable var startColor: UIColor = .red
    @IBInspectable var endColor: UIColor = .green
    
    //Weekly sample data
    var graphPoints = [4, 2, 6, 4, 5, 8, 3]
    
    /*
     There are a few things to go over here:
     1. You set up the start and end colors for the gradient as @IBInspectable properties, so that you’ll be able to change them in the storyboard.
     2. CG drawing functions need to know the context in which they will draw, so you use the UIKit method UIGraphicsGetCurrentContext() to obtain the current context. That’s the one that draw(_:) draws into.
     3. All contexts have a color space. This could be CMYK or grayscale, but here you’re using the RGB color space.
     4. The color stops describe where the colors in the gradient change over. In this example, you only have two colors, red going to green, but you could have an array of three stops, and have red going to blue going to green. The stops are between 0 and 1, where 0.33 is a third of the way through the gradient.
     5. Create the actual gradient, defining the color space, colors and color stops.
     6. Finally, you draw the gradient. CGContextDrawLinearGradient() takes the following parameters:
            The CGContext in which to draw
            The CGGradient with color space, colors and stops
            The start point
            The end point
     Option flags to extend the gradient
     */
    override func draw(_ rect: CGRect) {
        
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: .allCorners,
                                cornerRadii: Constants.cornerRadiusSize)
        path.addClip()
        
        
        
        let context = UIGraphicsGetCurrentContext()!
        let colors = [startColor.cgColor, endColor.cgColor]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors as CFArray,
                                  locations: colorLocations)!
        
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: bounds.height)
        context.drawLinearGradient(gradient,
                                   start:startPoint,
                                   end: endPoint,
                                   options: [])
        
        let width = rect.width
        let height = rect.height
        
        //calculate the x point
        
        let margin = Constants.margin
        let graphWidth = width - margin * 2 - 4
        let columnXPoint = { (column: Int) -> CGFloat in
            //Calculate the gap between points
            let spacing = graphWidth / CGFloat(self.graphPoints.count - 1)
            return CGFloat(column) * spacing + margin + 2
        }
        
        // calculate the y point
        
        let topBorder = Constants.topBorder
        let bottomBorder = Constants.bottomBorder
        let graphHeight = height - topBorder - bottomBorder
        let maxValue = graphPoints.max()!
        let columnYPoint = { (graphPoint: Int) -> CGFloat in
            let y = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
            return graphHeight + topBorder - y // Flip the graph
        }
        
        // draw the line graph
        
        UIColor.white.setFill()
        UIColor.white.setStroke()
        
        // set up the points line
        let graphPath = UIBezierPath()
        
        // go to start of line
        graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(graphPoints[0])))
        
        // add points for each item in the graphPoints array
        // at the correct (x, y) for the point
        for i in 1 ..< graphPoints.count {
            let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            graphPath.addLine(to: nextPoint)
        }
        //draw the line on top of the clipped gradient
        graphPath.lineWidth = 2.0
        graphPath.stroke()
        
        //Create the clipping path for the graph gradient
        
        /*
         1. context.saveGState() is commented out for now -- you’ll come back to this in a moment once you understand what it does.
         2. Copy the plotted path to a new path that defines the area to fill with a gradient.
         3. Complete the area with the corner points and close the path. This adds the bottom-right and bottom-left points of the graph.
         4. Add the clipping path to the context. When the context is filled, only the clipped path is actually filled.
         5. Fill the context. Remember that rect is the area of the context that was passed to draw(_:).
         */
        
        //1 - save the state of the context (commented out for now)
        context.saveGState()
        //2 - make a copy of the path
        let clippingPath = graphPath.copy() as! UIBezierPath
        
        //3 - add lines to the copied path to complete the clip area
        clippingPath.addLine(to: CGPoint(x: columnXPoint(graphPoints.count - 1), y:height))
        clippingPath.addLine(to: CGPoint(x:columnXPoint(0), y:height))
        clippingPath.close()
        
        //4 - add the clipping path to the context
        clippingPath.addClip()
        /*
         //5 - check clipping path - temporary code
         UIColor.green.setFill()
         let rectPath = UIBezierPath(rect: rect)
         rectPath.fill()
         //end temporary code
         */
        
        let highestYPoint = columnYPoint(maxValue)
        let graphStartPoint = CGPoint(x: margin, y: highestYPoint)
        let graphEndPoint = CGPoint(x: margin, y: bounds.height)
        
        context.drawLinearGradient(gradient, start: graphStartPoint, end: graphEndPoint, options: [])
        context.restoreGState()
        
        //Draw the circles on top of the graph stroke
        for i in 0..<graphPoints.count {
            var point = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            point.x -= Constants.circleDiameter / 2
            point.y -= Constants.circleDiameter / 2
            
            let circle = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(width: Constants.circleDiameter, height: Constants.circleDiameter)))
            circle.fill()
        }
        
        //Draw horizontal graph lines on the top of everything
        let linePath = UIBezierPath()
        
        //top line
        linePath.move(to: CGPoint(x: margin, y: topBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: topBorder))
        
        //center line
        linePath.move(to: CGPoint(x: margin, y: graphHeight/2 + topBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: graphHeight/2 + topBorder))
        
        //bottom line
        linePath.move(to: CGPoint(x: margin, y:height - bottomBorder))
        linePath.addLine(to: CGPoint(x:  width - margin, y: height - bottomBorder))
        let color = UIColor(white: 1.0, alpha: Constants.colorAlpha)
        color.setStroke()
        
        linePath.lineWidth = 1.0
        linePath.stroke()
    }

}
