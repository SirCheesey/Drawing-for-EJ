# Toddler Draw

A native iPadOS drawing app for toddlers, built with SwiftUI + PencilKit.
MVP scope: a single full-screen free-draw canvas with a big color palette,
three brush sizes, undo/redo, clear, and save-to-Photos. No coloring-book
pages or menus (yet) - just a fast, obvious canvas.

## Why this should feel smoother than the reference app

- **PencilKit, not a custom canvas.** `PKCanvasView` is the same
  Metal-backed, prediction-driven drawing engine used by Apple Notes and
  Freeform. It handles Apple Pencil input, coalesced/predicted touches,
  and ProMotion refresh rates natively - there's no way to hand-roll a
  faster touch-to-ink path on iPadOS.
- **No pan/zoom on the canvas.** `isScrollEnabled`, zoom scale, and
  bounce are all locked off (`CanvasView.swift`). Free panning/zooming is
  the single most common source of perceived lag in coloring apps because
  every touch sample has to go through content-offset/transform math.
  Toddlers don't need to zoom; a fixed page keeps the hot path cheap.
  - **Cheap tool updates.** Changing color/size just sets
  `PKCanvasView.tool` in `updateUIView` - it never rebuilds the view or
  its Metal layer, so switching colors mid-stroke session stays instant.
- **No effects layered over the live drawing area.** The toolbar's blur
  material sits in its own view at the top of the screen, not on top of
  the canvas, so the compositor isn't blending extra layers over every
  pencil stroke.
- **Full-screen only.** `UIRequiresFullScreen` opts out of iPadOS
  Split View / Slide Over, avoiding the extra resize/compositing
  overhead (and accidental app-switching) multitasking introduces.

## Toddler / Guided Access friendliness

- `UIRequiresFullScreen` - no Split View, Slide Over, or drag-to-multitask.
- Status bar and the home indicator are both hidden
  (`statusBarHidden` + `.persistentSystemOverlays(.hidden)`), so there's
  nothing inviting a swipe from the edges.
- The app itself adds no multi-finger or edge-swipe gestures.
- iPadOS system gestures (home swipe, Control Center, App Switcher) can
  only be fully blocked by **Guided Access**, not by an app. For a truly
  locked-down session, triple-click the top button to start Guided
  Access before handing over the iPad.
- Photos access is requested as **add-only** (`PHAccessLevel.addOnly`),
  so the app can never read the rest of your camera roll - only add new
  drawings to it.

## Project layout

```
ToddlerDraw/
  project.yml              # XcodeGen project definition
  ToddlerDraw/
    ToddlerDrawApp.swift    # App entry point
    ContentView.swift       # Screen layout: canvas + toolbar
    CanvasView.swift        # UIViewRepresentable wrapping PKCanvasView
    DrawingTool.swift       # Current color/width -> PKTool
    ColorPaletteView.swift  # Big color swatches
    BrushSizePicker.swift   # Three brush sizes
    ToolbarView.swift       # Undo / redo / clear / save buttons
    PhotoSaver.swift        # Save-to-Photos helper
    Assets.xcassets/        # App icon slot + accent color
```

## Building it

This was authored outside of Xcode, so the `.xcodeproj` is generated from
`project.yml` with [XcodeGen](https://github.com/yonaskolb/XcodeGen)
rather than hand-edited/committed as a binary plist. On a Mac:

```sh
brew install xcodegen
cd ToddlerDraw
xcodegen generate
open ToddlerDraw.xcodeproj
```

Then in Xcode:

1. Select the `ToddlerDraw` target -> **Signing & Capabilities** -> pick
   your personal team (a free Apple ID account works for running on your
   own iPad).
2. Plug in an iPad (iPadOS 17+) and select it as the run destination -
   PencilKit's Pencil input isn't meaningfully testable in the Simulator.
3. Run. Draw with your finger or an Apple Pencil, tap a color, pick a
   brush size, and try Undo/Clear/Save.

## Possible next steps

- A tap-to-fill coloring-book mode with simple line-art pages (this was
  scoped out of the MVP to ship the free-draw canvas first).
- Sticker/stamp tool for younger toddlers who aren't drawing shapes yet.
- A parent gate (press-and-hold or a simple pattern) before any future
  settings screen.
- Multiple saved pages / a gallery of past drawings.
