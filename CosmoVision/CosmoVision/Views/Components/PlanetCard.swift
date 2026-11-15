import SwiftUI

struct PlanetCard: View {
    let planet: Planet
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 18).fill(.white.opacity(0.035))
                // Vista previa renderizada a partir de la textura real del planeta
                Image("thumb_\(planet.id)")
                    .resizable()
                    .scaledToFit()
                    .frame(height: planet.hasRings ? 165 : 120)
                    .shadow(color: PlanetVisualStyle.swiftUIColor(for: planet.id).opacity(0.35), radius: 24)
            }
            .frame(height: 170)
            Text(planet.name).font(.title3.bold())
            Text(planet.subtitle).font(.subheadline).foregroundStyle(.secondary).lineLimit(2)
            HStack(spacing: 12) {
                Label("#\(planet.order)", systemImage: "number")
                Label("\(planet.moons)", systemImage: "moon.fill")
                if planet.hasRings { Label("Anillos", systemImage: "circle.circle") }
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 24))
        .hoverEffect(.lift)
    }
}
