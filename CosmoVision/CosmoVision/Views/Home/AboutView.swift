import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Label("CosmoVision", systemImage: "sparkles").font(.largeTitle.bold())
                Text("Tu ventana educativa al sistema solar").font(.title2).foregroundStyle(.secondary)
                Text("Explora los ocho planetas mediante información científica, modelos tridimensionales, un volumen 3D, un comparador de tamaños, una experiencia inmersiva con órbitas animadas y un cuestionario interactivo.")
                GroupBox("Tecnologías") {
                    VStack(alignment: .leading, spacing: 10) {
                        Label("Swift y SwiftUI para la interfaz", systemImage: "swift")
                        Label("RealityKit para los planetas tridimensionales", systemImage: "cube.transparent")
                        Label("Componentes y sistemas de RealityKit (ECS) para animar órbitas y rotaciones", systemImage: "gearshape.2")
                        Label("Ventana volumétrica para ver cada planeta en 3D", systemImage: "cube")
                        Label("ImmersiveSpace para el sistema solar a tu alrededor", systemImage: "visionpro")
                        Label("SwiftData para favoritos locales", systemImage: "externaldrive")
                        Label("Arquitectura MVVM con @Observable", systemImage: "square.stack.3d.up")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading).padding(10)
                }
                GroupBox("Sobre los datos") {
                    Text("Diámetros, distancias y temperaturas son valores aproximados. Las temperaturas de gigantes gaseosos y helados se refieren a capas atmosféricas, no a una superficie sólida. Los tamaños de las esferas 3D y las distancias de las órbitas son didácticos, no están a escala astronómica (el comparador sí respeta la proporción de diámetros). El número de lunas corresponde a abril de 2026 y cambia con nuevos descubrimientos.")
                        .frame(maxWidth: .infinity, alignment: .leading).padding(10)
                }
                Link("Datos planetarios: NASA Solar System Exploration", destination: URL(string: "https://science.nasa.gov/solar-system/planets/")!)
                Link("Texturas de planetas: Solar System Scope (CC BY 4.0)", destination: URL(string: "https://www.solarsystemscope.com/textures/")!)
                Text("Proyecto académico ETPS4 · Apple Vision Pro · visionOS").font(.caption).foregroundStyle(.secondary)
            }
            .padding(34)
            .frame(maxWidth: 850, alignment: .leading)
        }
        .navigationTitle("Acerca de")
    }
}
