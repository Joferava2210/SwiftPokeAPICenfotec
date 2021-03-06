//
//  PokemonDetail.swift
//  SwiftPokeAPI
//
//  Created by Felipe Ramirez Vargas on 6/3/21.
//

import SwiftUI

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
                if let pokeUrl = URL(string:"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/"+String(id)+".png"){
                    Image(systemName: "square.fill").data(url: pokeUrl)
                        .frame(width: 200.0, height: 100.0)
                }
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

extension Image {
    func data(url: URL) -> Self {
        if let data = try? Data(contentsOf: url){
            guard let image = UIImage(data: data) else {
                return Image(systemName: "square.fill")
            }
            return Image(uiImage: image)
                .resizable()
        }
        return self.resizable()
    }
}

