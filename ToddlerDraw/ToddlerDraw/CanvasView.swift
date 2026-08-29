import PencilKit
import SwiftUI

/// Thin wrapper around PKCanvasView tuned for a toddler drawing surface:
/// fixed page (no scroll/zoom jank), both finger and Pencil accepted, and
/// no extra view layers between the stroke and the Metal-backed canvas.
struct CanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    var tool: DrawingTool
    var onDrawingChanged: () -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onDrawingChanged: onDrawingChanged)
    }

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.delegate = context.coordinator
        canvasView.tool = tool.pkTool
        canvasView.backgroundColor = .white
        canvasView.isOpaque = true
        canvasView.drawingPolicy = .anyInput
        canvasView.isRulerActive = false

        // A fixed, non-scrolling, non-zooming page removes an entire class
        // of jank: no transform math or content-offset recalculation on
        // every touch sample, which is where the "laggy" feeling usually
        // comes from in coloring apps that allow free panning/zooming.
        canvasView.isScrollEnabled = false
        canvasView.minimumZoomScale = 1
        canvasView.maximumZoomScale = 1
        canvasView.bouncesZoom = false
        canvasView.contentInsetAdjustmentBehavior = .never

        canvasView.becomeFirstResponder()
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // Cheap in-place update - never recreates the view or its Metal layer.
        uiView.tool = tool.pkTool
    }

    final class Coordinator: NSObject, PKCanvasViewDelegate {
        let onDrawingChanged: () -> Void

        init(onDrawingChanged: @escaping () -> Void) {
            self.onDrawingChanged = onDrawingChanged
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            onDrawingChanged()
        }
    }
}
