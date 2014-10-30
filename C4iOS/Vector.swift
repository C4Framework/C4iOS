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

import CoreGraphics

public struct Vector : Equatable {
    public var x: Double = 0
    public var y: Double = 0
    
    public init() {
    }
    
    /**
    Create a vector with a cartesian representation: an x and a y coordinates.
    */
    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    /**
    Create a vector with a polar representation: a magnitude and an angle.
    http://en.wikipedia.org/wiki/Polar_coordinate_system
    */
    public init(magnitude: Double, heading: Double) {
        x = magnitude * cos(heading)
        y = magnitude * sin(heading)
    }
    
    public var magnitude: Double {
        get {
            return sqrt(x * x + y * y)
        }
        set {
            x = newValue * cos(heading)
            y = newValue * sin(heading)
        }
    }
    
    public var heading : Double {
        get {
            return atan2(y, x);
        }
        set {
            x = magnitude * cos(newValue)
            y = magnitude * sin(newValue)
        }
    }
    
    public func angleTo(vec: Vector) -> Double {
        return acos(self ⋅ vec / (self.magnitude * vec.magnitude))
    }
    
    /**
    Return the dot product. You should use the ⋅ operator instead.
    */
    public func dot(vec: Vector) -> Double {
        return x * vec.x + y * vec.y
    }
    
    /**
    Return a vector with the same heading but a magnitude of 1.
    */
    public func unitVector() -> Vector {
        let mag = self.magnitude
        if mag == 0 {
            return Vector()
        }
        return Vector(x: x / mag, y: y / mag)
    }

    /**
    Return `true` if the vector is zero.
    */
    public func isZero() -> Bool {
        return x == 0 && y == 0
    }
}

public func == (lhs: Vector, rhs: Vector) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

public func += (inout lhs: Vector, rhs: Vector) {
    lhs.x += rhs.x
    lhs.y += rhs.y
}

public func -= (inout lhs: Vector, rhs: Vector) {
    lhs.x -= rhs.x
    lhs.y -= rhs.y
}

public func *= (inout lhs: Vector, rhs: Double) {
    lhs.x *= rhs
    lhs.y *= rhs
}

public func /= (inout lhs: Vector, rhs: Double) {
    lhs.x /= rhs
    lhs.y /= rhs
}

public func + (lhs: Vector, rhs: Vector) -> Vector {
    return Vector(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

public func - (lhs: Vector, rhs: Vector) -> Vector {
    return Vector(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

infix operator ⋅ { associativity left precedence 150 }
public func ⋅ (lhs: Vector, rhs: Vector) -> Double {
    return lhs.x * rhs.x + lhs.y * rhs.y
}

public func / (lhs: Vector, rhs: Double) -> Vector {
    return Vector(x: lhs.x / rhs, y: lhs.y / rhs)
}

public func * (lhs: Vector, rhs: Double) -> Vector {
    return Vector(x: lhs.x * rhs, y: lhs.y * rhs)
}

public prefix func - (vector: Vector) -> Vector {
    return Vector(x: -vector.x, y: -vector.y)
}
