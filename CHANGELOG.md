# Changelog

## 0.5.0 (2026-03-31)

- Added `LiveViewBareMatch` Credo check to the generated `.credo.exs` to catch bare `{:ok, _} =` pattern matches in LiveView modules.
- Updated OptimumCredo to 0.3.

## 0.4.0 (2026-03-14)

- Made GitHub Actions workflows optional via `--github-actions` flag.
- Removed Fly.io and Docker setup.
- Updated OptimumCredo to 0.2.
- Upgraded Elixir, Erlang, and Node.js versions.
- Updated dependencies.
- Fixed Credo issues.

## 0.3.0 (2025-11-17)

- Upgraded to Elixir 1.19.3, Erlang 28.1.1, and Node.js 22.21.1.
- Updated Mix CLI configuration to use new `def cli` format (fixes deprecation warning in Elixir 1.19+).
- Updated Credo to 1.7.13 (fixes Elixir 1.19 compatibility).
- Configured generated Phoenix apps to pass all checks immediately without manual fixes.
- Improved error handling to fail immediately if phx.gen.release fails.
- Made Fly.io deployment setup conditional based on `--fly-app-prefix` flag.
- Changed installation method from CodeCodeShip to GitHub.
- Removed Cursor rules and git submodules.

## 0.2.0 (2025-05-14)

- Added automated Tidewave setup for Phoenix apps.
- Included new Optimum tools:
  - [cursor_rules](https://elixirdrops.net/d/29oQ4Tub)
  - [optimum_credo](https://elixirdrops.net/d/AsEtmHUq)
  - [optimum_templates](https://elixirdrops.net/d/6UJjiKBt)

## 0.1.5 (2025-04-23)

- Increased Fly.io machines memory to 512 MB.
- Fixed ignored npm dependencies issue in the assets directory.
- Upgraded to Elixir 1.18.3, Erlang 27.3.3, and Node.js 20.19.0.
- Optimized Fly.io health checks.
- Adapted Fly.io configs to the new format.

## 0.1.4 (2024-12-20)

- Switched deployment strategy for staging and preview apps to "immediate".

## 0.1.3 (2024-12-02)

- Improved caching strategy in GitHub Actions workflow.

## 0.1.2 (2024-11-14)

- Fixed missing template files errors.

## 0.1.1 (2024-11-12)

- Fixed typo in README.
- Added changelog.
- Improved example commands' readability.
- Upgraded to Elixir 1.17.3, Erlang 27.1.2, and Node.js 20.18.0.
- Fixed "hex.audit" task not found error.

## 0.1.0 (2024-08-16)

Initial release
