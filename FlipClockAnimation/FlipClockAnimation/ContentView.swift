//
//  ContentView.swift
//  FlipClockAnimation
//
//  Created by Elioene Silves Fernandes on 30/05/2024.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
       ClockView()
    }
    
}

extension Color {
    static let ghostWhite = Color(red: 248, green: 248, blue: 255)
    static let ghostBlack = Color(red: 63, green: 63, blue: 63)
}

#Preview {
    NavigationStack {
        ContentView()
            .preferredColorScheme(.dark)
           
    }
}
