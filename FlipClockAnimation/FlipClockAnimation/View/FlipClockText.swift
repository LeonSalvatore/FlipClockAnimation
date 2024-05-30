//
//  FlipClockTextCard.swift
//  FlipClockAnimation
//
//  Created by Elioene Silves Fernandes on 30/05/2024.
//

import SwiftUI

struct FlipClockTextCard: View {
    
    // MARK: View properties
    
    @Binding var value: Int
    var size: CGSize
    var cornerRadius: CGFloat
    var background: Color = .black
    private var cardMidY: CGFloat {size.height * 0.5}
    
    let animationDuration: CGFloat = 0.8
    let rotationAngle: CGFloat = -180
    let innerRadius: CGFloat = 0.2
    
    // state variables
    @State private var currentValue: Int = .zero
    @State private var nextValue: Int = 0
    @State private var rotation: CGFloat = 0
    
    var body: some View {
        
        ZStack {
            
            // MARK: Next Card
            UnevenRoundedRectangle(
                cornerRadii: .init(topLeading: cornerRadius, bottomLeading: .zero, bottomTrailing: .zero, topTrailing:cornerRadius))
            .fill(background.shadow(.inner(radius: innerRadius)))/// Inner shadow to distinguish border
            .frame(height: cardMidY)
            .overlay(alignment:.top,content: {MinuteText(nextValue)})
            .clipped()
            .frame(maxHeight: .infinity, alignment: .top)
            
            // MARK: Top Card
            UnevenRoundedRectangle(
                cornerRadii: .init(topLeading: cornerRadius, bottomLeading: .zero, bottomTrailing: .zero, topTrailing:cornerRadius))
            .fill(background.shadow(.inner(radius: innerRadius)))/// Inner shadow to distinguish border
            .frame(height: cardMidY)
            .rotationEffectAnimation(rotation: rotation, currentValue: currentValue, nextValue: nextValue, size: size)
            .clipped()
            .rotation3DEffect(
                .init(degrees: rotation),
                axis: (x: 1.0, y: 0, z: 0.0),
                anchor: .bottom,
                perspective: 0.4
            )
            .frame(maxHeight: .infinity, alignment: .top)
            .zIndex(10)
            
            // MARK: Bottom Card
            UnevenRoundedRectangle(
                cornerRadii: .init(topLeading: .zero, bottomLeading: cornerRadius, bottomTrailing: cornerRadius, topTrailing: .zero))
            .fill(background.shadow(.inner(radius: innerRadius)))/// Inner shadow to distinguish border
            .frame(height: cardMidY)
            .overlay(alignment:.bottom,content: {MinuteText(currentValue)})
            .clipped()
            .frame(maxHeight: .infinity, alignment: .bottom)
           
        }
        .frame(width: size.width, height: size.height)
        .onChange(of: value) { oldValue, newValue in
            currentValue = oldValue
            nextValue = newValue
            
            guard rotation.isZero else {
                currentValue = newValue
                return }
            
            guard oldValue != newValue else { return }
            
            withAnimation(.smooth(duration: animationDuration), completionCriteria: .logicallyComplete) {
                
                rotation = rotationAngle
            } completion: {
                rotation = 0
                currentValue = value
            }

        }

    }
    
    
    @ViewBuilder
    fileprivate func MinuteText(_ value: Int) -> some View {
        Text(verbatim: value.description)
            .font(.system(size: 40).bold())
            .foregroundStyle(.primary)
            .frame(width: size.width, height: size.height)
            .lineLimit(1)
            .drawingGroup()
    }
}

fileprivate struct RotationEffectModifier: ViewModifier, Animatable {
    
    var rotation: CGFloat
    var currentValue: Int
    var nextValue: Int
    let size: CGSize
    let rotationFlipAngle: CGFloat = 90
  
    var animatableData: CGFloat {
        get  { rotation }
        set { rotation = newValue}
    }
    
    init(_ rotation: CGFloat, _ currentValue: Int, _ nextValue: Int, _ size: CGSize) {
        
        self.rotation = rotation
        self.currentValue = currentValue
        self.nextValue = nextValue
        self.size = size
    }
    func body(content: Content) -> some View {
        content.overlay(alignment: .top, content: TextView)
    }
    
    @ViewBuilder
    private func TextView()-> some View {
        Group {
            if -rotation > rotationFlipAngle {
                
                Text(verbatim: nextValue.description)
                    .font(.system(size: 40).bold())
                    .foregroundStyle(.primary)
                    .scaleEffect(x: 1, y: -1)
                    .transition(.identity)
            } else {
                Text(verbatim: currentValue.description)
                    .font(.system(size: 40).bold())
                    .foregroundStyle(.primary)
                    .transition(.identity)
                    
            }
        }
        .lineLimit(1)
        .frame(width: size.width, height: size.height)
        .drawingGroup()
    }
}

extension View {
    @ViewBuilder
    func rotationEffectAnimation(
        rotation: CGFloat,
        currentValue: Int,
        nextValue: Int,
        size: CGSize
    ) -> some View {
        modifier(
            RotationEffectModifier(
                rotation,
                currentValue,
                nextValue,
                size
            )
        )
    }
}

#Preview {
    ContentView()
}
