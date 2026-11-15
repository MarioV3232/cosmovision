# CosmoVision 🪐

**Tu ventana educativa al sistema solar en Apple Vision Pro.**

Proyecto académico de la materia ETPS4 (UTEC). Tema: **Apple Vision Pro / visionOS**.

CosmoVision es una app para visionOS hecha con SwiftUI, RealityKit y SwiftData. Permite explorar los ocho planetas con información científica, modelos 3D interactivos, un volumen que flota en tu espacio y una experiencia inmersiva con el sistema solar animado a tu alrededor.

---

## Funcionalidades

| Sección | Qué hace | Tecnología de visionOS |
|---|---|---|
| **Planetas** | Catálogo con búsqueda y filtro (Todos / Rocosos / Gigantes) | `NavigationSplitView`, `searchable`, `hoverEffect` |
| **Detalle del planeta** | Ficha con 8 datos, planeta 3D que gira solo y se rota arrastrando con la mano, control de tamaño | `RealityView`, `DragGesture().targetedToAnyEntity()` |
| **Ver en volumen 3D** | Abre el planeta en una ventana volumétrica que se puede ver desde cualquier ángulo | `WindowGroup` + `.windowStyle(.volumetric)` + `openWindow` |
| **Exploración inmersiva** | Sol con luz propia, 8 planetas orbitando con inclinación axial real, anillos de Saturno, trayectorias, etiquetas y panel de control (pausar, velocidad, mostrar/ocultar). Tocar un planeta lo selecciona | `ImmersiveSpace`, attachments, `BillboardComponent`, `PointLightComponent` |
| **Comparar** | Compara dos planetas a escala real de diámetro y calcula cuántos cabrían dentro del otro | SwiftUI `Grid`, animaciones |
| **Favoritos** | Guarda planetas favoritos de forma persistente | **SwiftData** (`@Model`, `@Query`) |
| **Cuestionario** | 12 preguntas en orden aleatorio, retroalimentación y mejor puntaje guardado | MVVM con `@Observable`, `UserDefaults` |
| **Acerca de** | Tecnologías usadas y notas sobre los datos | — |

### Animación con ECS de RealityKit
Las órbitas y rotaciones se animan con un **sistema propio de RealityKit** (`CelestialMotionSystem`) y dos componentes:
- `SpinComponent`: rotación del planeta sobre su eje (Venus y Urano giran en sentido retrógrado).
- `OrbitComponent`: traslación alrededor del Sol, con pausa y multiplicador de velocidad.

Todos los modelos 3D (planetas, Sol, anillos y órbitas) se generan por código, sin archivos `.usdz` externos. Cada esfera usa una **textura real** del planeta (mapa equirectangular) aplicada con `PhysicallyBasedMaterial`.

---

## Requisitos

- **Mac con Apple silicon (M1 o superior)**. El simulador de visionOS **no funciona** en Mac con Intel ni en máquinas virtuales sobre Intel.
- **Xcode 16 o superior** con la plataforma **visionOS** instalada (Xcode → Settings → Components → visionOS).
- visionOS 2.0 o superior (simulador o Apple Vision Pro).

## Cómo ejecutarlo

1. Abre `CosmoVision.xcodeproj`.
2. En **Signing & Capabilities** selecciona tu equipo (Team). Si lo deseas, cambia el Bundle Identifier `com.fernandoperez.CosmoVision`.
3. Elige como destino **Apple Vision Pro (Simulator)**.
4. Presiona **⌘R**.

### Controles en el simulador
- **Clic** = tocar (pellizco).
- **Clic y arrastrar** sobre un planeta = rotarlo.
- **Opción + arrastrar** = mirar alrededor. **W A S D** = moverse por la sala.
- Para la experiencia inmersiva, presiona **Exploración inmersiva** en la barra superior y gira la vista: el sistema solar aparece frente a ti, a unos 2 metros.

---

## Estructura del proyecto

```
CosmoVision/
├── App/            CosmoVisionApp (escenas: ventana, volumen, espacio inmersivo), AppState
├── Models/         Planet, QuizQuestion, FavoritePlanet (SwiftData)
├── ViewModels/     QuizViewModel
├── Services/       PlanetDataService, QuizDataService, PlanetEntityFactory (RealityKit)
├── Persistence/    FavoritesStore
├── Resources/    Textures (mapas de superficie de cada planeta y anillos)
├── Utilities/      CelestialMotion (componentes + sistema ECS), PlanetVisualStyle
├── Views/
│   ├── Home/       HomeView (barra lateral), AboutView
│   ├── Planets/    Catálogo, Detalle, Planet3DView, PlanetVolumeView
│   ├── Immersive/  SolarSystemImmersiveView + panel de control
│   ├── Compare/    CompareView
│   ├── Favorites/  FavoritesView
│   ├── Quiz/       QuizView
│   └── Components/ PlanetCard
└── Assets.xcassets (ícono de visionOS en 3 capas y color de acento)
```

**Arquitectura:** MVVM con `@Observable`. El estado global (`AppState`) se comparte entre la ventana principal y el espacio inmersivo mediante `.environment`.

---

## Sobre los datos

- Fuente: [NASA Solar System Exploration](https://science.nasa.gov/solar-system/planets/).
- Texturas de los planetas, el Sol y los anillos de Saturno: [Solar System Scope](https://www.solarsystemscope.com/textures/), licencia **CC BY 4.0** (basadas en datos de la NASA). Están en `Resources/Textures`; las miniaturas de las tarjetas (`thumb_*` en Assets) se generaron a partir de ellas.
- Diámetros, distancias, temperaturas y periodos son aproximados.
- El número de lunas corresponde a abril de 2026 (Júpiter 115, Saturno 292, Urano 29, Neptuno 16) y cambia seguido por nuevos descubrimientos.
- Los tamaños 3D y las distancias orbitales de la experiencia inmersiva son **didácticos**, no a escala. El comparador sí respeta la proporción real de diámetros.

---

**Autor:** Fernando Miguel Pérez Casco · Ingeniería en Sistemas y Computación · UTEC
