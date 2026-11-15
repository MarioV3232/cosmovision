import Foundation
import SwiftData

@Model
final class FavoritePlanet {
    @Attribute(.unique) var planetID: String
    var createdAt: Date
    init(planetID: String) {
        self.planetID = planetID
        self.createdAt = Date()
    }
}
