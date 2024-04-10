//
//  HoldDownButton.swift
//  LongPressBut
//
//  Created by Phakhin Kanch on 10/4/2567 BE.
//

import SwiftUI

struct HoldDownButton: View {
    
    //Config
    var text: String
    var padingHorizontal: CGFloat = 25
    var padingVertical: CGFloat = 12
    var duration: CGFloat = 1
    var scale: CGFloat = 0.95
    var background: Color
    var loadingTint: Color
    var shape: AnyShape = .init(.capsule)
    var action: () -> ()
    
    //View Properties
    @State private var timer = Timer.publish(every: 0.01, on: .current, in: .common).autoconnect()
    @State private var timerCount: CGFloat = 0
    @State private var progress: CGFloat = 0
    @State private var isHolding: Bool = false
    @State private var isComplete: Bool = false
    
    var body: some View {
        Text(text)
            .padding(.vertical, padingVertical)
            .padding(.horizontal, padingHorizontal)
            .background{
                ZStack(alignment: .leading){
                    Rectangle()
                        .fill(background.gradient)
                    
                    GeometryReader{
                        var size = $0.size
                        
                        //Adding opacity transition
                        if !isComplete{
                            Rectangle()
                                .fill(loadingTint)
                                .frame(width: size.width * progress)
                                .transition(.opacity)
                        }
                    }
                }
            }
            .clipShape(shape)
            .contentShape(shape)
            .scaleEffect(isHolding ? scale : 1)
            .animation(.snappy, value: isHolding)
        //Gestures
            .gesture(longPressGesture)
            .gesture(dragGesture)
        //Timer
            .onReceive(timer) { _ in
                if isHolding && progress != 1{
                    timerCount += 0.01
                    progress = max(min(timerCount / duration, 1), 0)
                }
            }
            .onAppear(perform: cancleTimer)
    }
    
    var dragGesture: some Gesture{
        DragGesture(minimumDistance: 0)
            .onEnded{ _ in
                guard !isComplete else { return }
                cancleTimer()
                withAnimation(.snappy){
                    reset()
                }
            }
    }
    
    var longPressGesture: some Gesture{
        LongPressGesture(minimumDuration: duration)
            .onChanged{
                
                //Reseting to initial state
                isComplete = false
                reset()
                
                isHolding = $0
                addTimer()
            }.onEnded{ status in
                isHolding = false
                withAnimation(.easeInOut(duration: 0.2)){
                    isComplete = status
                }
                action()
            }
    }
    
    func addTimer() {
        timer = Timer.publish(every: 0.01, on: .current, in: .common).autoconnect()
    }
    func cancleTimer() {
        timer.upstream.connect().cancel()
    }
    func reset() {
        isHolding = false
        progress = 0
        timerCount = 0
    }
    
}

#Preview {
    ContentView()
}
