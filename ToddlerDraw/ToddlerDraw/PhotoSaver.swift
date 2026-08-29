import Photos
import UIKit

enum PhotoSaver {
    /// Requests add-only Photos access (never full-library read access -
    /// nothing to configure for a toddler app beyond writing new pictures)
    /// and saves the given image.
    static func save(_ image: UIImage, completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            guard status == .authorized || status == .limited else {
                DispatchQueue.main.async { completion(false) }
                return
            }
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }, completionHandler: { success, _ in
                DispatchQueue.main.async { completion(success) }
            })
        }
    }
}
