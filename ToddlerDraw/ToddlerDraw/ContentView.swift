import PencilKit
import SwiftUI

struct ContentView: View {
    @State private var canvasView = PKCanvasView()
    @State private var tool = DrawingTool()
    @State private var canUndo = false
    @State private var canRedo = false
    @State private var showSavedBanner = false

    var body: some View {
        ZStack(alignment: .top) {
            Color.white.ignoresSafeArea()

            CanvasView(canvasView: $canvasView, tool: tool, onDrawingChanged: updateUndoRedoState)
                .ignoresSafeArea()

            controls
                .padding(20)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                .padding([.horizontal, .top], 16)

            if showSavedBanner {
                savedBanner
            }
        }
        .persistentSystemOverlays(.hidden)
    }

    private var controls: some View {
        HStack(alignment: .center, spacing: 24) {
            ColorPaletteView(selectedColor: Binding(
                get: { tool.color },
                set: { tool.color = $0 }
            ))

            Divider().frame(height: 44)

            BrushSizePicker(width: Binding(
                get: { tool.width },
                set: { tool.width = $0 }
            ))

            Spacer(minLength: 0)

            ToolbarView(
                canUndo: canUndo,
                canRedo: canRedo,
                onUndo: { canvasView.undoManager?.undo() },
                onRedo: { canvasView.undoManager?.redo() },
                onClear: clearCanvas,
                onSave: saveDrawing
            )
        }
    }

    private var savedBanner: some View {
        VStack {
            Spacer()
            Text("Saved to Photos! 🎨")
                .font(.title2.bold())
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
                .background(.thinMaterial, in: Capsule())
                .padding(.bottom, 48)
        }
        .transition(.opacity)
        .allowsHitTesting(false)
    }

    private func updateUndoRedoState() {
        canUndo = canvasView.undoManager?.canUndo ?? false
        canRedo = canvasView.undoManager?.canRedo ?? false
    }

    private func clearCanvas() {
        canvasView.drawing = PKDrawing()
        updateUndoRedoState()
    }

    private func saveDrawing() {
        let bounds = canvasView.bounds
        guard bounds.width > 0, bounds.height > 0 else { return }

        let strokesImage = canvasView.drawing.image(from: bounds, scale: UIScreen.main.scale)
        let flattened = UIGraphicsImageRenderer(size: bounds.size).image { _ in
            UIColor.white.setFill()
            UIRectFill(CGRect(origin: .zero, size: bounds.size))
            strokesImage.draw(in: CGRect(origin: .zero, size: bounds.size))
        }

        PhotoSaver.save(flattened) { success in
            guard success else { return }
            withAnimation { showSavedBanner = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                withAnimation { showSavedBanner = false }
            }
        }
    }
}

#Preview {
    ContentView()
}
