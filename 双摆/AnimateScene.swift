//
//  AnimateScene.swift
//  双摆
//
//  Created by 谢哲 on 2021/3/9.
//

import Foundation
import SpriteKit

class AnimateScene: SKScene, ObservableObject {
    var lastUpdateTime: TimeInterval?
    var line1 = SKShapeNode()
    var line2 = SKShapeNode()
    var swiftSolver: SwiftSolver
    var cx: CGFloat = 0.0, cy: CGFloat = 0.0
    var centerBox = SKShapeNode()
    var firstBox = SKShapeNode()
    var secondBox = SKShapeNode()
    var zoom: CGFloat = 100.0
    @Published var fps = 0.0
    var accuracy: Double = 10.0
    var fpsSum = 0.0
    var fpsAvg: [Double] = []
    
    private var _paused : Bool = false
    override var isPaused : Bool
    {
        get
        {
            return _paused
        }
        set {
            
        }
    }
    
    func manualPause(value: Bool) {
        _paused = value;
    }
    
    func updateSolver(newSolver: SwiftSolver) {
        swiftSolver.set_value(alpha: newSolver.alpha, beta: newSolver.beta, m1: newSolver.m1, m2: newSolver.m2, w1: newSolver.w1, w2: newSolver.w2, l1: newSolver.l1, l2: newSolver.l2)
    }
    
    private func drawLine(line: inout SKShapeNode, from: CGPoint, to: CGPoint){
        line.removeFromParent()
        let path = CGMutablePath()
        path.move(to: from)
        path.addLine(to: to)
        line = SKShapeNode(path: path)
        self.addChild(line)
    }

    
    private func updatePos() {
        let (pos1, pos2) = swiftSolver.get_position()
        
        cx = self.size.width / 2
        cy = self.size.height / 2
        
        centerBox.position = CGPoint(x:cx, y:cy)
        firstBox.position = CGPoint(x: cx+pos1.x*zoom, y: cy-pos1.y*zoom)
        secondBox.position = CGPoint(x: cx+pos2.x*zoom, y: cy-pos2.y*zoom)
        
        drawLine(line: &line1, from: centerBox.position, to: firstBox.position)
        drawLine(line: &line2, from: firstBox.position, to: secondBox.position)
    }
    
    override init() {
        swiftSolver = SwiftSolver()
        super.init()
    }
    
    override init(size: CGSize) {
        swiftSolver = SwiftSolver()
        super.init(size: size)
    }
    
    convenience init(swiftSolver: SwiftSolver) {
        self.init()
        self.swiftSolver = swiftSolver;
        updatePos()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sceneDidLoad() {
        cx = self.size.width / 2
        cy = self.size.height / 2
        
        centerBox = SKShapeNode(circleOfRadius: 6)
        centerBox.fillColor = UIColor.red
        centerBox.strokeColor = UIColor.red
        centerBox.name = "center"
        addChild(centerBox)
        
        firstBox = SKShapeNode(circleOfRadius: 6)
        firstBox.fillColor = UIColor.green
        firstBox.strokeColor = UIColor.green
        firstBox.name = "first"
        addChild(firstBox)
        
        secondBox = SKShapeNode(circleOfRadius: 6)
        secondBox.fillColor = UIColor.yellow
        secondBox.strokeColor = UIColor.yellow
        secondBox.name = "second"
        addChild(secondBox)
        
        // Update Position After Create
        updatePos()
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        updatePos()
    }
    
    override func update(_ currentTime: TimeInterval) {
        var timeInterval: Double = 0.0;
        if lastUpdateTime != nil {
            timeInterval = currentTime - lastUpdateTime!;
        }
        lastUpdateTime = currentTime;
        if timeInterval > 0.1 {
            return
        }
        
        // Update with CPP Lib
        for _ in 0..<Int(accuracy) {
            swiftSolver.step(delta_t: timeInterval/Double(Int(accuracy)));
        }
        
        fpsAvg.append(1.0/(timeInterval+1e-9))
        fpsSum += 1.0/(timeInterval+1e-9);
    
        if (fpsAvg.count>5) {
            fpsSum -= fpsAvg[0];
            fpsAvg.remove(at: 0);
        }
        
        fps = fpsSum / Double(fpsAvg.count);
        
        // Update Pos
        updatePos()
    }
}
