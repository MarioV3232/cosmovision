import SwiftUI
import SwiftData

@main
struct CosmoVisionApp: App {

    @State private var appState = AppState()

    init() {
        // Registrar componentes y sistema de animación de RealityKit
        CelestialMotionSystem.registerAll()
    }

    var body: some Scene {

        // 1. Ventana principal
        WindowGroup(id: "MainWindow") {
            HomeView()
                .environment(appState)
        }
        .defaultSize(width: 1150, height: 760)
        .modelContainer(for: FavoritePlanet.self)

        // 2. Volumen 3D: muestra un planeta flotando en el espacio del usuario
        WindowGroup(id: PlanetVolumeView.windowID, for: String.self) { $planetID in
            PlanetVolumeView(planetID: planetID ?? "earth")
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 0.6, height: 0.6, depth: 0.6, in: .meters)

        // 3. Espacio inmersivo: sistema solar completo alrededor del usuario
        ImmersiveSpace(id: SolarSystemImmersiveView.spaceID) {
            SolarSystemImmersiveView()
                .environment(appState)
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
    }
}
