//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by RJ Tedoco on 8/3/22.
//

import SwiftUI

struct BlueTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold())
            .foregroundColor(.blue)
    }
}

extension View {
    func titleBlueStyle() -> some View {
        modifier(BlueTitle())
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var showingRestart = false;
    @State private var restartTitle = ""
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var score = 0
    @State private var questionCounter = 0
    
    @State private var animationEnabled = false
    @State private var animationAmount = 0.0
    @State private var flagTapped = 0
    
    struct FlagImage: View {
        var image: String
        
        var body: some View {
            Image(image)
                .renderingMode(.original)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(radius: 4)
        }
    }
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color.blue, location: 0.3),
                .init(color: Color.red, location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .foregroundColor(.white)
                    .font(.largeTitle.bold())
                VStack(spacing: 16) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundColor(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
//                            .foregroundColor(.primary)
//                            .font(.largeTitle.weight(.semibold))
                            .titleBlueStyle()
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                                
                            withAnimation {
                                animationAmount += 360
                                animationEnabled.toggle()
                            }
                        } label: {
                            FlagImage(image: countries[number])
                        }
                        .rotation3DEffect(.degrees(flagTapped == number ?  animationAmount : 0), axis: (x: 0, y: 1, z: 0))
                        .opacity(animationEnabled && flagTapped != number ? 0.25 : 1)
                        .scaleEffect(animationEnabled && flagTapped != number ? 0.75 : 1)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue?", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        .alert(restartTitle, isPresented: $showingRestart) {
            Button("Restart?", action: reset)
        } message: {
            Text("Your total score is \(score).")
        }
    }
    
    func flagTapped(_ number: Int) {
        flagTapped = number;
        
        if(number == correctAnswer) {
            scoreTitle = "Correct"
            score += 1
            
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
        }
        
        showingScore = true
        
        if(questionCounter == 8) {
            restartTitle = "Congrats! You made it."
            showingRestart = true
        }
    }
    
    func reset() {
        score = 0
        questionCounter = 0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func askQuestion() {
        questionCounter += 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        withAnimation {
            animationEnabled.toggle()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
