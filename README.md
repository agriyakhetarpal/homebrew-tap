# homebrew-tap

Welcome to my Homebrew tap!

Right now, this tap enables the installation of [Mirinae](https://github.com/agriyakhetarpal/mirinae), a Galaxy Buds app for macOS devices.

```sh
brew install --formula agriyakhetarpal/tap/mirinae  # builds on your Mac, no Gatekeeper prompt
brew install --cask agriyakhetarpal/tap/mirinae   # prebuilt app from the GitHub release
```

Homebrew 6 asks you to trust third-party taps before it loads anything from them. Installing
with the full name as above trusts just Mirinae and nothing else. If you prefer to `brew tap
agriyakhetarpal/tap` first and install by the short name, run
`brew trust --cask agriyakhetarpal/tap/mirinae` (or `--formula`) once, or trust the whole tap
with `brew trust agriyakhetarpal/tap`.

The formula builds from the tagged source tarball. The cask downloads the release zip, which is
ad-hoc signed and not notarised, so macOS asks for a one-time "Open Anyway" on first launch.

Both checksums come from the `SHA256SUMS` file attached to each release.
`Scripts/bump.sh <version>` fetches that file and updates the formula and cask.

---

Thanks for stopping by! :)
