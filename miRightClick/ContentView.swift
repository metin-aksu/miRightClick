//
//  ContentView.swift
//  miRightClick
//
//  Created by Metin AKSU on 30.06.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            header

            Divider()

            VStack(alignment: .leading, spacing: 16) {
                StepRow(number: 1,
                        title: "Enable the Finder extension",
                        detail: "Open System Settings → General → Login Items & Extensions, find Finder extensions, and turn on miRightClick.")
                StepRow(number: 2,
                        title: "Restart Finder",
                        detail: "Finder caches extensions, so it needs a relaunch the first time.")
                StepRow(number: 3,
                        title: "Right-click empty space in a folder",
                        detail: "Inside your home folder (or any subfolder), right-click the empty background and choose “New Text File”.")
            }

            Divider()

            Button {
                openExtensionSettings()
            } label: {
                Label("Open Extension Settings", systemImage: "gearshape")
            }
            .controlSize(.large)

            VStack(alignment: .leading, spacing: 4) {
                Text("Tip: to restart Finder, run this in Terminal:")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Text("killall Finder")
                    .font(.footnote.monospaced())
                    .textSelection(.enabled)
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(RoundedRectangle(cornerRadius: 6).fill(.quaternary))
                Text("The “New Text File” item only appears inside your home folder and its subfolders.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)

                Link("https://github.com/metin-aksu/miRightClick",
                     destination: URL(string: "https://github.com/metin-aksu/miRightClick")!)
                    .font(.callout)
                    .padding(.top, 12)
            }
        }
        .padding(28)
        .frame(width: 520)
    }

    private var header: some View {
        HStack(spacing: 14) {
            Image(systemName: "doc.badge.plus")
                .font(.system(size: 40))
                .foregroundStyle(.tint)
            VStack(alignment: .leading, spacing: 2) {
                Text("miRightClick")
                    .font(.largeTitle.bold())
                Text("Adds “New Text File” to Finder’s right-click menu.")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func openExtensionSettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.ExtensionsPreferences") {
            NSWorkspace.shared.open(url)
        }
    }
}

private struct StepRow: View {
    let number: Int
    let title: String
    let detail: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.headline)
                .frame(width: 26, height: 26)
                .background(Circle().fill(.tint.opacity(0.15)))
                .overlay(Circle().stroke(.tint, lineWidth: 1))

            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.headline)
                Text(detail)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

#Preview {
    ContentView()
}
