//
//  miRightClickApp.swift
//  miRightClick
//
//  Created by Metin AKSU on 30.06.2026.
//

import SwiftUI
import AppKit

@main
struct miRightClickApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            // Replace the default "About miRightClick" so the panel shows the
            // author and project link under the app name and version.
            CommandGroup(replacing: .appInfo) {
                Button("About miRightClick") {
                    showAboutPanel()
                }
            }
        }
    }
}

private func showAboutPanel() {
    // Author line: centered, with extra space below it so the link isn't cramped.
    let authorParagraph = NSMutableParagraphStyle()
    authorParagraph.alignment = .center
    authorParagraph.paragraphSpacing = 10

    let authorAttributes: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: 13),
        .paragraphStyle: authorParagraph,
        .foregroundColor: NSColor.labelColor
    ]

    let linkParagraph = NSMutableParagraphStyle()
    linkParagraph.alignment = .center

    let urlString = "https://github.com/metin-aksu/miRightClick"
    let linkAttributes: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: 13),
        .paragraphStyle: linkParagraph,
        .foregroundColor: NSColor.labelColor,
        .link: URL(string: urlString) as Any
    ]

    let credits = NSMutableAttributedString(string: "Author: Metin AKSU\n", attributes: authorAttributes)
    credits.append(NSAttributedString(string: urlString, attributes: linkAttributes))

    NSApplication.shared.orderFrontStandardAboutPanel(options: [.credits: credits])
}
