//
//  RotationDialView.swift
//  PlaygroundStickers
//
//  Created by Faris Albalawi on 9/6/19.
//  Copyright © 2019 Faris Albalawi. All rights reserved.
//

import UIKit
import Foundation

/// -----------------------------------------------------------------------//
public class RotationDialViewModel: NSObject {
    fileprivate var rotationCal: RotationCalculator?
    @objc dynamic var rotationAngle = CGAngle(degrees: 0)
    
    var touchPoint: CGPoint? {
        didSet {
            guard let oldValue = oldValue,
                let newValue = self.touchPoint,
                let rotationCal = rotationCal else {
                    return
            }
            
            let radians = rotationCal.getRotationRadians(byOldPoint: oldValue, andNewPoint: newValue)
            rotationAngle = CGAngle(radians: radians)
        }
    }
    
    public override init() {
        
    }
    
    func makeRotationCalculator(by midPoint: CGPoint) {
        rotationCal = RotationCalculator(midPoint: midPoint)
    }
}


/// -----------------------------------------------------------------------//

/// Use this class to make angle calculation to be simpler
public class CGAngle: NSObject, Comparable {
    public static func < (lhs: CGAngle, rhs: CGAngle) -> Bool {
        return lhs.radians < rhs.radians
    }
    
    public var radians: CGFloat = 0.0
    
    @inlinable public var degrees: CGFloat {
        get {
            return radians / CGFloat.pi * 180.0
        }
        set {
            radians = newValue / 180.0 * CGFloat.pi
        }
    }
    
    @inlinable public init(radians: CGFloat) {
        self.radians = radians
    }
    
    @inlinable public init(degrees: CGFloat) {
        radians = degrees / 180.0 * CGFloat.pi
    }
    
    override public var description: String {
        return String(format: "%0.2f°", degrees)
    }
    
    static public func +(lhs: CGAngle, rhs: CGAngle) -> CGAngle {
        return CGAngle(radians: lhs.radians + rhs.radians)
    }
    
    static public func *(lhs: CGAngle, rhs: CGAngle) -> CGAngle {
        return CGAngle(radians: lhs.radians * rhs.radians)
    }
    
    static public func -(lhs: CGAngle, rhs: CGAngle) -> CGAngle {
        return CGAngle(radians: lhs.radians - rhs.radians)
    }
    
    static public prefix func -(rhs: CGAngle) -> CGAngle {
        return CGAngle(radians: -rhs.radians)
    }
    
    static public func /(lhs: CGAngle, rhs: CGAngle) -> CGAngle {
        guard rhs.radians != 0 else {
            if lhs.radians == 0 { return CGAngle(radians: 0)}
            if lhs.radians > 0 { return CGAngle(radians: CGFloat.infinity)}
            return CGAngle(radians: -CGFloat.infinity)
        }
        return CGAngle(radians: lhs.radians / rhs.radians)
    }
    
}

/// -----------------------------------------------------------------------//

extension FloatingPoint{
    var isBad:Bool{ return isNaN || isInfinite }
    var checked:Self{
        guard !isBad && !isInfinite else {
            fatalError("bad number!")
        }
        return self
    }
    
}

typealias Angle = CGFloat
func df() -> CGFloat {
    return    CGFloat(drand48()).checked
}

func clockDescretization(_ val: CGFloat) -> CGFloat{
    let min:Double  = 0
    let max:Double = 2 * Double.pi
    let steps:Double = 144
    let stepSize = (max - min) / steps
    let nsf = floor(Double(val) / stepSize)
    let rest = Double(val) - stepSize * nsf
    return CGFloat(rest > stepSize / 2 ? stepSize * (nsf + 1) : stepSize * nsf).checked
    
}

extension CALayer {
    func doDebug(){
        self.borderColor = UIColor(hue: df() , saturation: df(), brightness: 1, alpha: 1).cgColor
        self.borderWidth = 2;
        self.sublayers?.forEach({$0.doDebug()})
    }
}

extension CGSize{
    var hasNaN:Bool{return width.isBad || height.isBad }
    var checked:CGSize{
        guard !hasNaN else {
            fatalError("bad number!")
        }
        return self
    }
}

