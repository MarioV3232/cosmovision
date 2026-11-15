import SwiftUI

struct PlanetCatalogView: View {

    enum Category: String, CaseIterable, Identifiable {
        case all = "Todos"
        case rocky = "Rocosos"
        case giants = "Gigantes"
        var id: String { rawValue }
    }

    @State private var search = ""
    @State private var category = Category.all

    private let columns = [GridItem(.adaptive(minimum: 215), spacing: 20)]

    private var filtered: [Planet] {
        PlanetDataService.planets
            .filter { planet in
                switch category {
                case .all: return true
                case .rocky: return planet.order <= 4
                case .giants: return planet.order > 4
                }
            }
            .filter { search.isEmpty || $0.name.localizedCaseInsensitiveContains(search) }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Descubre el sistema solar").font(.largeTitle.bold())
                Text("Ocho mundos, millones de preguntas. Selecciona uno para comenzar o abre la exploración inmersiva desde la barra superior.")
                    .foregroundStyle(.secondary)

                Picker("Categoría", selection: $category) {
                    ForEach(Category.allCases) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
                .frame(maxWidth: 380)

                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(filtered) { planet in
                        NavigationLink(value: planet) {
                            PlanetCard(planet: planet)
                        }
                        .buttonStyle(.plain)
                    }
                }

                if filtered.isEmpty {
                    ContentUnavailableView.search(text: search)
                }
            }
            .padding(28)
        }
        .searchable(text: $search, prompt: "Buscar planeta")
        .navigationTitle("Explorar")
        .navigationDestination(for: Planet.self) { PlanetDetailView(planet: $0) }
    }
}
