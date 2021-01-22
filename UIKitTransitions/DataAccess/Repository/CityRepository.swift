//
//  Copyright © 2021 Tamas Dancsi. All rights reserved.
//

import OpenCombine

protocol CityRepository {

    func getCities() -> [City]
    func getCity(name: String) -> City?
    func updateIsFavorite(city: City)
}

class CityRepositoryImpl: CityRepository {

    /// Since we're using mocked data, we need to have a singleton to hold the changes while the app is running
    static let shared = CityRepositoryImpl()

    var cities: [City] = []

    init() {
        cities = defaultCities
    }

    func getCities() -> [City] {
        cities
    }

    func getCity(name: String) -> City? {
        cities.first(where: { $0.name == name })
    }

    func updateIsFavorite(city: City) {
        if let index = cities.firstIndex(where: { $0.name == city.name }) {
            cities[index].isFavorite.toggle()
        }
    }

    // MARK: - Test data

    private let defaultCities = [
        City(name: "Bangkok",
             description: "Bangkok, Thailand’s capital, is a large city known for ornate shrines and vibrant street life. The boat-filled Chao Phraya River feeds its network of canals, flowing past the Rattanakosin royal district, home to opulent Grand Palace and its sacred Wat Phra Kaew Temple. Nearby is Wat Pho Temple with an enormous reclining Buddha and, on the opposite shore, Wat Arun Temple with its steep steps and Khmer-style spire.",
             photos: ["bangkok-1", "bangkok-2", "bangkok-3", "bangkok-4", "bangkok-5"],
             isFeatured: false,
             viewedCount: 376,
             favoritedCount: 23,
             isFavorite: false),
        City(name: "Barcelona",
             description: "Barcelona, the cosmopolitan capital of Spain’s Catalonia region, is known for its art and architecture. The fantastical Sagrada Família church and other modernist landmarks designed by Antoni Gaudí dot the city. Museu Picasso and Fundació Joan Miró feature modern art by their namesakes. City history museum MUHBA, includes several Roman archaeological sites.",
             photos: ["barcelona-1", "barcelona-2", "barcelona-3", "barcelona-4", "barcelona-5", "barcelona-6"],
             isFeatured: true,
             viewedCount: 763,
             favoritedCount: 99,
             isFavorite: true),
        City(name: "Budapest",
             description: "Budapest, Hungary’s capital, is bisected by the River Danube. Its 19th-century Chain Bridge connects the hilly Buda district with flat Pest. A funicular runs up Castle Hill to Buda’s Old Town, where the Budapest History Museum traces city life from Roman times onward. Trinity Square is home to 13th-century Matthias Church and the turrets of the Fishermen’s Bastion, which offer sweeping views.",
             photos: ["budapest-1", "budapest-2", "budapest-3", "budapest-4", "budapest-5"],
             isFeatured: false,
             viewedCount: 312,
             favoritedCount: 43,
             isFavorite: true),
        City(name: "Oslo",
             description: "Oslo, the capital of Norway, sits on the country’s southern coast at the head of the Oslofjord. It’s known for its green spaces and museums. Many of these are on the Bygdøy Peninsula, including the waterside Norwegian Maritime Museum and the Viking Ship Museum, with Viking ships from the 9th century. The Holmenkollbakken is a ski-jumping hill with panoramic views of the fjord. It also has a ski museum.",
             photos: ["oslo-1", "oslo-2", "oslo-3", "oslo-4", "oslo-5"],
             isFeatured: false,
             viewedCount: 240,
             favoritedCount: 37,
             isFavorite: true),
        City(name: "Saint Petersburg",
             description: "St. Petersburg is a Russian port city on the Baltic Sea. It was the imperial capital for 2 centuries, having been founded in 1703 by Peter the Great, subject of the city's iconic “Bronze Horseman” statue. It remains Russia's cultural center, with venues such as the Mariinsky Theatre hosting opera and ballet, and the State Russian Museum showcasing Russian art, from Orthodox icon paintings to Kandinsky works. ",
             photos: ["saint-petersburg-1", "saint-petersburg-2", "saint-petersburg-3", "saint-petersburg-4", "saint-petersburg-5"],
             isFeatured: true,
             viewedCount: 289,
             favoritedCount: 41,
             isFavorite: false),
        City(name: "San Diego",
             description: "San Diego is a city on the Pacific coast of California known for its beaches, parks and warm climate. Immense Balboa Park is the site of the renowned San Diego Zoo, as well as numerous art galleries, artist studios, museums and gardens. A deep harbor is home to a large active naval fleet, with the USS Midway, an aircraft-carrier-turned-museum, open to the public.",
             photos: ["san-diego-1", "san-diego-2", "san-diego-3", "san-diego-4", "san-diego-5", "san-diego-6"],
             isFeatured: true,
             viewedCount: 566,
             favoritedCount: 125,
             isFavorite: true),
        City(name: "Copenhagen",
             description: "Copenhagen, Denmark’s capital, sits on the coastal islands of Zealand and Amager. It’s linked to Malmo in southern Sweden by the Öresund Bridge. Indre By, the city's historic center, contains Frederiksstaden, an 18th-century rococo district, home to the royal family’s Amalienborg Palace. Nearby is Christiansborg Palace and the Renaissance-era Rosenborg Castle, surrounded by gardens and home to the crown jewels.",
             photos: ["copenhagen-1", "copenhagen-2", "copenhagen-3", "copenhagen-4", "copenhagen-5", "copenhagen-6"],
             isFeatured: false,
             viewedCount: 763,
             favoritedCount: 299,
             isFavorite: true)
    ]
}
