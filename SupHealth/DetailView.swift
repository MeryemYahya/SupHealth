//
//  DetailView.swift
//  SupHealth
//
//  Created by Student Supinfo on 23/06/2020.
//  Copyright © 2020 Student Supinfo. All rights reserved.
//

import SwiftUI

/// had l3ayba bach tban share screen bach npartajiw f message hada a bonus
struct ActivityView: UIViewControllerRepresentable {

    let activityItems: [Any]
    let applicationActivities: [UIActivity]?

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems,
                                        applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController,
                                context: UIViewControllerRepresentableContext<ActivityView>) {

    }
}

/// hadi hiya l view dyalna
struct DetailView: View {
    /// hadi bach nkhadmo b l3ayba dyal favori hiya ra 3la chkal class wastha des fct
    @EnvironmentObject var favorites: Favorites
/// had item hiya country li warkna 3liha bach nchofo detail dyalha
    var item: Countries


    @State private var c = [CountryD]()//had variable o9ila makhdamtch biha kant ka jarab ayi 7aja fach makhdamchi api


/// hadi li ayekono fiha les donnes li aye jiw man apiraha initaliser bach la majwch donne mat crashich l app
    @State private var todos = CountryD(Country: "", CountryCode: "", Province: "", City: "", CityCode: "", Lat: "", Lon: "", Confirmed: 0, Deaths: 0, Recovered: 0, Active: 0, Date: "")
    

    @State private var showingSheet = false// hadi tahiya variable a zayda b7al li ta7tha
    @State private var isShareSheetShowing  = false// hadi dyal share sheet l bonus
   
   // ha body dyal view li fiha text o l image 
    var body: some View {
        // vstack o hstack ma3andi man chra7 fiha omakine lach isawlak hadi dyalach 
        VStack (alignment: .leading , spacing: 20 ){
            
            HStack{
                // hada title fih smit country
                Text(item.Country).font(.largeTitle)//item.country kima galt lik country liwarakna 3liha bach nchofo detail 
                // .countryattribut fih smit country

                // hadi lakant f favoris ki ban 9alb 7mar
                if self.favorites.contains(item) {
                    Image(systemName: "heart.fill")
                        .accessibility(label: Text("This is a favorite country"))
                        .foregroundColor(.red)
                }
                
            }
            HStack{  // had stck fih nbr confirmed case
                Image(systemName: "circle.fill").foregroundColor(.red)
                    .font(.system(size: 10, weight: .ultraLight))
                Text("Confirmed : \(todos.Active)")
            }
            HStack{ // nbr deaths
                Image(systemName: "circle.fill").foregroundColor(.secondary)
                    .font(.system(size: 10, weight: .ultraLight))
 
                Text("Deaths : \(todos.Deaths)")
                
            }
            HStack{ //hna ch7al d recovred
                Image(systemName: "circle.fill").foregroundColor(.green)
                    .font(.system(size: 10, weight: .ultraLight))
                Text("Recovered : \(todos.Recovered)")
            }
            HStack{ // hna active 
                Image(systemName: "circle.fill").foregroundColor(.blue)
                    .font(.system(size: 10, weight: .ultraLight))
                Text("Active : \(todos.Active)")
            }
            
            HStack{ // hada boutton share bonus
                Button(action: share) {
                    Text("Share")
                }
                
        //buton bach nzido l favorite
                Button(favorites.contains(item) ? "Remove from Favorites" : "Add to Favorites") {
                    if self.favorites.contains(self.item) {
                        self.favorites.remove(self.item)
                    } else {
                        self.favorites.add(self.item)
                    }
                }.padding()
                
            }
            
        }.onAppear(perform: loadDetail) // had l3iba bach mi tban stack li jam3a hadcchi kmal t3ayat lina 3la la fct li ate jib donee man api
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
             // had frame bach tchad l surface dyal iphone ola tablette kamla
             //il madrnahach ki ban dakchi f lwast
            .padding()
    }

    // share detail in message
    func share(){
        isShareSheetShowing.toggle()
        let s = "Country : \(item.Country) Active : \(todos.Active) "
        let av = UIActivityViewController(activityItems: [s], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av , animated: true , completion: nil)
    }

    // hadi chra7tha lik 
    // load data from api
    func loadDetail(){

        /// hadi bach nsyabo url man string hit khas n3tiw lfct variabl type dyal url machi string
        
          //item.Slug hiya bach ane 9adro njibo les donnes dyal wa7ad country
        // dkhole site ate l9a had lmital 
        //https://api.covid19api.com/live/country/south-africa
        //south-africa howa slug
        let url = URL(string: "https://api.covid19api.com/live/country/\(item.Slug)")!
        
        //ha li ate jib lina donee man api
        // with url fin dakhlna url
        // data , response , error ki node js calback ola chno hadchi
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            do {
                // hna creyin variable tododata o darna fih les data li jate
                // o if bach n3arfooche jat chi data ola variable khawya
                if let todoData = data {
                    
                    /// hna ane decodiwha [CountryD] ma3natha aye jina array dyal CountryD
                    //CountryD struct ate l9aha f ficher SearchBar.swift
                    ///
                    let decodedData = try JSONDecoder().decode([CountryD].self, from: todoData)

                    ///todos variable li galt li lfo9 decalarinaha f voew ohia li n 9adro nkhadmo biha
                    // daba hadi kat tsama fct dyal view wlk man9drch nkhadmo b les variible lfiha 
                    //i9dare isawlak flach had fct f wast view
                    //7na normalment kan diro fct bra l main f les language lakhrin
                    //hna t9dar dire fonction interne dyal view
                    //man7tajoche ndiro variable global ki accedi nicha li variable li declarina f l view
                    DispatchQueue.main.async {
                        //// ila 39alti ki jiw les donne dyal c7al man nhar odyal kolasa3a
                        ///khadit akhire donnee jaw
                        //daba jaw donee tabrklah ate 3mar variable 
                        //majaw dik ?? ma3nitha ate b9a kima hiya
                       
                        self.todos = decodedData.last ?? self.todos
                    }
                } else {//hadi la maknt ta mochkil a data majatch
                    print("No data")
                }
            } catch {// hana lakan erreur
                print("Error")
            }
        }.resume()//hadi ma3rte
    }
}

