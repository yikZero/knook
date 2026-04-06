import AppKit
import Core
import SwiftUI

@MainActor
final class OnboardingFlowWindowController {
    private var window: NSWindow?

    func show(onFinish: @escaping @MainActor (OnboardingPreset) -> Void) {
        let window = window ?? OverlayWindowHelper.makeFullscreenWindow()
        self.window = window
        let flowView = OnboardingFlowView { preset in
            onFinish(preset)
        }
        OverlayWindowHelper.presentOverlay(
            in: window,
            rootView: flowView,
            fadeDuration: 0.6,
            timingFunction: .easeIn
        )
    }

    func hide() {
        guard let window else { return }
        OverlayWindowHelper.dismissOverlay(window, fadeDuration: 0.5)
    }

    var isVisible: Bool {
        window?.isVisible == true
    }
}
