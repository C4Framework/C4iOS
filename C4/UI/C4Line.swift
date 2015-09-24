// Copyright © 2014 C4
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions: The above copyright
// notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.

import Foundation
import CoreGraphics

public class C4Line: C4Polygon {
    /**
    Returns a tuple of points that make up the the begin and end points of the line.

    Assigning a tuple of C4Point values to this object will cause the receiver to update itself.
    */
    public var endPoints: (C4Point,C4Point) = (C4Point(),C4Point(100,0)){
        didSet {
            updatePath()
        }
    }

    override func updatePath() {
        if pauseUpdates {
            return
        }

        if points.count > 1 {
            let p = C4Path()
            p.moveToPoint(endPoints.0)
            p.addLineToPoint(endPoints.1)
            path = p
            adjustToFitPath()
        }
    }

    /**
    Returns the receiver's center. Animatable.
    */
    public override var center : C4Point {
        get {
            return C4Point(view.center)
        }
        set {
            let diff = newValue - center
            batchUpdates() {
                self.endPoints.0 += diff
                self.endPoints.1 += diff
            }
        }
    }

    /**
    Returns the receiver's origin. Animatable.
    */
    public override var origin : C4Point {
        get {
            return C4Point(view.frame.origin)
        }
        set {
            let diff = newValue - origin
            batchUpdates() {
                self.endPoints.0 += diff
                self.endPoints.1 += diff
            }
        }
    }

    /**
    Initializes a new C4Polygon using the specified array of points.

    Protects against trying to create a polygon with only 1 point (i.e. requires 2 points).
    Trims point array if count > 2.

    let a = C4Point(100,100)
    let b = C4Point(200,200)

    let l = C4Line([a,b])

    - parameter points: An array of C4Point structs.
    */
    convenience public init(var _ points: [C4Point]) {

        if points.count > 2 {
            repeat {
                points.removeLast()
            } while points.count > 2
        }

        self.init(frame: C4Rect(points))
        let path = C4Path()
        self.points = points
        path.moveToPoint(points[0])
        for i in 1..<points.count {
            path.addLineToPoint(points[i])
        }
        self.path = path
        adjustToFitPath()
    }

    /**
    Initializes a new C4Line using the specified tuple of points.


    let a = C4Point(100,100)
    let b = C4Point(200,200)

    let l = C4Line((a,b))

    - parameter points: An tuple of C4Point structs.
    */
    convenience public init(_ points: (C4Point, C4Point)) {
        self.init(frame: C4Rect(points))
        let path = C4Path()
        self.endPoints = points
        path.moveToPoint(endPoints.0)
        path.addLineToPoint(endPoints.1)
        self.path = path
        adjustToFitPath()
    }

    /**
    Initializes a new C4Line using two specified points.


    let a = C4Point(100,100)
    let b = C4Point(200,200)

    let l = C4Line(begin: a, end: b)

    - parameter begin: The start point of the line.
    - parameter end: The end point of the line.
    */
    convenience public init(begin: C4Point, end: C4Point) {
        let points = (begin,end)
        self.init(points)
    }

    private var pauseUpdates = false
    func batchUpdates(updates: Void -> Void) {
        pauseUpdates = true
        updates()
        pauseUpdates = false
        updatePath()
    }
}
