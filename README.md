# Helios iOS Port

Helios is a web app (`src/`) wrapped in a native iOS shell with [Tauri v2](https://v2.tauri.app) (`src-tauri/`, Rust). Netlify hosts the web version. The `.ipa` is compiled on macOS.

## Why the .ipa isn't built on Netlify
Only Apple's Xcode toolchain can compile iOS apps, and it runs only on macOS. Apple also requires every installable `.ipa` to be signed with a certificate from an Apple Developer account. Netlify builds run on Linux, so the `.ipa` is built on GitHub's macOS runners or on your own Mac.

## Option A: build on GitHub Actions (no Mac needed)
1. Push this repo to GitHub.
2. Add these repository secrets:
   | Secret | Value |
   |---|---|
   | `APPLE_DEVELOPMENT_TEAM` | Your 10-character Team ID (developer.apple.com → Membership) |
   | `IOS_CERTIFICATE` | `base64 -i cert.p12` of your distribution certificate |
   | `IOS_CERTIFICATE_PASSWORD` | Password of the `.p12` |
   | `IOS_MOBILE_PROVISION` | `base64 -i profile.mobileprovision` for bundle ID `com.helios.iosport` |
3. Go to **Actions → Build iOS .ipa → Run workflow**.
4. Download `Helios-ipa` from the run's artifacts.

## Option B: build on your Mac
Install Xcode, Rust (`rustup`), and Node.js 20 or later, then run:
```sh
export APPLE_DEVELOPMENT_TEAM=XXXXXXXXXX
./scripts/build-ipa.sh                 # ad-hoc / TestFlight-style build
./scripts/build-ipa.sh app-store-connect
```
The script prints the path to the `.ipa` when it finishes. To run the app in the iOS Simulator during development, use `npm run ios:dev`.

## Customizing
- Edit the app UI in `src/index.html`.
- Change the app name or bundle ID in `src-tauri/tauri.conf.json`. The provisioning profile must match the bundle ID.
- Replace `app-icon.svg` to change the app icon.