extension CGRect{
    var center:CGPoint { return CGPoint(x:midX, y: midY).checked}
    var hasNaN:Bool{return size.hasNaN || origin.hasNaN}
    var checked:CGRect{
        guard !hasNaN else {
            fatalError("bad number!")
        }
        return self
    }
}

extension CGPoint{
    var vector:CGVector { return CGVector(dx: x, dy: y).checked}
    var checked:CGPoint{
        guard !hasNaN else {
            fatalError("bad number!")
        }
        return self
    }
    var hasNaN:Bool{return x.isBad || y.isBad }
}

extension CGVector{
    var hasNaN:Bool{return dx.isBad || dy.isBad}
    var checked:CGVector{
        guard !hasNaN else {
            fatalError("bad number!")
        }
        return self
    }
    
    static var root:CGVector{ return CGVector(dx:1, dy:0).checked}
    var magnitude:CGFloat { return sqrt(pow(dx, 2) + pow(dy,2)).checked}
    var normalized: CGVector { return CGVector(dx:dx / magnitude,  dy: dy / magnitude).checked }
    var point:CGPoint { return CGPoint(x: dx, y: dy).checked}
    func rotate(_ angle:Angle) -> CGVector { return CGVector(dx: dx * cos(angle) - dy * sin(angle), dy: dx * sin(angle) + dy * cos(angle) ).checked}
    
    func dot(_ vec2:CGVector) -> CGFloat { return (dx * vec2.dx + dy * vec2.dy).checked}
    func add(_ vec2:CGVector) -> CGVector { return CGVector(dx:dx + vec2.dx , dy: dy + vec2.dy).checked}
    func cross(_ vec2:CGVector) -> CGFloat { return (dx * vec2.dy - dy * vec2.dx).checked}
    func scale(_ c:CGFloat) -> CGVector { return CGVector(dx:dx * c , dy: dy * c).checked}
    
    init( from:CGPoint, to:CGPoint){
        guard !from.hasNaN && !to.hasNaN  else {
            fatalError("Nan point!")
        }
        self.init()
        dx = to.x - from.x
        dy = to.y - from.y
        _ = self.checked
    }
    
    init(angle:Angle){
        let compAngle = angle < 0 ? (angle + 2 * CGFloat.pi) : angle
        self.init()
        dx = cos(compAngle.checked)
        dy = sin(compAngle.checked)
        _ = self.checked
    }
    
    var theta:Angle{
        return atan2(dy, dx)}
    
    static func theta(_ vec1:CGVector, vec2:CGVector) -> Angle{
        var i = vec1.normalized.dot(vec2.normalized)
        if (i > 1) {
            i = 1;
        }
        if (i < -1){
            i = -1;
        }
        return acos(i).checked
    }
    
    static func signedTheta(_ vec1:CGVector, vec2:CGVector) -> Angle{
        
        return (vec1.normalized.cross(vec2.normalized) > 0 ?  -1 : 1) * theta(vec1.normalized, vec2: vec2.normalized).checked
    }
}



/// -----------------------------------------------------------------------//
public func createDial(config: Config = Config()) -> RotationDial {
    return RotationDial(frame: CGRect.zero, config: config)
}

public struct Config {
    public init() {}
    
    public var margin: Double = 10
    public var interactable = false
    public var rotationLimitType: RotationLimitType = .noLimit
    public var angleShowLimitType: AnglehowLimitType = .noLimit
    public var rotationCenterType: RotationCenterType = .useDefault
    public var numberShowSpan = 2
    public var orientation: Orientation = .normal
    
    public var backgroundColor: UIColor = .black
    public var bigScaleColor: UIColor = .lightGray
    public var smallScaleColor: UIColor = .lightGray
    public var indicatorColor: UIColor = .lightGray
    public var numberColor: UIColor = .lightGray
    public var centerAxisColor: UIColor = .lightGray
    
