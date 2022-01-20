//
//  GeneralView.swift
//  SupHealth
//
//  Created by Student Supinfo on 23/06/2020.
//  Copyright © 2020 Student Supinfo. All rights reserved.
//

import SwiftUI

 

struct GeneralView: View {
 
    @State private var results = Summary(Global: Global(NewConfirmed: 0, TotalConfirmed: 0, NewDeaths: 0, TotalDeaths: 0, NewRecovered: 0, TotalRecovered: 0) , Countries: [Country](), Date:"")
   // hadi hiya la variable li aye dar fiha les donnees li jaw man api initilistha bach mi trach erreur 
   // ola majawch li donnée ikono des 0
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) { 
        // scrollview ra bayna man smiytha bach ikon scroll dakchi twil omakibanch kamal
        VStack (spacing: 20){
            Text("Suphealth").font(.largeTitle).frame(maxWidth: .infinity, alignment: .leading)
            Image("Image").resizable().frame(minWidth: 380.0, minHeight: 330.0 )
        
            HStack{
            Image(systemName: "circle.fill").foregroundColor(.red)
            .font(.system(size: 10, weight: .ultraLight))
            Text("Total Confirmed")
            }
            VStack{
            Text("\(results.Global.TotalConfirmed)").bold().foregroundColor(.red).font(.system(size: 25))
            Text("+\(results.Global.NewConfirmed)").foregroundColor(.gray)
            }
            HStack{
                VStack{
                    HStack{
                        Image(systemName: "circle.fill").foregroundColor(.green)
                            .font(.system(size: 10, weight: .ultraLight))
                        Text("Total Recovered")
                    }
                    Text("\(results.Global.TotalRecovered)").foregroundColor(.green).font(.system(size: 25))
                    Text("+\(results.Global.NewRecovered)").foregroundColor(.gray)                }
                Spacer()
                VStack{
                    HStack{
                        Image(systemName: "circle.fill").foregroundColor(.secondary)
                        .font(.system(size: 10, weight: .ultraLight))
                        Text("Total Deaths")
                    }
                    Text("\(results.Global.TotalDeaths)").foregroundColor(.secondary).font(.system(size: 25))
                    Text("+\(results.Global.NewDeaths)").foregroundColor(.gray)
                }
            }
            
            Spacer()
            Image("s").resizable().frame(minWidth: 380.0, minHeight: 380.0)
            Spacer()
            
        }.onAppear(perform: loadData)// had l3iba bach mi tban stack li jam3a hadcchi kmal t3ayat lina 3la la fct li ate jib donee man api

            .padding()
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        // had frame bach tchad l surface dyal iphone ola tablette kamla
    }
    }
    
    //function to load data from api 
    func loadData() {
        //hadi bach tsayab url man string hit khas n3tiw lfct variabl type dyal url machi string
        let url = URL(string: "https://api.covid19api.com/summary")!
           
           // ha li ate jibe lin donnee man api 
           URLSession.shared.dataTask(with: url) {(data, response, error) in
               do {

                   // hna darna l variable todoData odarna fiha data lijat o t7a9a9na bli raha 3amra
                   if let todoData = data {
                       //hna kan decodiw data 3la 7ssab struct smitha summary ate l9aha f ficher searchBar.swift
                       let decodedData = try JSONDecoder().decode(Summary.self, from: todoData)

                       // hna darnaha f les donnees li decodina f variable results 
                       //had variable result kayna f lview 7it lakhrin kolhom kib9aw wast fct hadi la decalarinaha deja f view
                       // daba raha machi global 7it haf fct ba3da ka tsama fct dyal view ya3ni ate 9dar tkhdam b les variable dyal view
                       // kokant la fct bara had view khas tkon variables global 
                       // hadi wa7ad ma3loma hadi fonstion dyal view machi ki les autre language ki kono ga3 les fonction bara
                       DispatchQueue.main.async {
                          self.results = decodedData
                       }
                   } else { // had else la majatna ta donnee
                       print("No data")
                   }
               } catch { // hadi lakan chi erreur
                   print("Error")
               }
           }.resume() // hade resume ma3rftch dyalach
    }
}

/// hadi a bach iban lina dak previw f tele li f janbe bla man runiw
struct GeneralView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralView()
    }
}
