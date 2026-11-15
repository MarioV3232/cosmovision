import RealityKit

/// Hace girar una entidad sobre su propio eje (rotación del planeta).
struct SpinComponent: Component {
    var speed: Float                       // radianes por segundo
    var axis: SIMD3<Float> = [0, 1, 0]     // eje local de giro
    var isPaused = false
}

/// Hace girar un "pivote" alrededor del Sol (traslación del planeta).
/// El planeta es hijo del pivote, así que al girar el pivote el planeta orbita.
struct OrbitComponent: Component {
    var speed: Float                       // radianes por segundo
    var multiplier: Float = 1              // control de velocidad desde la interfaz
    var isPaused = false
}

/// Sistema de RealityKit que se ejecuta en cada fotograma y aplica
/// la rotación y la traslación a las entidades que tengan los componentes.
struct CelestialMotionSystem: System {

    private static let spinQuery = EntityQuery(where: .has(SpinComponent.self))
    private static let orbitQuery = EntityQuery(where: .has(OrbitComponent.self))

    init(scene: RealityKit.Scene) {}

    func update(context: SceneUpdateContext) {
        let deltaTime = Float(context.deltaTime)

        for entity in context.entities(matching: Self.spinQuery, updatingSystemWhen: .rendering) {
            guard let spin = entity.components[SpinComponent.self], !spin.isPaused else { continue }
            let step = simd_quatf(angle: spin.speed * deltaTime, axis: spin.axis)
            entity.setOrientation(step, relativeTo: entity)
        }

        for entity in context.entities(matching: Self.orbitQuery, updatingSystemWhen: .rendering) {
            guard let orbit = entity.components[OrbitComponent.self], !orbit.isPaused else { continue }
            let step = simd_quatf(angle: orbit.speed * orbit.multiplier * deltaTime, axis: [0, 1, 0])
            entity.setOrientation(step, relativeTo: entity)
        }
    }

    /// Registra componentes y sistema. Se llama una sola vez al iniciar la app.
    static func registerAll() {
        SpinComponent.registerComponent()
        OrbitComponent.registerComponent()
        CelestialMotionSystem.registerSystem()
    }
}