    public var theme: Theme = .dark {
        didSet {
            switch theme {
            case .dark:
                backgroundColor = .black
                bigScaleColor = .lightGray
                smallScaleColor = .lightGray
                indicatorColor = .lightGray
                numberColor = .lightGray
                centerAxisColor = .lightGray
            case .light:
                backgroundColor = .white
                bigScaleColor = .darkGray
                smallScaleColor = .darkGray
                indicatorColor = .darkGray
                numberColor = .darkGray
                centerAxisColor = .darkGray
            }
        }
    }
}


/// -----------------------------------------------------------------------//
public extension Config {
    enum RotationCenterType {
        case useDefault
        case custom(CGPoint)
    }
    
    enum RotationLimitType {
        case noLimit
        case limit(angle: CGAngle)
    }
    
    enum AnglehowLimitType {
        case noLimit
        case limit(angle: CGAngle)
    }
    
    enum Orientation {
        case normal
        case right
        case left
        case upsideDown
    }
    
    enum Theme {
        case dark
        case light
    }
}


/// -----------------------------------------------------------------------//
class RotationCalculator {
    
    // midpoint for gesture recognizer
    var midPoint = CGPoint.zero
    
    // relative rotation for current gesture (in radians)
    var rotation: CGFloat? {
        guard let currentPoint = self.currentPoint,
            let previousPoint = self.previousPoint else {
                return nil
        }
        
        var rotation = angleBetween(pointA: currentPoint, andPointB: previousPoint)
        
        if (rotation > CGFloat.pi) {
            rotation -= CGFloat.pi * 2
        } else if (rotation < -CGFloat.pi) {
            rotation += CGFloat.pi * 2
        }
        
        return rotation
    }
    
    // absolute angle for current gesture (in radians)
    var angle: CGFloat? {
        if let nowPoint = self.currentPoint {
            return self.angleForPoint(point: nowPoint)
        }
        
        return nil
    }
    
    // distance from midpoint
    var distance: CGFloat? {
        if let nowPoint = self.currentPoint {
            return self.distanceBetween(pointA: self.midPoint, andPointB: nowPoint)
        }
        
        return nil
    }
    
    private var currentPoint: CGPoint?
    private var previousPoint: CGPoint?
    
    init(midPoint: CGPoint) {
        self.midPoint = midPoint
    }
    
    private func distanceBetween(pointA: CGPoint, andPointB pointB: CGPoint) -> CGFloat {
        let dx = Float(pointA.x - pointB.x)
        let dy = Float(pointA.y - pointB.y)
        return CGFloat(sqrtf(dx*dx + dy*dy))
    }
    
    private func angleForPoint(point: CGPoint) -> CGFloat {
        var angle = CGFloat(-atan2f(Float(point.x - midPoint.x), Float(point.y - midPoint.y))) + CGFloat.pi / 2
        
        if (angle < 0) {
            angle += CGFloat.pi * 2
        }
        
        return angle
    }
    
    private func angleBetween(pointA: CGPoint, andPointB pointB: CGPoint) -> CGFloat {
        return angleForPoint(point: pointA) - angleForPoint(point: pointB)
    }
    
    func getRotationRadians(byOldPoint p1: CGPoint, andNewPoint p2: CGPoint) -> CGFloat {
        self.previousPoint = p1
        self.currentPoint = p2
        return rotation ?? 0
    }
}


/// -----------------------------------------------------------------------//

@IBDesignable
public class RotationDial: UIView {
    @IBInspectable public var pointerHeight: CGFloat = 8
    @IBInspectable public var spanBetweenDialPlateAndPointer: CGFloat = 6
    @IBInspectable public var pointerWidth: CGFloat = 8 * sqrt(2)
    
    public var didRotate: (_ angle: CGAngle) -> Void = { _ in }
    public var config = Config()
    
    private var angleLimit = CGAngle(radians: CGFloat.pi)
    private var showRadiansLimit: CGFloat = CGFloat.pi
    private var dialPlate: RotationDialPlate?
    private var dialPlateHolder: UIView?
    private var pointer: CAShapeLayer = CAShapeLayer()
    private var rotationKVO: NSKeyValueObservation?
    
    var viewModel = RotationDialViewModel()
    
