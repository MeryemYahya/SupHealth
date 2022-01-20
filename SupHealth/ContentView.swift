//
//  ContentView.swift
//  SupHealth
//
//  Created by Student Supinfo on 22/06/2020.
//  Copyright © 2020 Student Supinfo. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
 
    var body: some View {
        TabView(selection: $selection){
            GeneralView()
                .tabItem {
                    VStack {
                        Image(systemName: "app")
                        Text("General")
                    }
                }
                .tag(0)
            
           ListView()
                .tabItem {
                    VStack {
                        Image(systemName: "list.dash")
                        Text("List")
                    }
                }
                .tag(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
