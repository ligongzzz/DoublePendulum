//
//  SwiftUIView.swift
//  双摆
//
//  Created by 谢哲 on 2021/3/9.
//

import SwiftUI
import SpriteKit

struct SwiftUIView: View{
    @ObservedObject var swiftSolver: SwiftSolver
    @Binding var active: Bool
    @Binding var zoom: Double
    @StateObject var spriteScene = AnimateScene(swiftSolver: SwiftSolver())
    @Binding var fps: Double
    @Binding var accuracy: Double
    
    func sizableScene(width: CGFloat, height: CGFloat) -> SKScene {
        let scene = AnimateScene(swiftSolver: swiftSolver)
        scene.size = CGSize(width: width, height: height)
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some View {
        #if targetEnvironment(macCatalyst) || os(iOS)
        GeometryReader(content: { geometry in
            SpriteView(scene: spriteScene, preferredFramesPerSecond: 120)
                .onAppear(perform: {
                    spriteScene.updateSolver(newSolver: swiftSolver)
                    spriteScene.zoom = CGFloat(zoom)
                    spriteScene.size = CGSize(width: geometry.size.width, height: geometry.size.height)
                })
                .onChange(of: geometry.size, perform: { value in
                    spriteScene.size = CGSize(width: value.width, height: value.height)
                })
                .onChange(of: active, perform: { value in
                    if !active {
                        spriteScene.manualPause(value: true)
                    }
                    else {
                        spriteScene.zoom = CGFloat(zoom)
                        spriteScene.swiftSolver = swiftSolver
                        spriteScene.manualPause(value: false)
                    }
                })
                .onChange(of: zoom, perform: { value in
                    spriteScene.zoom = CGFloat(zoom)
                })
                .onChange(of: spriteScene.fps, perform: { value in
                    fps = value
                })
                .onChange(of: accuracy, perform: { value in
                    spriteScene.accuracy = pow(10, accuracy)
                    print("Accuracy set to \(spriteScene.accuracy)")
                })
        })
        .navigationBarHidden(true)
        #else
        GeometryReader(content: { geometry in
            SpriteView(scene: spriteScene)
                .onAppear(perform: {
                    spriteScene.swiftSolver = swiftSolver
                    spriteScene.zoom = CGFloat(zoom)
                    spriteScene.size = CGSize(width: geometry.size.width, height: geometry.size.height)
                })
                .onChange(of: geometry.size, perform: { value in
                    spriteScene.size = CGSize(width: value.width, height: value.height)
                })
                .onChange(of: zoom, perform: { value in
                    spriteScene.zoom = CGFloat(zoom)
                })
        })
        #endif
    }
}
