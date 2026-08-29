import SwiftUI

/// Three brush sizes shown as growing dots - visual, no numbers or labels.
struct BrushSizePicker: View {
    static let sizes: [CGFloat] = [8, 16, 28]

    @Binding var width: CGFloat

    var body: some View {
        HStack(spacing: 14) {
            ForEach(Self.sizes, id: \.self) { size in
                Button {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    width = size
                } label: {
                    Circle()
                        .fill(Color.primary)
                        .frame(width: size, height: size)
                        .frame(width: 52, height: 52)
                        .background(
                            Circle().fill(width == size ? Color.accentColor.opacity(0.25) : Color.clear)
                        )
                }
                .accessibilityLabel(Text("Brush size \(Int(size))"))
            }
        }
    }
}
