import PencilKit
import UIKit

/// A palette color paired with a friendly name for accessibility.
struct PaletteColor: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let color: UIColor
}

/// Current drawing tool state, translated into a PencilKit tool on demand.
struct DrawingTool: Equatable {
    var color: UIColor = .systemRed
    var width: CGFloat = 14

    /// Always a marker: a single, forgiving ink type keeps the toolbar tiny
    /// (no mode-switcher a toddler could get stuck on) while staying opaque
    /// and consistent at every brush size.
    var pkTool: PKTool {
        PKInkingTool(.marker, color: color, width: width)
    }
}
