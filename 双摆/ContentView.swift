//
//  ContentView.swift
//  双摆
//
//  Created by 谢哲 on 2021/3/9.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        SwiftUIView(swiftSolver: SwiftSolver())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
