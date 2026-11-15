import Foundation

/// Fuente de datos local de los ocho planetas.
/// Valores aproximados con fines divulgativos (NASA Solar System Exploration).
/// El número de lunas cambia con frecuencia por nuevos descubrimientos;
/// las cifras corresponden a abril de 2026.
enum PlanetDataService {

    static let planets: [Planet] = [
        Planet(
            id: "mercury", order: 1, name: "Mercurio",
            subtitle: "El más cercano al Sol",
            description: "Un planeta rocoso con una superficie cubierta de cráteres y una atmósfera extremadamente tenue.",
            diameter: "4,879 km", diameterKm: 4_879,
            distance: "57.9 millones km",
            temperature: "167 °C (media global aproximada)",
            composition: "Rocas silicatadas y núcleo metálico",
            dayLength: "59 días terrestres", yearLength: "88 días",
            moons: 0,
            fact: "Un día solar (de amanecer a amanecer) dura alrededor de 176 días terrestres.",
            radius: 0.08, orbitRadius: 0.32, orbitSpeed: 0.55, spinSpeed: 0.25, axialTilt: 0.03, hasRings: false
        ),
        Planet(
            id: "venus", order: 2, name: "Venus",
            subtitle: "El planeta más caliente",
            description: "Su atmósfera densa de dióxido de carbono produce un potente efecto invernadero.",
            diameter: "12,104 km", diameterKm: 12_104,
            distance: "108.2 millones km",
            temperature: "464 °C (superficie media)",
            composition: "Planeta rocoso; atmósfera rica en CO₂",
            dayLength: "243 días terrestres", yearLength: "225 días",
            moons: 0,
            fact: "Gira sobre su eje en sentido contrario al de la mayoría de planetas, y su día es más largo que su año.",
            radius: 0.12, orbitRadius: 0.44, orbitSpeed: 0.42, spinSpeed: -0.15, axialTilt: 2.6, hasRings: false
        ),
        Planet(
            id: "earth", order: 3, name: "Tierra",
            subtitle: "Nuestro hogar",
            description: "El único planeta conocido que alberga vida, con abundante agua líquida en la superficie.",
            diameter: "12,742 km", diameterKm: 12_742,
            distance: "149.6 millones km",
            temperature: "15 °C (media superficial aproximada)",
            composition: "Rocas y metales; atmósfera de nitrógeno y oxígeno",
            dayLength: "24 horas", yearLength: "365.25 días",
            moons: 1,
            fact: "Alrededor del 71 % de su superficie está cubierta de agua.",
            radius: 0.13, orbitRadius: 0.57, orbitSpeed: 0.35, spinSpeed: 1.0, axialTilt: 23.4, hasRings: false
        ),
        Planet(
            id: "mars", order: 4, name: "Marte",
            subtitle: "El planeta rojo",
            description: "Un mundo rocoso y frío con volcanes gigantes, cañones y huellas de agua antigua.",
            diameter: "6,779 km", diameterKm: 6_779,
            distance: "227.9 millones km",
            temperature: "−65 °C (media superficial aproximada)",
            composition: "Rocas, óxidos de hierro y atmósfera tenue de CO₂",
            dayLength: "24 h 37 min", yearLength: "687 días",
            moons: 2,
            fact: "Olympus Mons es uno de los volcanes más grandes del sistema solar: casi tres veces la altura del Everest.",
            radius: 0.10, orbitRadius: 0.70, orbitSpeed: 0.28, spinSpeed: 0.95, axialTilt: 25.2, hasRings: false
        ),
        Planet(
            id: "jupiter", order: 5, name: "Júpiter",
            subtitle: "El gigante gaseoso",
            description: "El planeta más grande, con nubes turbulentas y una inmensa tormenta llamada la Gran Mancha Roja.",
            diameter: "139,820 km", diameterKm: 139_820,
            distance: "778.6 millones km",
            temperature: "−110 °C (aprox. a nivel de nubes)",
            composition: "Principalmente hidrógeno y helio",
            dayLength: "≈ 10 horas", yearLength: "11.9 años",
            moons: 115,
            fact: "Su Gran Mancha Roja es una tormenta más grande que la Tierra que lleva siglos activa.",
            radius: 0.25, orbitRadius: 0.92, orbitSpeed: 0.15, spinSpeed: 2.2, axialTilt: 3.1, hasRings: false
        ),
        Planet(
            id: "saturn", order: 6, name: "Saturno",
            subtitle: "El planeta de los anillos",
            description: "Un gigante gaseoso famoso por su extenso sistema de anillos compuestos principalmente de hielo.",
            diameter: "116,460 km", diameterKm: 116_460,
            distance: "1,433.5 millones km",
            temperature: "−140 °C (aprox. a nivel de nubes)",
            composition: "Principalmente hidrógeno y helio",
            dayLength: "≈ 10.7 horas", yearLength: "29.5 años",
            moons: 292,
            fact: "Es tan poco denso que, en teoría, flotaría en una bañera gigante llena de agua.",
            radius: 0.22, orbitRadius: 1.18, orbitSpeed: 0.11, spinSpeed: 2.0, axialTilt: 26.7, hasRings: true
        ),
        Planet(
            id: "uranus", order: 7, name: "Urano",
            subtitle: "El gigante inclinado",
            description: "Un gigante helado cuyo eje de rotación está casi acostado respecto a su órbita.",
            diameter: "50,724 km", diameterKm: 50_724,
            distance: "2,872.5 millones km",
            temperature: "−195 °C (aprox. a nivel de nubes)",
            composition: "Hidrógeno, helio y componentes volátiles",
            dayLength: "≈ 17 horas", yearLength: "84 años",
            moons: 29,
            fact: "Su inclinación axial es de aproximadamente 98 grados: gira como una pelota rodando.",
            radius: 0.17, orbitRadius: 1.40, orbitSpeed: 0.08, spinSpeed: -1.4, axialTilt: 97.8, hasRings: false
        ),
        Planet(
            id: "neptune", order: 8, name: "Neptuno",
            subtitle: "El más distante",
            description: "Un gigante helado azul con vientos muy intensos en su atmósfera.",
            diameter: "49,244 km", diameterKm: 49_244,
            distance: "4,495.1 millones km",
            temperature: "−200 °C (aprox. a nivel de nubes)",
            composition: "Hidrógeno, helio y componentes volátiles",
            dayLength: "≈ 16 horas", yearLength: "165 años",
            moons: 16,
            fact: "Presenta los vientos más rápidos medidos en un planeta: más de 2,000 km/h.",
            radius: 0.17, orbitRadius: 1.58, orbitSpeed: 0.06, spinSpeed: 1.5, axialTilt: 28.3, hasRings: false
        )
    ]

    static func planet(id: String) -> Planet? {
        planets.first { $0.id == id }
    }
}
