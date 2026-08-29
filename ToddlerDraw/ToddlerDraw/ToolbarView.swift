import SwiftUI

/// Undo / redo / clear / save, as large icon-only buttons.
struct ToolbarView: View {
    var canUndo: Bool
    var canRedo: Bool
    var onUndo: () -> Void
    var onRedo: () -> Void
    var onClear: () -> Void
    var onSave: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            toolButton(system: "arrow.uturn.backward.circle.fill", enabled: canUndo, action: onUndo)
            toolButton(system: "arrow.uturn.forward.circle.fill", enabled: canRedo, action: onRedo)
            toolButton(system: "trash.circle.fill", enabled: true, action: onClear)
            toolButton(system: "square.and.arrow.down.circle.fill", enabled: true, action: onSave)
        }
    }

    private func toolButton(system: String, enabled: Bool, action: @escaping () -> Void) -> some View {
        Button {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            action()
        } label: {
            Image(systemName: system)
                .font(.system(size: 40))
                .symbolRenderingMode(.hierarchical)
        }
        .disabled(!enabled)
        .opacity(enabled ? 1 : 0.35)
        .frame(width: 52, height: 52)
    }
}
