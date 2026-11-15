import SwiftUI
import UIKit

/// Colores y símbolos usados para representar cada planeta
/// tanto en SwiftUI (tarjetas) como en RealityKit (esferas 3D).
enum PlanetVisualStyle {

    static func color(for id: String) -> UIColor {
        switch id {
        case "mercury": return UIColor(red: 0.62, green: 0.60, blue: 0.58, alpha: 1)
        case "venus":   return UIColor(red: 0.91, green: 0.72, blue: 0.42, alpha: 1)
        case "earth":   return UIColor(red: 0.20, green: 0.48, blue: 0.86, alpha: 1)
        case "mars":    return UIColor(red: 0.80, green: 0.33, blue: 0.20, alpha: 1)
        case "jupiter": return UIColor(red: 0.80, green: 0.62, blue: 0.45, alpha: 1)
        case "saturn":  return UIColor(red: 0.90, green: 0.80, blue: 0.55, alpha: 1)
        case "uranus":  return UIColor(red: 0.55, green: 0.85, blue: 0.90, alpha: 1)
        case "neptune": return UIColor(red: 0.25, green: 0.40, blue: 0.90, alpha: 1)
        default:        return .white
        }
    }

    static var ringColor: UIColor { UIColor(red: 0.86, green: 0.78, blue: 0.62, alpha: 1) }
    static var sunColor: UIColor { UIColor(red: 1.0, green: 0.78, blue: 0.30, alpha: 1) }

    static func swiftUIColor(for id: String) -> Color {
        Color(uiColor: color(for: id))
    }

    static func symbol(for id: String) -> String {
        switch id {
        case "earth": return "globe.americas.fill"
        case "saturn": return "circle.circle"
        default: return "circle.fill"
        }
    }
}
