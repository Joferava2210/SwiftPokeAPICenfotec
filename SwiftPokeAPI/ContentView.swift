//
//  ContentView.swift
//  SwiftPokeAPI
//
//  Created by Felipe Ramirez Vargas on 4/3/21.
//

import SwiftUI

struct ContentView: View {
    
    @State var results = [Pokemon]()
    
    var body: some View {
        NavigationView{
            List(results, id: \.name){ item in
                VStack(alignment: .leading){
                    Text("Pokemon")
//                    Button(action: {
//                        print("The Pokemon selected is: " + item.name);
//                    }) {
                        Text(item.name.uppercased())
//                    }
                    .foregroundColor(.blue)
                    .font(.title2)
                    Spacer()
                }.lineSpacing(10.0)
                NavigationLink(destination: PokemonDetail(pokeDetail: item, weight: 1, height: 1, id: 1)){
                    
                }
            }.onAppear(perform: loadData)
            .navigationBarTitle("Lista de Pokemones")
            .padding()
        }
    }
    
    func loadData(){
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon") else{
            print("The API url is not valid")
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request){data,
            response, error in
            if let data = data {
                if let response = try?
                    JSONDecoder().decode(Root.self,
                                         from: data){
                    DispatchQueue.main.async {
                        self.results = response.results
                    }
                    return
                }
            }
        }.resume()
    }
}

struct PokemonDetail: View {
    var pokeDetail: Pokemon
    @State var weight: Int
    @State var height: Int
    @State var id: Int
    
    var body: some View {
        VStack {
            Text("Details").font(.title).bold()
            VStack {
                Text("Name: "+pokeDetail.name.uppercased()).bold()
                Text("Id: "+String(id)).bold()
                Text("URL: "+pokeDetail.url).bold()
                Text("Weight "+String(weight)).bold()
                Text("Height "+String(height)).bold()
            }.onAppear(perform:{
                self.loadDetails(urlInfo: pokeDetail.url)
            })
            Spacer()
        }
    }
    
    func loadDetails(urlInfo: String){
        guard let url = URL(string: urlInfo) else{
            print("The API url is not valid")
            return
        }
        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request){data,
            response, error in
            if let data = data {
                if let response = try?
                    JSONDecoder().decode(PokemonInfo.self,
                                         from: data){
                    DispatchQueue.main.async {
                        self.weight = response.weight
                        self.height = response.height
                        self.id = response.id
                    }
                    return
                }
            }
        }.resume()
    }
    
}
    

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
