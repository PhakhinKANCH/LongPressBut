//
//  ContentView.swift
//  LongPressBut
//
//  Created by Phakhin Kanch on 10/4/2567 BE.
//

import SwiftUI

struct ContentView: View {
    
    @State private var count: Int = 0
    
    var body: some View {
        NavigationStack{
            VStack {
                Text("\(count)")
                    .font(.largeTitle.bold())
                
                HoldDownButton(text: "Hold to Increase",
                               duration: 0.5,
                               background: .black,
                               loadingTint: .white.opacity(0.3)
                ){
                    count += 1
                }
                .foregroundColor(.white)
                .padding(.top, 45)
            }
            .padding()
            .navigationTitle("Hold down button")
        }
    }
}

#Preview {
    ContentView()
}
