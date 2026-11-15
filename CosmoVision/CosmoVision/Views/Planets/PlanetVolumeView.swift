import SwiftUI
import RealityKit

/// Ventana volumétrica: el planeta flota en el espacio del usuario
/// y se puede ver desde cualquier ángulo caminando a su alrededor.
struct PlanetVolumeView: View {

    static let windowID = "PlanetVolume"

    let planetID: String

    @State private var angle: Float = 0
    @State private var dragStartAngle: Float = 0

    private var planet: Planet? { PlanetDataService.planet(id: planetID) }

    var body: some View {
        if let planet {
            RealityView { content, attachments in
                let container = Entity()
                container.name = "volume-container"
                container.position = [0, 0.04, 0]

                // Saturno se hace un poco más pequeño para que quepan sus anillos
                let radius: Float = planet.hasRings ? 0.11 : 0.17
                container.addChild(PlanetEntityFactory.makePlanet(planet, radius: radius))
                content.add(container)

                if let info = attachments.entity(for: "info") {
                    info.position = [0, -0.24, 0.12]
                    content.add(info)
                }
            } update: { content, _ in
                content.entities
                    .first(where: { $0.name == "volume-container" })?
                    .transform.rotation = simd_quatf(angle: angle, axis: [0, 1, 0])
            } attachments: {
                Attachment(id: "info") {
                    VStack(spacing: 4) {
                        Text(planet.name).font(.title.bold())
                        Text("\(planet.diameter) · \(planet.moons) lunas · Año: \(planet.yearLength)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 22)
                    .padding(.vertical, 12)
                    .glassBackgroundEffect()
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .targetedToAnyEntity()
                    .onChanged { value in
                        angle = dragStartAngle + Float(value.translation.width) * 0.01
                    }
                    .onEnded { _ in dragStartAngle = angle }
            )
        } else {
            ContentUnavailableView("Planeta no encontrado", systemImage: "questionmark.circle")
        }
    }
}
