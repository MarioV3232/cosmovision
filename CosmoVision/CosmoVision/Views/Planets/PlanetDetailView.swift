import SwiftUI
import SwiftData

struct PlanetDetailView: View {

    let planet: Planet

    @Environment(\.modelContext) private var context
    @Environment(\.openWindow) private var openWindow
    @Query private var favorites: [FavoritePlanet]

    private var isFavorite: Bool {
        favorites.contains { $0.planetID == planet.id }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // Encabezado
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Planeta \(planet.order) de 8")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.cyan)
                        Text(planet.name).font(.largeTitle.bold())
                        Text(planet.subtitle).font(.title3).foregroundStyle(.secondary)
                        Text(planet.description).font(.body)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 10) {
                        Button {
                            FavoritesStore.toggle(planet, favorites: favorites, context: context)
                        } label: {
                            Label(isFavorite ? "Quitar favorito" : "Guardar favorito",
                                  systemImage: isFavorite ? "star.fill" : "star")
                        }

                        Button {
                            openWindow(id: PlanetVolumeView.windowID, value: planet.id)
                        } label: {
                            Label("Ver en volumen 3D", systemImage: "cube.transparent")
                        }
                    }
                }

                // Modelo 3D interactivo
                Planet3DView(planet: planet)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 22))

                // Datos principales
                Grid(alignment: .leading, horizontalSpacing: 28, verticalSpacing: 18) {
                    factRow("Diámetro aproximado", planet.diameter)
                    factRow("Tamaño frente a la Tierra", sizeText)
                    factRow("Distancia media al Sol", planet.distance)
                    factRow("Temperatura aproximada", planet.temperature)
                    factRow("Rotación (duración del día)", planet.dayLength)
                    factRow("Traslación (duración del año)", planet.yearLength)
                    factRow("Lunas conocidas", planet.moons == 0 ? "Ninguna" : "\(planet.moons)")
                    factRow("Composición principal", planet.composition)
                }
                .padding(22)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))

                GroupBox("¿Sabías que…?") {
                    Text(planet.fact)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                }

                Text("Los tamaños 3D están adaptados para visualización educativa y no representan la escala real. El número de lunas se actualiza con frecuencia por nuevos descubrimientos.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(28)
            .frame(maxWidth: 950)
        }
        .navigationTitle(planet.name)
    }

    private var sizeText: String {
        let ratio = planet.sizeComparedToEarth
        if planet.id == "earth" { return "Referencia (1×)" }
        return String(format: "%.2f× el diámetro terrestre", ratio)
    }

    @ViewBuilder
    private func factRow(_ name: String, _ value: String) -> some View {
        GridRow {
            Text(name).foregroundStyle(.secondary)
            Text(value).fontWeight(.semibold)
        }
    }
}
