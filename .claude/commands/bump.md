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

Edit all locale files:
- `fastlane/metadata/ko/release_notes.txt`
- `fastlane/metadata/en-US/release_notes.txt`

#### Writing Philosophy

**These are App Store release notes, not commit messages.** Users don't care about:
- "Upgraded to Swift X.Y"
- "Refactored internal architecture"
- "Fixed memory leak in module Z"

Users care about: **What's better for ME now?**

#### Style Guidelines

1. **Be human, not robotic**
   - ❌ "Bug fixes and performance improvements"
   - ✅ Write something a human would actually want to read

2. **Focus on benefits, not features**
   - ❌ "Added caching layer for API responses"
   - ✅ "검색 결과가 더 빨라졌어요" / "Search feels snappier now"

3. **Personality is welcome**
   - 올ㅋ사전 has a playful brand (올ㅋ = casual Korean internet vibe)
   - Be friendly, witty, or even humorous when appropriate
   - But don't force it - authentic > clever

4. **When there's nothing user-facing**
   - Internal refactors, dependency updates, CI changes = no visible user impact
   - Be honest: "내부 코드를 정리했어요. 겉으로 달라진 건 없지만, 앱이 더 건강해졌습니다 💪"
   - Or: "Under-the-hood improvements. Nothing flashy, but the app is healthier now."

5. **Keep it brief**
   - App Store shows ~3 lines before "more" tap
   - Lead with the most important change
   - 4000 char limit, but shorter is better

#### Examples of Good Release Notes

**Bug fix release:**
```
링크를 새 창에서 열 때 사파리가 아닌 기본 브라우저에서 열리도록 고쳤어요.
크롬 유저분들, 이제 편하게 쓰세요! 🎉
```

**Feature release:**
```
다크 모드가 드디어 왔습니다! 🌙
밤에 단어 검색할 때 눈이 편해질 거예요.
```

**Nothing user-facing:**
```
이번 업데이트는 봄맞이 대청소예요 🧹
코드를 깔끔하게 정리해서 앱이 더 안정적으로 돌아갑니다.
```

**Playful style (optional):**
```
버그 하나 잡았어요.
잡기 전: 링크 클릭 → 사파리 열림 → 왜...?
잡은 후: 링크 클릭 → 기본 브라우저 열림 → 편-안
```

#### Language Notes

- **Korean (ko)**: 친근한 반말 or 해요체. 이모지 OK. 인터넷 감성 OK.
- **English (en-US)**: Casual but clear. Match Korean tone.

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
