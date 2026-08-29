import SwiftUI

/// Big, bright, thumb-proof color swatches. No labels, no menus - a
/// toddler just taps the circle they want.
struct ColorPaletteView: View {
    static let colors: [PaletteColor] = [
        PaletteColor(name: "Red", color: .systemRed),
        PaletteColor(name: "Orange", color: .systemOrange),
        PaletteColor(name: "Yellow", color: .systemYellow),
        PaletteColor(name: "Green", color: .systemGreen),
        PaletteColor(name: "Teal", color: .systemTeal),
        PaletteColor(name: "Blue", color: .systemBlue),
        PaletteColor(name: "Purple", color: .systemPurple),
        PaletteColor(name: "Pink", color: .systemPink),
        PaletteColor(name: "Brown", color: .systemBrown),
        PaletteColor(name: "Black", color: .black),
    ]

    @Binding var selectedColor: UIColor

    var body: some View {
        HStack(spacing: 12) {
            ForEach(Self.colors) { swatch in
                swatchButton(for: swatch)
            }
        }
    }

    private func swatchButton(for swatch: PaletteColor) -> some View {
        let isSelected = selectedColor == swatch.color
        return Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            selectedColor = swatch.color
        } label: {
            Circle()
                .fill(Color(swatch.color))
                .frame(width: 52, height: 52)
                .overlay(
                    Circle().stroke(Color.white, lineWidth: isSelected ? 4 : 0)
                )
                .overlay(
                    Circle().stroke(Color.black.opacity(0.15), lineWidth: 1)
                )
                .scaleEffect(isSelected ? 1.18 : 1.0)
                .shadow(color: .black.opacity(isSelected ? 0.25 : 0), radius: 4, y: 2)
        }
        .animation(.spring(response: 0.25, dampingFraction: 0.6), value: isSelected)
        .accessibilityLabel(Text(swatch.name))
    }
}
