import Foundation
import SwiftData

@MainActor
enum FavoritesStore {
    static func toggle(_ planet: Planet, favorites: [FavoritePlanet], context: ModelContext) {
        if let existing = favorites.first(where: { $0.planetID == planet.id }) {
            context.delete(existing)
        } else {
            context.insert(FavoritePlanet(planetID: planet.id))
        }
        do { try context.save() }
        catch { print("Error al guardar favoritos: \(error.localizedDescription)") }
    }
}
