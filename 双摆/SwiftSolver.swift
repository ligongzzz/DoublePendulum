//
//  SwiftSolver.swift
//  双摆
//
//  Created by 谢哲 on 2021/3/9.
//

import Foundation
import SwiftUI

class SwiftSolver: ObservableObject {
    // Initial Value
    var alpha: Double, beta: Double;
    var m1: Double, m2: Double, w1: Double, w2: Double, l1: Double, l2: Double;
    
    init() {
        alpha = 0.0
        beta = 0.0
        m1 = 1.0
        m2 = 1.0
        w1 = 1.0
        w2 = 1.0
        l1 = 1.0
        l2 = 1.0
        
        // Init CPP Class
        init_solver(self.alpha, self.beta, self.m1, self.m2, self.l1, self.l2, self.w1, self.w2)
    }
    
    init(alpha: Double, beta: Double, m1: Double, m2: Double, w1: Double, w2: Double, l1: Double, l2: Double) {
        self.alpha = alpha
        self.beta = beta
        self.m1 = m1
        self.m2 = m2
        self.w1 = w1
        self.w2 = w2
        self.l1 = l1
        self.l2 = l2
        
        // Init CPP Class
        init_solver(self.alpha, self.beta, self.m1, self.m2, self.l1, self.l2, self.w1, self.w2)
    }
    
    func step(delta_t: Double) {
        solver_step(delta_t);
    }
    
    func get_position() -> (CGPoint, CGPoint) {
        return (CGPoint(x: solver_get_x1(), y: solver_get_y1()), CGPoint(x: solver_get_x2(), y: solver_get_y2()))
    }
    
    func set_value(alpha: Double, beta: Double, m1: Double, m2: Double, w1: Double, w2: Double, l1: Double, l2: Double) {
        self.alpha = alpha
        self.beta = beta
        self.m1 = m1
        self.m2 = m2
        self.w1 = w1
        self.w2 = w2
        self.l1 = l1
        self.l2 = l2
        
        // Set CPP Class
        solver_set_data(alpha, beta, m1, m2, l1, l2, w1, w2)
    }
}
