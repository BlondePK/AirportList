import SwiftUI


struct Model: Codable, Identifiable, Hashable {
    enum CodingKeys: CodingKey {
        case name
        case city
        case country
        case iata_code
        
    }
    
    var id = UUID()
    var name, city, country, iata_code: String
}

class Json: ObservableObject {
    @Published var json = [Model]()
    @Published var searchText: String = "" {
         didSet {
            self.searchResults = self.json.filter { $0.name == self.searchText }
            print(self.json.filter)
            print(searchText)
         }
    }
    @Published var searchResults: [Model] = []

    init() {
        load()
    }

    func load() {
        let path = Bundle.main.path(forResource: "Airports", ofType: "json")
        let url = URL(fileURLWithPath: path!)

        URLSession.shared.dataTask(with: url) { (data, responce, error) in
            do {
                if let data = data {
                    let json = try JSONDecoder().decode([Model].self, from: data)

                    DispatchQueue.main.sync {
                        self.json = json
                    }

                } else {
                    print("no Data")
                }

             } catch {
                print(error)
            }

        }.resume()
    }
}



struct ContentView: View {
    @ObservedObject var Airport = Json()

    var body: some View {
        VStack {
            TextField("Search for names", text: $Airport.searchText)
            List(Airport.searchResults.isEmpty ? Airport.json : Airport.searchResults) { item in

                VStack(alignment: .leading) {
                   Text(item.iata_code)
                   Text(item.name)
                }
            }
        }
    }
}



// @State private var searchTerm: String = ""

// SearchBar(text: $Airport.searchText)

//List(Airport.json) { item in
    
//    Text(item.iata_code)
        
    
//}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
