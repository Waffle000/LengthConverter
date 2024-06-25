//
//  SplashView.swift
//  LengthConvertion
//
//  Created by Enrico Maricar on 25/06/24.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            ConvertView()
        } else {
            NavigationView {
                VStack {
                    VStack {
                        Image("AppLogo").resizable().frame(width: 96, height: 96)
                            .imageScale(.large)
                            .foregroundStyle(.tint)
                        Text("Length Convertion").font(.title).padding(.top, 4).bold().foregroundStyle(Color.blue.opacity(0.7))
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.5)) {
                            self.size = 0.9
                            self.opacity = 1.0
                        }
                    }
                }
                                    }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isActive = true
                    }
                }
            }
        }
}

#Preview {
    SplashView()
}

