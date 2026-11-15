import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Query(sort: \FavoritePlanet.createdAt, order: .reverse) private var favorites: [FavoritePlanet]
    @Environment(\.modelContext) private var context
    private var planets: [Planet] { favorites.compactMap { PlanetDataService.planet(id: $0.planetID) } }
    var body: some View {
        Group {
            if planets.isEmpty {
                ContentUnavailableView("Sin favoritos", systemImage: "star", description: Text("Abre cualquier planeta y presiona Guardar favorito."))
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 230), spacing: 20)], spacing: 20) {
                        ForEach(planets) { planet in
                            VStack(spacing: 12) {
                                NavigationLink(value: planet) { PlanetCard(planet: planet) }.buttonStyle(.plain)
                                Button(role: .destructive) {
                                    FavoritesStore.toggle(planet, favorites: favorites, context: context)
                                } label: { Label("Quitar de favoritos", systemImage: "star.slash") }
                            }
                        }
                    }.padding(28)
                }
            }
        }
        .navigationTitle("Mis favoritos")
        .navigationDestination(for: Planet.self) { PlanetDetailView(planet: $0) }
    }
}
