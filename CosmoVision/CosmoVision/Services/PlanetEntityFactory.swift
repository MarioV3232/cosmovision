import RealityKit
import UIKit

/// Construye las entidades 3D (planetas, Sol, anillos y órbitas) con RealityKit.
/// Todo se genera por código, sin modelos externos, para que el proyecto
/// compile sin depender de archivos .usdz.
@MainActor
enum PlanetEntityFactory {

    // MARK: - Texturas

    /// Caché para no cargar la misma imagen varias veces.
    private static var textureCache: [String: TextureResource] = [:]

    /// Carga una textura incluida en la app (carpeta Resources/Textures).
    /// Texturas: Solar System Scope (CC BY 4.0), basadas en datos de la NASA.
    static func texture(_ fileName: String) -> TextureResource? {
        if let cached = textureCache[fileName] { return cached }
        let parts = fileName.split(separator: ".")
        guard parts.count == 2,
              let url = Bundle.main.url(forResource: String(parts[0]), withExtension: String(parts[1])),
              let texture = try? TextureResource.load(contentsOf: url) else {
            return nil
        }
        textureCache[fileName] = texture
        return texture
    }

    /// Crea un planeta como esfera con material, inclinación axial,
    /// rotación automática y anillos si corresponde.
    /// - Parameters:
    ///   - radius: radio de la esfera en metros.
    ///   - spinning: si es `true`, el planeta gira sobre su eje.
    ///   - tappable: agrega colisión y entrada para poder tocarlo/arrastrarlo.
    static func makePlanet(
        _ planet: Planet,
        radius: Float = 0.20,
        spinning: Bool = true,
        tappable: Bool = true
    ) -> ModelEntity {

        let mesh = MeshResource.generateSphere(radius: radius)
        var material = PhysicallyBasedMaterial()
        if let texture = texture("planet_\(planet.id).jpg") {
            // Mapa real de la superficie del planeta
            material.baseColor = .init(tint: .white, texture: .init(texture))
        } else {
            // Respaldo: color sólido si no se encuentra la imagen
            material.baseColor = .init(tint: PlanetVisualStyle.color(for: planet.id))
        }
        material.roughness = .init(floatLiteral: 0.85)
        material.metallic = .init(floatLiteral: 0.0)

        let entity = ModelEntity(mesh: mesh, materials: [material])
        entity.name = planet.id

        // Inclinación del eje de rotación (en grados → radianes)
        let tilt = planet.axialTilt * .pi / 180
        entity.orientation = simd_quatf(angle: tilt, axis: [0, 0, 1])

        if spinning {
            entity.components.set(SpinComponent(speed: planet.spinSpeed * 0.6))
        }

        if planet.hasRings, let ring = makeRing(planetRadius: radius) {
            entity.addChild(ring)
        }

        if tappable {
            entity.components.set(InputTargetComponent())
            entity.components.set(CollisionComponent(shapes: [.generateSphere(radius: radius)]))
            entity.components.set(HoverEffectComponent())
        }

        return entity
    }

    /// Sol emisivo con un halo y una luz puntual que ilumina a los planetas.
    static func makeSun(radius: Float = 0.14) -> Entity {
        let sun = Entity()
        sun.name = "sun"

        var sunMaterial = UnlitMaterial(color: PlanetVisualStyle.sunColor)
        if let texture = texture("planet_sun.jpg") {
            sunMaterial.color = .init(tint: .white, texture: .init(texture))
        }
        let core = ModelEntity(mesh: .generateSphere(radius: radius), materials: [sunMaterial])
        core.components.set(SpinComponent(speed: 0.1))
        sun.addChild(core)

        var haloMaterial = UnlitMaterial(color: UIColor(red: 1.0, green: 0.6, blue: 0.15, alpha: 1))
        haloMaterial.blending = .transparent(opacity: .init(floatLiteral: 0.18))
        let halo = ModelEntity(mesh: .generateSphere(radius: radius * 1.35), materials: [haloMaterial])
        sun.addChild(halo)

        sun.components.set(PointLightComponent(color: .white, intensity: 12_000, attenuationRadius: 4))

        return sun
    }

    /// Anillo plano (para Saturno), ligeramente transparente.
    static func makeRing(planetRadius: Float) -> ModelEntity? {
        guard let mesh = makeAnnulusMesh(inner: planetRadius * 1.3, outer: planetRadius * 2.25) else {
            return nil
        }
        var material = UnlitMaterial(color: PlanetVisualStyle.ringColor)
        if let color = texture("saturn_ring_color.png"),
           let opacity = texture("saturn_ring_opacity.png") {
            // Franjas reales de los anillos con sus huecos transparentes
            material.color = .init(tint: .white, texture: .init(color))
            material.blending = .transparent(opacity: .init(scale: 1.0, texture: .init(opacity)))
        } else {
            material.blending = .transparent(opacity: .init(floatLiteral: 0.75))
        }
        let ring = ModelEntity(mesh: mesh, materials: [material])
        ring.name = "rings"
        return ring
    }

    /// Línea circular que dibuja la órbita de un planeta alrededor del Sol.
    static func makeOrbitPath(radius: Float) -> ModelEntity? {
        guard let mesh = makeAnnulusMesh(inner: radius - 0.0015, outer: radius + 0.0015, segments: 160) else {
            return nil
        }
        var material = UnlitMaterial(color: .white)
        material.blending = .transparent(opacity: .init(floatLiteral: 0.22))
        let path = ModelEntity(mesh: mesh, materials: [material])
        path.name = "orbit-path"
        return path
    }

    /// Genera la malla de un "anillo" (corona circular) en el plano XZ,
    /// visible por ambas caras.
    static func makeAnnulusMesh(inner: Float, outer: Float, segments: Int = 96) -> MeshResource? {
        var positions: [SIMD3<Float>] = []
        var normals: [SIMD3<Float>] = []
        var indices: [UInt32] = []
        var uvs: [SIMD2<Float>] = []

        for i in 0...segments {
            let angle = Float(i) / Float(segments) * 2 * .pi
            let c = cos(angle)
            let s = sin(angle)
            positions.append([c * inner, 0, s * inner])
            positions.append([c * outer, 0, s * outer])
            normals.append([0, 1, 0])
            normals.append([0, 1, 0])
            // u recorre el radio (interior → exterior) para la textura del anillo
            uvs.append([0, 0.5])
            uvs.append([1, 0.5])
        }

        for i in 0..<segments {
            let base = UInt32(i * 2)
            // Cara superior
            indices += [base, base + 1, base + 2, base + 1, base + 3, base + 2]
            // Cara inferior (orden inverso)
            indices += [base, base + 2, base + 1, base + 1, base + 2, base + 3]
        }

        var descriptor = MeshDescriptor(name: "annulus")
        descriptor.positions = MeshBuffers.Positions(positions)
        descriptor.normals = MeshBuffers.Normals(normals)
        descriptor.textureCoordinates = MeshBuffers.TextureCoordinates(uvs)
        descriptor.primitives = .triangles(indices)
        return try? MeshResource.generate(from: [descriptor])
    }
}
