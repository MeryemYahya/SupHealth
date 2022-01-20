//
//  SearchBar.swift
//  SupHealth
//
//  Created by Student Supinfo on 25/06/2020.
//  Copyright © 2020 Student Supinfo. All rights reserved.
//

import SwiftUI

struct Summary : Codable {
    var Global: Global
    var Countries : [Country]
    var Date : String
}

struct Global : Codable{
    var  NewConfirmed : Int
    var  TotalConfirmed: Int
    var  NewDeaths: Int
    var  TotalDeaths: Int
    var  NewRecovered: Int
    var  TotalRecovered: Int
}

struct Country : Codable{
    var Country: String
    var CountryCode: String
    var Slug: String
    var NewConfirmed: Int
    var TotalConfirmed : Int
    var NewDeaths: Int
    var TotalDeaths: Int
    var NewRecovered: Int
    var TotalRecovered: Int
    var Date: String
}

struct Countries: Codable{
    var Country: String
    var Slug: String
    var ISO2: String
}

struct CountryD : Codable{
    var Country: String
    var CountryCode: String
    var Province: String
    var  City: String
    var  CityCode: String
    var  Lat: String
    var  Lon: String
    var  Confirmed: Int
    var  Deaths: Int
    var Recovered: Int
    var Active: Int
    var Date: String
}

struct SearchBar: View {
      @Binding var text: String
      @State private var isEditing = false

      var body: some View {
          HStack {

              TextField("Search ...", text: $text)
                  .padding(7)
                  .padding(.horizontal, 25)
                  .background(Color(.systemGray6))
                  .cornerRadius(8)
                  .overlay(
                      HStack {
                          Image(systemName: "magnifyingglass")
                              .foregroundColor(.gray)
                              .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                              .padding(.leading, 8)
                   
                          if isEditing {
                              Button(action: {
                                  self.text = ""
                              }) {
                                  Image(systemName: "multiply.circle.fill")
                                      .foregroundColor(.gray)
                                      .padding(.trailing, 8)
                              }
                          }
                      }
                  )

                  .padding(.horizontal, 10)
                  .onTapGesture {
                      self.isEditing = true
                  }

              if isEditing {
                  Button(action: {
                      self.isEditing = false
                      self.text = ""

                  }) {
                      Text("Cancel")
                  }
                  .padding(.trailing, 10)
                  .transition(.move(edge: .trailing))
                  .animation(.default)
              }
          }
      }
  }

