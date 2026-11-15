import SwiftUI
import RealityKit

/// Experiencia inmersiva: el sistema solar completo flotando frente al usuario.
/// Los planetas orbitan alrededor del Sol y giran sobre su eje gracias a
/// `CelestialMotionSystem`. Se puede tocar un planeta para seleccionarlo.
struct SolarSystemImmersiveView: View {

    static let spaceID = "SolarSystemSpace"

    @Environment(AppState.self) private var appState
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    /// Entidad raíz que contiene al Sol, los planetas y las órbitas.
    @State private var root = Entity()

    /// Escala didáctica de los planetas dentro de la experiencia.
    private let planetScale: Float = 0.32

    var body: some View {
        RealityView { content, attachments in

            // El origen del espacio inmersivo está a nivel del suelo,
            // por eso se eleva el sistema a la altura de la vista.
            root.name = "solar-system-root"
            root.position = [0, 1.1, -2.3]
            content.add(root)

            root.addChild(PlanetEntityFactory.makeSun())

            for (index, planet) in PlanetDataService.planets.enumerated() {
                let radius = planet.radius * planetScale

                // Pivote: gira alrededor del Sol (traslación)
                let pivot = Entity()
                pivot.name = "pivot-\(planet.id)"
                pivot.orientation = simd_quatf(angle: Float(index) * 0.8, axis: [0, 1, 0])
                pivot.components.set(OrbitComponent(speed: planet.orbitSpeed))
                root.addChild(pivot)

                // Contenedor a la distancia orbital del planeta
                let holder = Entity()
                holder.position = [planet.orbitRadius, 0, 0]
                pivot.addChild(holder)

                // Planeta (gira sobre su eje)
                holder.addChild(PlanetEntityFactory.makePlanet(planet, radius: radius))

                // Etiqueta con el nombre, siempre mirando al usuario
                if let label = attachments.entity(for: "label-\(planet.id)") {
                    label.name = "label-\(planet.id)"
                    label.position = [0, radius + 0.045, 0]
                    label.components.set(BillboardComponent())
                    holder.addChild(label)
                }

                // Trayectoria de la órbita
                if let path = PlanetEntityFactory.makeOrbitPath(radius: planet.orbitRadius) {
                    path.name = "orbit-path-\(planet.id)"
                    root.addChild(path)
                }
            }

            // Panel de control flotante, más abajo y más cerca del usuario
            if let panel = attachments.entity(for: "controlPanel") {
                panel.position = [0, 0.78, -0.6]
                panel.orientation = simd_quatf(angle: -0.35, axis: [1, 0, 0])
                content.add(panel)
            }

        } update: { _, _ in
            applyState()
        } attachments: {
            ForEach(PlanetDataService.planets) { planet in
                Attachment(id: "label-\(planet.id)") {
                    Text(planet.name)
                        .font(.caption.bold())
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .glassBackgroundEffect()
                }
            }

            Attachment(id: "controlPanel") {
                ImmersiveControlPanel(appState: appState) {
                    Task {
                        await dismissImmersiveSpace()
                        appState.isImmersiveOpen = false
                    }
                }
            }
        }
        .gesture(
            TapGesture()
                .targetedToAnyEntity()
                .onEnded { value in
                    if PlanetDataService.planet(id: value.entity.name) != nil {
                        appState.selectedPlanetID = value.entity.name
                    }
                }
        )
        .onAppear { appState.isImmersiveOpen = true }
        .onDisappear { appState.isImmersiveOpen = false }
    }

    /// Sincroniza las entidades 3D con el estado de la interfaz.
    private func applyState() {
        for planet in PlanetDataService.planets {
            // Resaltar el planeta seleccionado
            if let model = root.findEntity(named: planet.id) {
                let scale: Float = planet.id == appState.selectedPlanetID ? 1.45 : 1.0
                model.scale = [scale, scale, scale]
            }

            // Pausa y velocidad de las órbitas
            if let pivot = root.findEntity(named: "pivot-\(planet.id)"),
               var orbit = pivot.components[OrbitComponent.self] {
                orbit.isPaused = appState.orbitsPaused
                orbit.multiplier = appState.orbitSpeed
                pivot.components.set(orbit)
            }

            root.findEntity(named: "orbit-path-\(planet.id)")?.isEnabled = appState.showOrbitPaths
            root.findEntity(named: "label-\(planet.id)")?.isEnabled = appState.showLabels
        }
    }
}

/// Panel de vidrio que se muestra dentro del espacio inmersivo.
private struct ImmersiveControlPanel: View {

    @Bindable var appState: AppState
    let onExit: () -> Void

    private var selected: Planet? {
        PlanetDataService.planet(id: appState.selectedPlanetID)
    }

    var body: some View {
        VStack(spacing: 14) {
            Label("CosmoVision · Sistema solar", systemImage: "sparkles")
                .font(.headline)

            if let planet = selected {
                HStack(alignment: .top, spacing: 18) {
                    Image("thumb_\(planet.id)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 56, height: 56)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(planet.name).font(.title2.bold())
                        Text(planet.subtitle).font(.callout).foregroundStyle(.secondary)
                        Text("\(planet.diameter) · \(planet.distance) del Sol · \(planet.moons) lunas")
                            .font(.caption)
                        Text(planet.fact)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .frame(maxWidth: 640, alignment: .leading)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(PlanetDataService.planets) { planet in
                        Button(planet.name) {
                            appState.selectedPlanetID = planet.id
                        }
                        .buttonStyle(.bordered)
                        .tint(appState.selectedPlanetID == planet.id ? .cyan : nil)
                    }
                }
            }
            .frame(maxWidth: 680)

            HStack(spacing: 16) {
                Button {
                    appState.orbitsPaused.toggle()
                } label: {
                    Label(appState.orbitsPaused ? "Reanudar" : "Pausar",
                          systemImage: appState.orbitsPaused ? "play.fill" : "pause.fill")
                }

                Image(systemName: "tortoise.fill")
                Slider(value: $appState.orbitSpeed, in: 0.2...4)
                    .frame(width: 160)
                Image(systemName: "hare.fill")

                Toggle("Órbitas", isOn: $appState.showOrbitPaths)
                    .toggleStyle(.button)
                Toggle("Nombres", isOn: $appState.showLabels)
                    .toggleStyle(.button)
            }

            Button(role: .destructive, action: onExit) {
                Label("Salir de la experiencia", systemImage: "xmark.circle.fill")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(24)
        .glassBackgroundEffect()
    }
}
