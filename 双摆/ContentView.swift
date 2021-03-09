//
//  ContentView.swift
//  双摆
//
//  Created by 谢哲 on 2021/3/9.
//

import SwiftUI

struct ContentView: View {
    @State var m1 = 1
    @State var m2 = 5
    @State var l1 = 1
    @State var l2 = 1
    @State var w1 = 1
    @State var w2 = 1
    @State var alpha = 1
    @State var beta = 1
    @State var active = false
    @State var tmpSolver = SwiftSolver()
    @State var zoom = 100.0
    
    var body: some View {
        NavigationView{
            List {
                Section(header: Text("初始条件")) {
                    Stepper("alpha:  \(String(format:"%.1f", Double(alpha)/10)) rad", value: $alpha, in: ClosedRange(Range(-32...32)))
                    Stepper("beta:  \(String(format:"%.1f", Double(beta)/10)) rad", value: $beta, in: ClosedRange(Range(-32...32)))
                    Stepper("m1:  \(m1) kg", value: $m1, in: ClosedRange(Range(1...100)))
                    Stepper("m2:  \(m2) kg", value: $m2, in: ClosedRange(Range(1...100)))
                    Stepper("l1:  \(l1) m", value: $l1, in: ClosedRange(Range(1...100)))
                    Stepper("l2:  \(l2) m", value: $l2, in: ClosedRange(Range(1...100)))
                    Stepper("w1:  \(w1) m/s", value: $w1, in: ClosedRange(Range(1...100)))
                    Stepper("w2:  \(w2) m/s", value: $w2, in: ClosedRange(Range(1...100)))
                }
                
                Section(header: Text("模拟器")) {
                    NavigationLink(destination: SwiftUIView(swiftSolver: $tmpSolver, active: $active, zoom: $zoom), isActive: $active){
                        Text("开始模拟")
                    }
                    .onChange(of: active, perform: { value in
                        if value {
                            tmpSolver = SwiftSolver(alpha: Double(alpha)/10, beta: Double(beta)/10, m1: Double(m1), m2: Double(m2), w1: Double(w1), w2: Double(w2), l1: Double(l1), l2: Double(l2))
                        }
                    })
                    #if targetEnvironment(macCatalyst)
                    Button("停止模拟", action: {
                        active = false
                    })
                    #endif
                    VStack{
                        Slider(value: $zoom, in: 10.0...200.0)
                        Text("缩放级别: \(String(format: "%.1f", zoom))")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                }
            }.navigationBarTitle("双摆模拟")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
