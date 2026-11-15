import SwiftUI

struct HomeView: View {

    @Environment(AppState.self) private var appState
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    @State private var selection = NavigationSection.explore

    enum NavigationSection: String, CaseIterable, Identifiable {
        case explore = "Planetas"
        case compare = "Comparar"
        case favorites = "Favoritos"
        case quiz = "Cuestionario"
        case about = "Acerca de"

        var id: String { rawValue }

        var symbol: String {
            switch self {
            case .explore:
                return "globe.americas.fill"
            case .compare:
                return "circle.lefthalf.filled"
            case .favorites:
                return "star.fill"
            case .quiz:
                return "checkmark.circle.fill"
            case .about:
                return "info.circle.fill"
            }
        }
    }

    var body: some View {
        NavigationSplitView {

            VStack(alignment: .leading, spacing: 18) {

                Label("CosmoVision", systemImage: "sparkles")
                    .font(.title2.bold())
                    .foregroundStyle(.cyan)
                    .padding(.horizontal, 14)

                List {
                    ForEach(NavigationSection.allCases) { section in
                        Button {
                            selection = section
                        } label: {
                            Label(section.rawValue, systemImage: section.symbol)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 8)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .listRowBackground(
                            selection == section
                            ? Color.cyan.opacity(0.18)
                            : Color.clear
                        )
                    }
                }
                .listStyle(.sidebar)

                Spacer()

                Text("Explora. Descubre. Aprende.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding()
            }
            .padding(.top)
            .navigationSplitViewColumnWidth(min: 210, ideal: 240)

        } detail: {

            NavigationStack {

                Group {
                    switch selection {
                    case .explore:
                        PlanetCatalogView()

                    case .compare:
                        CompareView()

                    case .favorites:
                        FavoritesView()

                    case .quiz:
                        QuizView()

                    case .about:
                        AboutView()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {

                        Button {
                            Task {
                                await toggleImmersiveSpace()
                            }
                        } label: {
                            Label(
                                appState.isImmersiveOpen
                                ? "Salir de inmersión"
                                : "Exploración inmersiva",
                                systemImage: appState.isImmersiveOpen
                                ? "rectangle.portrait.and.arrow.right"
                                : "visionpro"
                            )
                        }
                        .disabled(appState.isImmersiveTransitioning)
                    }
                }
            }
            // Reinicia la navegación al cambiar de sección
            .id(selection)
        }
    }

    private func toggleImmersiveSpace() async {

        guard !appState.isImmersiveTransitioning else {
            return
        }

        appState.isImmersiveTransitioning = true

        defer {
            appState.isImmersiveTransitioning = false
        }

        if appState.isImmersiveOpen {

            await dismissImmersiveSpace()
            appState.isImmersiveOpen = false

        } else {

            let result = await openImmersiveSpace(
                id: SolarSystemImmersiveView.spaceID
            )

            switch result {
            case .opened:
                appState.isImmersiveOpen = true

            case .userCancelled, .error:
                appState.isImmersiveOpen = false

            @unknown default:
                appState.isImmersiveOpen = false
            }
        }
    }
}
