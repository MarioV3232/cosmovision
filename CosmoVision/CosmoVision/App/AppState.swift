import Observation

/// Estado global compartido entre la ventana principal,
/// el volumen 3D y el espacio inmersivo.
@MainActor
@Observable
final class AppState {
    // Espacio inmersivo
    var isImmersiveOpen = false
    var isImmersiveTransitioning = false

    // Planeta seleccionado en la experiencia inmersiva
    var selectedPlanetID = "earth"

    // Controles de la simulación
    var orbitsPaused = false
    var orbitSpeed: Float = 1.0
    var showOrbitPaths = true
    var showLabels = true
}
