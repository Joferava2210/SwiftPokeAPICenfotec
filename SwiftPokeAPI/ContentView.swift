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
        List(results, id: \.name){ item in
            VStack(alignment: .leading){
                Text("Pokemon")
                Button(action: {
                    print("The Pokemon selected is: " + item.name);
                }) {
                    Text(item.name.uppercased());
                }
                .foregroundColor(.blue)
                .font(.title2)
                Spacer()
            }.lineSpacing(10.0)
            
        }.onAppear(perform: loadData)
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
    

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
