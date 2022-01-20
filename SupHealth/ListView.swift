//
//  ListView.swift
//  SupHealth
//
//  Created by Student Supinfo on 23/06/2020.
//  Copyright © 2020 Student Supinfo. All rights reserved.
//

import Combine
import SwiftUI


class Favorites: ObservableObject {
    
    private var fav: Set<String>
    private var a = [Countries]()
    private let saveKey = "Favorites"
    
    init() {
       
        self.fav = []
    }
    
    // returns true if our set contains this country
    func contains(_ c: Countries) -> Bool {
        fav.contains(c.Slug)
    }
    // adds the country to our set, updates all views, and saves the change
    func add(_ c: Countries) {
        objectWillChange.send()
        fav.insert(c.Slug)
        a.insert(c, at: 0)
        print(a)
    }
        // removes the country from our set, updates all views, and saves the change
    func remove(_ c: Countries) {
        objectWillChange.send()
        fav.remove(c.Slug)
        a.removeAll(where: {$0.Slug == c.Slug })
    }
    //return array off favorites countries
    func favArray() -> [Countries] {
        return a
    }
  
}

class FetchToDo: ObservableObject {
    
    @Published var todos = [Countries]()
    
    init() {
        let url = URL(string: "https://api.covid19api.com/countries")!
        
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            do {
                if let todoData = data {
                    
                    let decodedData = try JSONDecoder().decode([Countries].self, from: todoData)
                    DispatchQueue.main.async {
                        self.todos = decodedData
                    }
                } else {
                    print("No data")
                }
            } catch {
                print("Error")
            }
        }.resume()
    }
}


struct ListView: View {
    
    @ObservedObject var favorites = Favorites()
    @ObservedObject var fetch = FetchToDo()
    @State private var searchText = ""
    @State var showFavoritesOnly = false
    
    var body: some View {
        NavigationView {
            VStack{
                SearchBar(text: $searchText)
                Toggle(isOn: self.$showFavoritesOnly) { Text("Show Favorites only")}.padding()
                
                
                if (showFavoritesOnly) {
                    
                    List(favorites.favArray().filter({ searchText.isEmpty ? true : $0.Country.contains(searchText) }), id: \.ISO2) { item in
                        
       
                        NavigationLink(destination: DetailView(item: item)) {
                            
                            Image(item.Slug).resizable().frame(width: 30, height: 30, alignment: .leading)
                            Text(item.Country)
                            if self.favorites.contains(item) {
                                Spacer()
                                Image(systemName: "heart.fill")
                                    .accessibility(label: Text("This is a favorite country"))
                                    .foregroundColor(.red)
                            }
                        }
                        
                        
                    }
                    
                    
                    
                }
                    
                else {
                    List(fetch.todos.filter({ searchText.isEmpty ? true : $0.Country.contains(searchText) }) , id: \.ISO2) { item in
                        
                        NavigationLink(destination: DetailView(item: item)) {
                            
                            Image(item.Slug).resizable().frame(width: 30, height: 30, alignment: .leading)
                            Text(item.Country)
                            if self.favorites.contains(item) {
                                Spacer()
                                Image(systemName: "heart.fill")
                                    .accessibility(label: Text("This is a favorite country"))
                                    .foregroundColor(.red)
                            }
                        }
                        
                        
                    }
                    
                }
                
                
            }
            .navigationBarTitle("Countries")
        }             .environmentObject(favorites)
        
        
        
    }
    
    
    
    
    struct ListView_Previews: PreviewProvider {
        static var previews: some View {
            ListView()
        }
    }
}
