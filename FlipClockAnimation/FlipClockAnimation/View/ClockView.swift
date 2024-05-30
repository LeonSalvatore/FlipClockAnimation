//
//  ClockView.swift
//  FlipClockAnimation
//
//  Created by Elioene Silves Fernandes on 30/05/2024.
//

import SwiftUI

struct ClockView: View {
    
    //MARK: View Properties
    // state variables
    @State private var hour: Int = .zero
    @State private var minutes: Int = .zero
    @State private var seconds: Int = .zero
    
    @State private var date = Date.now
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
   
    var body: some View {
        
        HStack {
            FlipClockTextCard(
                value: $hour,
                size: .init(width: 100,height: 150),
                cornerRadius: 10, background: .brown
            )
            Text(":")
                .font(.title.bold())
            FlipClockTextCard(
                value: $minutes,
                size: .init( width: 100,height: 150),
                cornerRadius: 10, background: .brown
            )
            Text(":")
                .font(.title.bold())
            FlipClockTextCard(
                value: $seconds,
                size: .init(width: 100, height: 150),
                cornerRadius: 10, background: .yellow)
           
        }
        .navigationTitle("Calendar Clock")
        .onAppear(perform: updateDate)
        .onReceive(timer) { _ in
            date = .now
            updateDate()
        }
        
    }
    
    private func updateDate() {
        let date = date
        let calendar = Calendar.current
        let currentMinute = calendar.component(.minute, from: date)
        let currentHour = calendar.component(.hour, from: date)
        let sec = calendar.component(.second, from: date)
        minutes = currentMinute
        hour = currentHour
        seconds = sec
    }
    
    enum HourComponents {
        case hour, minute, seconds
    }
}

#Preview {
    ContentView()
}
