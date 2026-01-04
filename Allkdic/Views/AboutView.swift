// The MIT License (MIT)
//
// Copyright (c) 2013 Suyeol Jeon (http://xoul.kr)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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
    VStack(spacing: 12) {
      Image(nsImage: NSApp.applicationIconImage)
        .resizable()
        .frame(width: 96, height: 96)

      Text(BundleInfo.bundleName)
        .font(.system(size: 22, weight: .semibold))

      Text("\(gettext("version")) \(BundleInfo.version)")
        .font(.system(size: 12))
        .foregroundStyle(.secondary)

      HStack(spacing: 8) {
        Button(gettext("open_in_appstore")) {
          openAppStore()
        }
        .keyboardShortcut(.return, modifiers: [])

        Button {
          openGitHub()
        } label: {
          HStack(spacing: 4) {
            Text(gettext("view_on_github"))
            Image(systemName: "arrow.up.right")
          }
        }
      }
      .padding(.top, 4)

      Divider()
        .padding(.horizontal, 24)

      VStack(alignment: .leading, spacing: 8) {
        ForEach(credits, id: \.0) { key, value in
          HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text(key)
              .font(.system(size: 11, weight: .medium))
              .foregroundStyle(.secondary)
              .frame(width: 80, alignment: .trailing)
            Text(value)
              .font(.system(size: 11))
          }
        }
      }

      Spacer()

      Button(gettext("quit")) {
        NSApplication.shared.terminate(nil)
      }

      Text("© 2013-2026 Suyeol Jeon")
        .font(.system(size: 10))
        .foregroundStyle(.tertiary)
    }
    .padding(.top, 40)
    .padding(.bottom, 24)
    .frame(width: 340, height: 420)
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
