import SwiftUI

/// Compara el tamaño real (proporcional) de dos planetas.
/// A diferencia de los modelos 3D, aquí los círculos sí respetan
/// la proporción entre diámetros.
struct CompareView: View {

    @State private var firstID = "earth"
    @State private var secondID = "jupiter"

    private var first: Planet { PlanetDataService.planet(id: firstID) ?? PlanetDataService.planets[0] }
    private var second: Planet { PlanetDataService.planet(id: secondID) ?? PlanetDataService.planets[0] }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Comparar tamaños").font(.largeTitle.bold())
                Text("Elige dos planetas y observa su tamaño a escala real entre ellos.")
                    .foregroundStyle(.secondary)

                HStack(spacing: 20) {
                    planetPicker("Primer planeta", selection: $firstID)
                    Button {
                        let temp = firstID
                        firstID = secondID
                        secondID = temp
                    } label: {
                        Image(systemName: "arrow.left.arrow.right")
                    }
                    .help("Intercambiar")
                    planetPicker("Segundo planeta", selection: $secondID)
                }

                comparisonCanvas
                    .frame(height: 320)
                    .frame(maxWidth: .infinity)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 24))

                Text(summary)
                    .font(.title3.weight(.semibold))

                Grid(alignment: .leading, horizontalSpacing: 30, verticalSpacing: 14) {
                    GridRow {
                        Text("")
                        Text(first.name).font(.headline)
                        Text(second.name).font(.headline)
                    }
                    Divider().gridCellColumns(3)
                    row("Diámetro", first.diameter, second.diameter)
                    row("Distancia al Sol", first.distance, second.distance)
                    row("Duración del año", first.yearLength, second.yearLength)
                    row("Duración del día", first.dayLength, second.dayLength)
                    row("Lunas", "\(first.moons)", "\(second.moons)")
                    row("Anillos destacados", first.hasRings ? "Sí" : "No", second.hasRings ? "Sí" : "No")
                }
                .padding(22)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
            }
            .padding(28)
            .frame(maxWidth: 950, alignment: .leading)
        }
        .navigationTitle("Comparar")
        .animation(.spring(duration: 0.5), value: firstID)
        .animation(.spring(duration: 0.5), value: secondID)
    }

    // MARK: - Componentes

    private var comparisonCanvas: some View {
        GeometryReader { proxy in
            let maxDiameter = max(first.diameterKm, second.diameterKm)
            let available = min(proxy.size.height - 70, (proxy.size.width - 80) / 2)

            HStack(alignment: .bottom, spacing: 40) {
                planetCircle(first, size: available * CGFloat(first.diameterKm / maxDiameter))
                planetCircle(second, size: available * CGFloat(second.diameterKm / maxDiameter))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(20)
    }

    private func planetCircle(_ planet: Planet, size: CGFloat) -> some View {
        VStack(spacing: 10) {
            // La miniatura de Saturno incluye anillos, por eso se agranda
            // para que el cuerpo del planeta conserve la proporción real.
            let imageSize = max(size, 3) * (planet.hasRings ? 2.4 / 1.05 : 1)
            Image("thumb_\(planet.id)")
                .resizable()
                .scaledToFit()
                .frame(width: imageSize, height: imageSize)
                .frame(width: max(size, 3), height: max(size, 3))
                .shadow(color: PlanetVisualStyle.swiftUIColor(for: planet.id).opacity(0.4), radius: 18)
            Text(planet.name).font(.headline)
        }
    }

    private func planetPicker(_ title: String, selection: Binding<String>) -> some View {
        Picker(title, selection: selection) {
            ForEach(PlanetDataService.planets) { planet in
                Text(planet.name).tag(planet.id)
            }
        }
        .pickerStyle(.menu)
    }

    private var summary: String {
        if first.id == second.id { return "Elegiste el mismo planeta en ambos lados." }
        let bigger = first.diameterKm >= second.diameterKm ? first : second
        let smaller = bigger.id == first.id ? second : first
        let ratio = bigger.diameterKm / smaller.diameterKm
        let volume = pow(ratio, 3)
        return String(format: "%@ es %.1f veces más ancho que %@. Dentro de él cabrían unos %.0f planetas como %@.",
                      bigger.name, ratio, smaller.name, volume, smaller.name)
    }

    @ViewBuilder
    private func row(_ label: String, _ a: String, _ b: String) -> some View {
        GridRow {
            Text(label).foregroundStyle(.secondary)
            Text(a).fontWeight(.semibold)
            Text(b).fontWeight(.semibold)
        }
    }
}
