import SwiftUI
import RealityKit

/// Planeta 3D dentro de la ventana de detalle.
/// Se puede rotar arrastrando con la mano, con los botones, cambiar
/// el tamaño y activar/desactivar la rotación automática.
struct Planet3DView: View {

    let planet: Planet

    @State private var angle: Float = 0
    @State private var dragStartAngle: Float = 0
    @State private var scale: Float = 1
    @State private var autoRotate = true

    private let containerName = "planet-container"

    var body: some View {
        VStack(spacing: 0) {

            RealityView { content in
                // El contenedor recibe la rotación manual y la escala;
                // el planeta hijo gira solo con SpinComponent.
                let container = Entity()
                container.name = containerName
                container.position = [0, 0.045, 0.01]

                let model = PlanetEntityFactory.makePlanet(planet, radius: 0.045)
                container.addChild(model)
                content.add(container)

            } update: { content in
                guard let container = content.entities.first(where: { $0.name == containerName }) else {
                    return
                }

                container.transform.rotation = simd_quatf(angle: angle, axis: [0, 1, 0])
                container.transform.scale = SIMD3<Float>(repeating: scale)

                if let model = container.findEntity(named: planet.id),
                   var spin = model.components[SpinComponent.self] {
                    spin.isPaused = !autoRotate
                    model.components.set(spin)
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .targetedToAnyEntity()
                    .onChanged { value in
                        angle = dragStartAngle + Float(value.translation.width) * 0.012
                    }
                    .onEnded { _ in
                        dragStartAngle = angle
                    }
            )
            .frame(maxWidth: .infinity)
            .frame(height: 245)

            Text("Arrastra el planeta para girarlo")
                .font(.caption2)
                .foregroundStyle(.secondary)

            Spacer(minLength: 10)

            HStack(spacing: 10) {
                Button {
                    angle -= 0.35
                    dragStartAngle = angle
                } label: {
                    Label("Izquierda", systemImage: "rotate.left")
                }

                Button {
                    angle += 0.35
                    dragStartAngle = angle
                } label: {
                    Label("Derecha", systemImage: "rotate.right")
                }

                Toggle(isOn: $autoRotate) {
                    Label("Auto", systemImage: "arrow.triangle.2.circlepath")
                }
                .toggleStyle(.button)

                Spacer(minLength: 8)

                Text("Tamaño")
                    .font(.caption)

                Slider(value: $scale, in: 0.8...1.3)
                    .frame(width: 100)

                Button {
                    angle = 0
                    dragStartAngle = 0
                    scale = 1
                    autoRotate = true
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                }
                .help("Restablecer planeta")
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
            .padding(.horizontal, 16)
            .padding(.bottom, 14)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 350)
    }
}