    /**
     This one is needed to solve storyboard render problem
     https://stackoverflow.com/a/42678873/288724
     */
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public init(frame: CGRect, config: Config) {
        super.init(frame: frame)
        setup(with: config)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: - private funtions
extension RotationDial {
    private func setupUI() {
        clipsToBounds = true
        backgroundColor = config.backgroundColor
        
        dialPlateHolder?.removeFromSuperview()
        dialPlateHolder = getDialPlateHolder(by: config.orientation)
        addSubview(dialPlateHolder!)
        createDialPlate(in: dialPlateHolder!)
        setupPointer(in: dialPlateHolder!)
        setDialPlateHolder(by: config.orientation)
    }
    
    private func setupViewModel() {
        rotationKVO = viewModel.observe(\.rotationAngle,
                                        options: [.old, .new]
        ) { [weak self] _, changed in
            guard let angle = changed.newValue else { return }
            self?.handleRotation(by: angle)
        }
        
        let rotationCenter = getRotationCenter()
        viewModel.makeRotationCalculator(by: rotationCenter)
    }
    
    private func handleRotation(by angle: CGAngle) {
        if case .limit = config.rotationLimitType {
            guard angle <= angleLimit else {
                return
            }
        }
        
        if rotateDialPlate(by: angle) {
            didRotate(getRotationAngle())
        }
    }
    
    private func getDialPlateHolder(by orientation: Config.Orientation) -> UIView {
        let view = UIView(frame: bounds)
        
        switch orientation {
        case .normal, .upsideDown:
            ()
        case .left, .right:
            view.frame.size = CGSize(width: view.bounds.height, height: view.bounds.width)
        }
        
        return view
    }
    
    private func setDialPlateHolder(by orientation: Config.Orientation) {
        switch orientation {
        case .normal:
            ()
        case .left:
            dialPlateHolder?.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
            dialPlateHolder?.frame.origin = CGPoint(x: 0, y: 0)
        case .right:
            dialPlateHolder?.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
            dialPlateHolder?.frame.origin = CGPoint(x: 0, y: 0)
        case .upsideDown:
            dialPlateHolder?.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            dialPlateHolder?.frame.origin = CGPoint(x: 0, y: 0)
        }
    }
    
    private func createDialPlate(in container: UIView) {
        var margin: CGFloat = CGFloat(config.margin)
        if case .limit(let angle) = config.angleShowLimitType {
            margin = 0
            showRadiansLimit = angle.radians
        } else {
            showRadiansLimit = CGFloat.pi
        }
        
        var dialPlateShowHeight = container.frame.height - margin - pointerHeight - spanBetweenDialPlateAndPointer
        var r = dialPlateShowHeight / (1 - cos(showRadiansLimit))
        
        if r * 2 * sin(showRadiansLimit) > container.frame.width {
            r = (container.frame.width / 2) / sin(showRadiansLimit)
            dialPlateShowHeight = r - r * cos(showRadiansLimit)
        }
        
        let dialPlateLength = 2 * r
        let dialPlateFrame = CGRect(x: (container.frame.width - dialPlateLength) / 2, y: margin - (dialPlateLength - dialPlateShowHeight), width: dialPlateLength, height: dialPlateLength)
        
        dialPlate?.removeFromSuperview()
        dialPlate = RotationDialPlate(frame: dialPlateFrame, config: config)
        container.addSubview(dialPlate!)
    }
    
    private func setupPointer(in container: UIView){
        guard let dialPlate = dialPlate else { return }
        
        let path = CGMutablePath()
        let pointerEdgeLength: CGFloat = pointerWidth
        
        let pointTop = CGPoint(x: container.bounds.width/2, y: dialPlate.frame.maxY + spanBetweenDialPlateAndPointer)
        let pointLeft = CGPoint(x: container.bounds.width/2 - pointerEdgeLength / 2, y: pointTop.y + pointerHeight)
        let pointRight = CGPoint(x: container.bounds.width/2 + pointerEdgeLength / 2, y: pointLeft.y)
        
        path.move(to: pointTop)
        path.addLine(to: pointLeft)
        path.addLine(to: pointRight)
        path.addLine(to: pointTop)
        pointer.fillColor = config.indicatorColor.cgColor
        pointer.path = path
        container.layer.addSublayer(pointer)
    }
    
    private func getRotationCenter() -> CGPoint {
        guard let dialPlate = dialPlate else { return .zero }
        
        if case .custom(let center) = config.rotationCenterType {
            return center
        } else {
            let p = CGPoint(x: dialPlate.bounds.midX , y: dialPlate.bounds.midY)
            return dialPlate.convert(p, to: self)
        }
    }
}

// MARK: - public API
extension RotationDial {
    /// Setup the dial with your own config
    ///
    /// - Parameter config: dail config. If not provided, default config will be used
    public func setup(with config: Config = Config()) {
        self.config = config
        
        if case .limit(let angle) = config.rotationLimitType {
            angleLimit = angle
        }
        
        setupUI()
        setupViewModel()
    }
    
    @discardableResult
    func rotateDialPlate(by angle: CGAngle) -> Bool {
        guard let dialPlate = dialPlate else { return false }
        
        let radians = angle.radians
        if case .limit = config.rotationLimitType {
            if (getRotationAngle() * angle).radians > 0 && abs(getRotationAngle().radians + radians) >= angleLimit.radians {
                
                if radians > 0 {
                    rotateDialPlate(to: angleLimit)
                } else {
                    rotateDialPlate(to: -angleLimit)
                }
                
                return false
            }
        }
        
        dialPlate.transform = dialPlate.transform.rotated(by: radians)
        return true
    }
    
    public func rotateDialPlate(to angle: CGAngle, animated: Bool = false) {
        let radians = angle.radians
        
        if case .limit = config.rotationLimitType {
            guard abs(radians) <= angleLimit.radians else {
                return
            }
        }
        
        func rotate() {
            dialPlate?.transform = CGAffineTransform(rotationAngle: radians)
        }
        
        if animated {
            UIView.animate(withDuration: 0.5) {
                rotate()
            }
        } else {
            rotate()
        }
    }
    
    public func resetAngle(animated: Bool) {
        rotateDialPlate(to: CGAngle(radians: 0), animated: animated)
    }
    
    public func getRotationAngle() -> CGAngle {
        guard let dialPlate = dialPlate else { return CGAngle(degrees: 0) }
        
        let radians = CGFloat(atan2f(Float(dialPlate.transform.b), Float(dialPlate.transform.a)))
        return CGAngle(radians: radians)
    }
    
    public func setRotationCenter(by point: CGPoint, of view: UIView) {
        let p = view.convert(point, to: self)
        config.rotationCenterType = .custom(p)
    }
}


extension RotationDial {
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let p = convert(point, to: self)
        if bounds.contains(p) {
            return self
        }
        
        return nil
    }
    
    private func handle(_ touches: Set<UITouch>) {
        guard touches.count == 1,
            let touch = touches.first else {
                return
        }
        
        viewModel.touchPoint = touch.location(in: self)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        handle(touches)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        handle(touches)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        viewModel.touchPoint = nil
    }
}



/// -----------------------------------------------------------------------//

fileprivate let bigDegreeScaleNumber = 36
fileprivate let smallDegreeScaleNumber = bigDegreeScaleNumber * 5
fileprivate let margin: CGFloat = 0
fileprivate let spaceBetweenScaleAndNumber: CGFloat = 10

class RotationDialPlate: UIView {
    
