//
//  TextFileFinderSync.swift
//  FinderExtension
//
//  Finder Sync extension that adds a "New Text File" item to the contextual
//  menu shown when right-clicking the empty background of a folder.
//

import Cocoa
import FinderSync
import os.log

private let log = Logger(subsystem: "com.metinaksu.miRightClick.FinderExtension", category: "extension")

class TextFileFinderSync: FIFinderSync {

    override init() {
        super.init()

        // The contextual menu only appears inside monitored directories. We
        // monitor the whole filesystem root ("/") so the item shows up in every
        // folder. (Monitoring a large subtree such as the home directory proved
        // unreliable — Finder only queried some folders.) Write access to the
        // targeted folder is granted by the temporary-exception entitlements in
        // FinderExtension.entitlements.
        //
        // Known macOS limitation: Finder never routes container contextual menus
        // for the Desktop and Documents folders to *any* third-party Finder Sync
        // extension (verified against other shipping extensions), so the item
        // cannot appear there. Every other folder works.
        FIFinderSyncController.default().directoryURLs = [URL(fileURLWithPath: "/")]
    }

    // MARK: - Menu

    override func menu(for menuKind: FIMenuKind) -> NSMenu? {
        // Only handle a right-click on the empty background of a folder.
        guard menuKind == .contextualMenuForContainer else { return nil }

        let menu = NSMenu(title: "")
        // Localized so the item matches the user's macOS language (e.g. "Yeni
        // Metin Dosyası" in Turkish). Translations live in Localizable.xcstrings.
        let title = NSLocalizedString("New Text File",
                                      comment: "Finder context-menu item that creates a new empty text file")
        let item = NSMenuItem(title: title,
                              action: #selector(newTextFile(_:)),
                              keyEquivalent: "")
        // Do NOT set item.target. Finder shows this menu in its own process and
        // routes the click back to this FIFinderSync object via the responder
        // chain; pinning an explicit target breaks that cross-process dispatch.
        item.image = menuIcon()
        menu.addItem(item)
        return menu
    }

    /// The menu item icon, coloured for the current appearance.
    ///
    /// Finder renders this extension's contextual menu without tinting our image,
    /// and the extension process itself always runs in the Light appearance — so
    /// neither `isTemplate` nor an appearance-aware `NSImage` turns white in Dark
    /// mode. Instead we read the system-wide setting fresh on every right-click
    /// (menus are rebuilt each time) and bake the glyph in the matching colour:
    /// white in Dark mode, black in Light mode.
    private func menuIcon() -> NSImage? {
        let color: NSColor = Self.systemIsInDarkMode ? .white : .black
        let config = NSImage.SymbolConfiguration(pointSize: 15, weight: .regular)
        guard let symbol = NSImage(systemSymbolName: "doc.text", accessibilityDescription: nil)?
            .withSymbolConfiguration(config) else { return nil }
        let size = symbol.size
        let image = NSImage(size: size)
        image.lockFocus()
        symbol.draw(in: NSRect(origin: .zero, size: size))
        color.set()
        NSRect(origin: .zero, size: size).fill(using: .sourceAtop)
        image.unlockFocus()
        image.isTemplate = false
        return image
    }

    /// Reads the current user's global "AppleInterfaceStyle" fresh (so it reflects
    /// a live Light/Dark toggle even in this long-lived extension process).
    private static var systemIsInDarkMode: Bool {
        let value = CFPreferencesCopyValue("AppleInterfaceStyle" as CFString,
                                           kCFPreferencesAnyApplication,
                                           kCFPreferencesCurrentUser,
                                           kCFPreferencesAnyHost) as? String
        return value?.lowercased() == "dark"
    }

    // MARK: - Action

    @objc func newTextFile(_ sender: AnyObject?) {
        // The folder whose background was right-clicked.
        guard let targetURL = FIFinderSyncController.default().targetedURL() else {
            log.error("newTextFile: targetedURL() was nil")
            return
        }

        let destination = uniqueDestination(in: targetURL, baseName: "untitled", ext: "txt")
        do {
            try Data().write(to: destination, options: .withoutOverwriting)
        } catch {
            log.error("newTextFile: could not create \(destination.path, privacy: .public): \(error as NSError, privacy: .public)")
        }
    }

    // MARK: - Helpers

    /// Returns a non-colliding URL inside `directory`:
    /// `untitled.txt`, then `untitled 2.txt`, `untitled 3.txt`, … (never overwrites).
    private func uniqueDestination(in directory: URL, baseName: String, ext: String) -> URL {
        let fileManager = FileManager.default
        var candidate = directory.appendingPathComponent("\(baseName).\(ext)")
        var index = 2
        while fileManager.fileExists(atPath: candidate.path) {
            candidate = directory.appendingPathComponent("\(baseName) \(index).\(ext)")
            index += 1
        }
        return candidate
    }
}
