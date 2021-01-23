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
             isFeatured: true,
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
             isFeatured: false,
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
             isFavorite: true),
        City(name: "London",
             description: "London, the capital of England and the United Kingdom, is a 21st-century city with history stretching back to Roman times. At its centre stand the imposing Houses of Parliament, the iconic ‘Big Ben’ clock tower and Westminster Abbey, site of British monarch coronations. Across the Thames River, the London Eye observation wheel provides panoramic views of the South Bank cultural complex, and the entire city.",
             photos: ["london-1", "london-2", "london-3", "london-4", "london-5", "london-6"],
             isFeatured: false,
             viewedCount: 999,
             favoritedCount: 569,
             isFavorite: false),
        City(name: "Tokyo",
             description: "Tokyo, Japan’s busy capital, mixes the ultramodern and the traditional, from neon-lit skyscrapers to historic temples. The opulent Meiji Shinto Shrine is known for its towering gate and surrounding woods. The Imperial Palace sits amid large public gardens. The city's many museums offer exhibits ranging from classical art (in the Tokyo National Museum) to a reconstructed kabuki theater (in the Edo-Tokyo Museum).",
             photos: ["tokyo-1", "tokyo-2", "tokyo-3", "tokyo-4", "tokyo-5", "tokyo-6"],
             isFeatured: true,
             viewedCount: 765,
             favoritedCount: 344,
             isFavorite: false),
        City(name: "Mumbai",
             description: "Mumbai (formerly called Bombay) is a densely populated city on India’s west coast. A financial center, it's India's largest city. On the Mumbai Harbour waterfront stands the iconic Gateway of India stone arch, built by the British Raj in 1924. Offshore, nearby Elephanta Island holds ancient cave temples dedicated to the Hindu god Shiva. The city's also famous as the heart of the Bollywood film industry.",
             photos: ["mumbai-1", "mumbai-2", "mumbai-3", "mumbai-4", "mumbai-5", "mumbai-6"],
             isFeatured: true,
             viewedCount: 566,
             favoritedCount: 400,
             isFavorite: true),
        City(name: "Sydney",
             description: "Sydney, capital of New South Wales and one of Australia's largest cities, is best known for its harbourfront Sydney Opera House, with a distinctive sail-like design. Massive Darling Harbour and the smaller Circular Quay port are hubs of waterside life, with the arched Harbour Bridge and esteemed Royal Botanic Garden nearby. Sydney Tower’s outdoor platform, the Skywalk, offers 360-degree views of the city and suburbs.",
             photos: ["sydney-1", "sydney-2", "sydney-3", "sydney-4", "sydney-5", "sydney-6"],
             isFeatured: false,
             viewedCount: 611,
             favoritedCount: 324,
             isFavorite: false),
        City(name: "Buenos Aires",
             description: "Buenos Aires is Argentina’s big, cosmopolitan capital city. Its center is the Plaza de Mayo, lined with stately 19th-century buildings including Casa Rosada, the iconic, balconied presidential palace. Other major attractions include Teatro Colón, a grand 1908 opera house with nearly 2,500 seats, and the modern MALBA museum, displaying Latin American art.",
             photos: ["buenos-aires-1", "buenos-aires-2", "buenos-aires-3", "buenos-aires-4", "buenos-aires-5", "buenos-aires-6"],
             isFeatured: false,
             viewedCount: 534,
             favoritedCount: 230,
             isFavorite: false),
        City(name: "New York",
             description: "New York City comprises 5 boroughs sitting where the Hudson River meets the Atlantic Ocean. At its core is Manhattan, a densely populated borough that’s among the world’s major commercial, financial and cultural centers. Its iconic sites include skyscrapers such as the Empire State Building and sprawling Central Park. Broadway theater is staged in neon-lit Times Square.",
             photos: ["new-york-1", "new-york-2", "new-york-3", "new-york-4", "new-york-5", "new-york-6"],
             isFeatured: true,
             viewedCount: 1329,
             favoritedCount: 698,
             isFavorite: false)
    ]
}