    let smallDotLayer:CAReplicatorLayer = {
        var r = CAReplicatorLayer()
        r.instanceCount = smallDegreeScaleNumber
        r.instanceTransform =
            CATransform3DMakeRotation(
                2 * CGFloat.pi / CGFloat(r.instanceCount),
                0,0,1)
        
        return r
    }()
    
    let bigDotLayer:CAReplicatorLayer = {
        var r = CAReplicatorLayer()
        r.instanceCount = bigDegreeScaleNumber
        r.instanceTransform =
            CATransform3DMakeRotation(
                2 * CGFloat.pi / CGFloat(r.instanceCount),
                0,0,1)
        
        return r
    }()
    
    var config = Config()
    
    init(frame: CGRect, config: Config = Config()) {
        super.init(frame: frame)
        self.config = config
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func getSmallScaleMark() -> CALayer {
        let mark = CAShapeLayer()
        mark.frame = CGRect(x: 0, y: 0, width: 2, height: 2)
        mark.path = UIBezierPath(ovalIn: mark.bounds).cgPath
        mark.fillColor = config.smallScaleColor.cgColor
        
        return mark
    }
    
    private func getBigScaleMark() -> CALayer {
        let mark = CAShapeLayer()
        mark.frame = CGRect(x: 0, y: 0, width: 4, height: 4)
        mark.path = UIBezierPath(ovalIn: mark.bounds).cgPath
        mark.fillColor = config.bigScaleColor.cgColor
        
        return mark
    }
    
    private func setupAngleNumber() {
        let numberFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption2)
        
        let cgFont = CTFontCreateWithName(numberFont.fontName as CFString, numberFont.pointSize/2, nil)
        
        let numberPlateLayer = CALayer()
        numberPlateLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        numberPlateLayer.frame = self.bounds
        self.layer.addSublayer(numberPlateLayer)
        
        let origin = CGPoint(x: numberPlateLayer.frame.midX, y: numberPlateLayer.frame.midY)
        let startPos = CGPoint(x: numberPlateLayer.bounds.midX, y: numberPlateLayer.bounds.maxY - margin - spaceBetweenScaleAndNumber)
        let step = (2 * CGFloat.pi) / CGFloat(bigDegreeScaleNumber)
        for i in (0 ..< bigDegreeScaleNumber){
            
            guard i % config.numberShowSpan == 0 else {
                continue
            }
            
            let numberLayer = CATextLayer()
            numberLayer.bounds.size = CGSize(width: 30, height: 15)
            numberLayer.fontSize = numberFont.pointSize
            numberLayer.alignmentMode = CATextLayerAlignmentMode.center
            numberLayer.contentsScale = UIScreen.main.scale
            numberLayer.font = cgFont
            let angle = (i > bigDegreeScaleNumber / 2 ? i - bigDegreeScaleNumber : i) * 10
            numberLayer.string = "\(angle)"
            numberLayer.foregroundColor = config.numberColor.cgColor
            
            let stepChange = CGFloat(i) * step
            numberLayer.position = CGVector(from:origin, to:startPos).rotate(-stepChange).add(origin.vector).point.checked
            
            numberLayer.transform = CATransform3DMakeRotation(-stepChange, 0, 0, 1)
            numberPlateLayer.addSublayer(numberLayer)
        }
    }
    
