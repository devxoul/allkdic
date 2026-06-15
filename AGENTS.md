# allkdic

macOS menu-bar dictionary app (올ㅋ사전). Built with Tuist, signed with fastlane match, distributed on the Mac App Store.

## Build System

[Tuist](https://tuist.dev) generates the Xcode project from `Project.swift`.

```bash
make install     # tuist install (resolve dependencies)
make generate    # tuist generate --no-open
make build       # tuist build Allkdic
make run         # build and run (logs to terminal)
make test        # run unit tests
make lint        # swiftformat --lint
make format      # swiftformat
make clean       # tuist clean
```

The scheme and workspace are both named `Allkdic`. Version lives in `Allkdic/Allkdic-Info.plist` (`CFBundleShortVersionString` + `CFBundleVersion`), which `Project.swift` references via `infoPlist: .file(...)`.

## Release

Releases run on the **Release** GitHub Actions workflow (`workflow_dispatch`). Trigger it from the Actions tab with a `version` input (`x.y.z`, no `v` prefix). The workflow:

1. Validates the version is strict `x.y.z` and that the tag does not already exist.
2. Installs Tuist, Ruby/fastlane, and resolves dependencies.
3. Bumps `CFBundleShortVersionString` and increments `CFBundleVersion` (the `bump` lane).
4. Builds the Release config, signs with `match` (readonly), and uploads to App Store Connect, submitting for review with automatic release on approval (the `release_ci` lane).
5. Only after a successful upload: pushes the bump commit to `main`, creates the tag (no `v` prefix), and creates a GitHub Release with auto-generated notes.

Local release (`make release`) still works for manual runs and uses `fastlane/api_key.json`; CI uses environment secrets instead.

### Before Triggering: Write Release Notes

The workflow's `bump` lane commits whatever is currently in `fastlane/metadata/*/release_notes.txt`, so update those **and push to `main`** before dispatching the workflow. Edit both locales:

- `fastlane/metadata/ko/release_notes.txt`
- `fastlane/metadata/en-US/release_notes.txt`

These are **App Store release notes for users, not a developer changelog** (the GitHub Release gets auto-generated developer notes separately). Users only care about "what's better for me now?"

- **Benefits, not features** — "검색이 더 빨라졌어요" / "Search feels snappier now", not "Added a caching layer".
- **Be human** — avoid "Bug fixes and performance improvements". 올ㅋ사전 has a playful brand (올ㅋ = casual Korean internet vibe); friendly, witty, emoji-OK is welcome, but authentic > clever.
- **Nothing user-facing?** Be honest: "내부 코드를 정리했어요. 겉으로 달라진 건 없지만 앱이 더 건강해졌습니다 💪" / "Under-the-hood improvements. Nothing flashy, but the app is healthier now."
- **Keep it brief** — the App Store shows ~3 lines before the "more" tap; lead with the most important change (4000 char limit, but shorter is better).
- **Tone** — Korean: 친근한 반말/해요체, 인터넷 감성 OK. English: casual but clear, matching the Korean tone.

### Version Decision

- If the user specifies an exact version (e.g. `2.3.0`), use it as-is.
- Otherwise decide the bump level from the changes since the last release (`git log $(git describe --tags --abbrev=0)..HEAD --oneline`):
  - **minor** (`x.Y.0`) — new features, UI changes, new behaviors
  - **patch** (`x.y.Z`) — bug fixes, performance, refactors, dependency updates
- **Never bump major.** Only the owner does that, manually.
- The build number (`CFBundleVersion`) auto-increments; never set it manually.

### If a Release Fails

A failed run may leave partial state (a tag, a half-uploaded build). Do **not** re-run the same version — the workflow's tag-exists check will block it anyway. Fix forward: debug, then dispatch again with the **next** version number. Failed tags/releases stay; we move forward, not backward.

### Required GitHub Secrets

| Secret | Value |
| --- | --- |
| `MATCH_PASSWORD` | Passphrase that decrypts the `allkdic-match` repo |
| `MATCH_GITHUB_PAT` | Raw GitHub PAT for cloning the private match repo over HTTPS (the workflow base64-encodes `devxoul:PAT` into `MATCH_GIT_BASIC_AUTHORIZATION` at runtime) |
| `APP_STORE_CONNECT_KEY_ID` | App Store Connect API key ID |
| `APP_STORE_CONNECT_ISSUER_ID` | App Store Connect API issuer ID |
| `APP_STORE_CONNECT_API_KEY_P8_BASE64` | `base64` of the `.p8` private key file |

`MATCH_GITHUB_PAT` needs read-only `Contents` access to `devxoul/allkdic-match`.

### Reference

| Item | Location |
| --- | --- |
| Version | `Allkdic/Allkdic-Info.plist` → `CFBundleShortVersionString` |
| Build number | `Allkdic/Allkdic-Info.plist` → `CFBundleVersion` (auto-incremented) |
| Release notes | `fastlane/metadata/*/release_notes.txt` |
| Latest tag | `git describe --tags --abbrev=0` |

## Signing

Certificates and provisioning profiles are stored in the private `devxoul/allkdic-match` repo, encrypted with `MATCH_PASSWORD`. CI uses `match` in readonly mode and never mutates signing assets. To renew or regenerate certs, run `fastlane certs` (or `fastlane match appstore --platform macos`) locally — never from CI.
