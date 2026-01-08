# /bump - Version Bump & Release

Analyze changes, bump version, release to GitHub, submit to App Store.

## Arguments

- `$ARGUMENTS`: Optional. "patch", "minor", or specific version like "2.2.0". If omitted, auto-determine from changelog.

## Execution

<steps>

### 1. Changelog Analysis

```bash
LATEST_TAG=$(git describe --tags --abbrev=0)
git log ${LATEST_TAG}..HEAD --oneline
```

Determine version bump type:
- **patch** (x.y.Z): Bug fixes, performance improvements, refactoring
- **minor** (x.Y.0): New features, UI changes, new behaviors

**NEVER bump major.** Only the owner can do that manually.

### 2. Update Release Notes

Edit all locale files with user-facing summary (not developer commit messages):

- `fastlane/metadata/*/release_notes.txt` (all languages)

Format:
```
Brief summary sentence.

• User-visible change 1
• User-visible change 2
```

**Do NOT commit yet** - these will be included in the bump commit.

### 3. Bump Version & Build Number

```bash
make bump VERSION=${NEW_VERSION}
```

This commits Info.plist + release notes together: "Bump version to X.Y.Z (N)"

### 4. Tag & Push

```bash
git tag ${NEW_VERSION}
git push origin main
git push origin ${NEW_VERSION}
```

### 5. GitHub Release

```bash
gh release create ${NEW_VERSION} --title "올ㅋ사전 ${NEW_VERSION}" --generate-notes
```

Auto-generated notes = developer-facing changelog (different from App Store release notes).

### 6. App Store Submission

```bash
make release
```

**WAIT for completion.** This takes several minutes (build + upload + submit).

</steps>

## Error Recovery

<on_failure>
If ANY step fails:

1. **DO NOT retry the same version** - partial state may exist
2. Create fix branch: `git checkout -b fix/bump-${NEW_VERSION}-error`
3. Debug and fix
4. Create PR
5. **Skip this version entirely** - next release uses next version number

Failed tag/release remains. We move forward, not backward.
</on_failure>

## Reference

| Item | Location |
|------|----------|
| Version | `Allkdic/Allkdic-Info.plist` → `CFBundleShortVersionString` |
| Build | `Allkdic/Allkdic-Info.plist` → `CFBundleVersion` |
| Release notes | `fastlane/metadata/*/release_notes.txt` |
| Latest tag | `git describe --tags --abbrev=0` |