    private func setupSmallScaleMarks() {
        smallDotLayer.frame = self.bounds
        smallDotLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let smallScaleMark = getSmallScaleMark()
        smallScaleMark.position = CGPoint(x: smallDotLayer.bounds.midX, y: margin)
        smallDotLayer.addSublayer(smallScaleMark)
        
        self.layer.addSublayer(smallDotLayer)
    }
    
    private func setupBigScaleMarks() {
        bigDotLayer.frame = self.bounds
        bigDotLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let bigScaleMark = getBigScaleMark()
        bigScaleMark.position = CGPoint(x: bigDotLayer.bounds.midX, y: margin)
        bigDotLayer.addSublayer(bigScaleMark)
        self.layer.addSublayer(bigDotLayer)
    }
    
    private func setCenterPart() {
        let layer = CAShapeLayer()
        let r: CGFloat = 4
        layer.frame = CGRect(x: (self.layer.bounds.width - r) / 2 , y: (self.layer.bounds.height - r) / 2, width: r, height: r)
        layer.path = UIBezierPath(ovalIn: layer.bounds).cgPath
        layer.fillColor = config.centerAxisColor.cgColor
        
        self.layer.addSublayer(layer)
    }
    
    private func setup() {
        setupSmallScaleMarks()
        setupBigScaleMarks()
        setupAngleNumber()
        setCenterPart()
    }
}
