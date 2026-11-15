import Foundation

/// Modelo de un planeta del sistema solar.
/// Contiene la información que se muestra en pantalla y los
/// parámetros que usa RealityKit para dibujarlo y animarlo.
struct Planet: Identifiable, Hashable {
    let id: String
    let order: Int
    let name: String
    let subtitle: String
    let description: String

    // Datos informativos
    let diameter: String
    let diameterKm: Double
    let distance: String
    let temperature: String
    let composition: String
    let dayLength: String
    let yearLength: String
    let moons: Int
    let fact: String

    // Parámetros visuales (escala didáctica, no real)
    let radius: Float          // tamaño base de la esfera en metros
    let orbitRadius: Float     // distancia al Sol en la experiencia inmersiva
    let orbitSpeed: Float      // velocidad de traslación (rad/s)
    let spinSpeed: Float       // velocidad de rotación (rad/s); negativo = retrógrado
    let axialTilt: Float       // inclinación del eje en grados
    let hasRings: Bool

    /// Cuántas veces cabe el diámetro de la Tierra en este planeta.
    var sizeComparedToEarth: Double { diameterKm / 12_742 }
}
