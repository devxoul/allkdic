import SwiftUI

struct AboutView: View {
  private var credits: [(String, String)] {
    [
      (gettext("credit_developed_by"), gettext("전수열")),
      (gettext("credit_named_by"), gettext("하상욱")),
      (gettext("credit_thanks_to"), gettext("설진석") + gettext("thanks_to_chicken"))
    ]
  }

  var body: some View {
    VStack(spacing: 8) {
      Image(nsImage: NSApp.applicationIconImage)
        .resizable()
        .frame(width: 96, height: 96)

      VStack(spacing: 4) {
        Text(BundleInfo.bundleName)
          .font(.system(size: 22, weight: .semibold))
        
        Text("\(gettext("version")) \(BundleInfo.version)")
          .font(.system(size: 12))
          .foregroundStyle(.secondary)
      }

      VStack(spacing: 8) {
        Button(gettext("open_in_appstore")) {
          openAppStore()
        }
        .keyboardShortcut(.return, modifiers: [])

        Button(gettext("view_on_github")) {
          openGitHub()
        }
      }
      .padding(.top, 8)

      Divider()
        .padding(.horizontal, 24)
        .padding(.vertical, 8)

      VStack(alignment: .leading, spacing: 8) {
        ForEach(credits, id: \.0) { key, value in
          HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text(key)
              .font(.system(size: 11, weight: .medium))
              .foregroundStyle(.secondary)
              .frame(width: 80, alignment: .trailing)
            Text(value)
              .font(.system(size: 11))
              .fixedSize(horizontal: false, vertical: true)
          }
        }
      }
      .frame(maxWidth: 280)

      Button(gettext("quit")) {
        NSApplication.shared.terminate(nil)
      }
      .padding(.vertical, 16)

      Text("© 2013-2026 Suyeol Jeon")
        .font(.system(size: 10))
        .foregroundStyle(.tertiary)
    }
    .padding(.top, 8)
    .padding(.bottom, 24)
    .frame(width: 300)
    .fixedSize(horizontal: false, vertical: true)
  }

  private func openAppStore() {
    let appStoreID = "1033453958"
    if let url = URL(string: "macappstore://itunes.apple.com/app/id\(appStoreID)?mt=12") {
      NSWorkspace.shared.open(url)
    }
  }

  private func openGitHub() {
    if let url = URL(string: "https://github.com/devxoul/allkdic") {
      NSWorkspace.shared.open(url)
    }
  }
}

#Preview {
  AboutView()
}
