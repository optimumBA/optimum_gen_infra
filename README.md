# OptimumGenInfra

> [!IMPORTANT]
> This repository is a public archive. OptimumGenInfra is no longer maintained or
> sold, and the code may not reflect current Elixir, Phoenix, or infrastructure
> practices. It is preserved as a historical reference and provided as-is.

Mix task which generates infrastructure code for Elixir apps.

```bash
mix optimum.gen.infra
```

### Flags

Required:

- `--phoenix` or `--no-phoenix`
- `--ecto` or `--no-ecto`
- `--github-url`
- `--elixir-version`
- `--node-version`
- `--otp-version`

Optional:

- `--no-github-actions` - When provided, skips GitHub Actions workflows setup

## Installation

Install OptimumGenInfra directly from GitHub:

```bash
mix archive.install github optimumBA/optimum_gen_infra
```

## Examples

Phoenix apps with database:

```bash
mix optimum.gen.infra \
  --phoenix \
  --ecto \
  --github-url https://github.com/StoryDeckIO/story_deck \
  --elixir-version 1.19.5 \
  --node-version 24.14.0 \
  --otp-version 28.4.1
```

Phoenix apps without database:

```bash
mix optimum.gen.infra \
  --phoenix \
  --no-ecto \
  --github-url https://github.com/optimumBA/phx.tools \
  --elixir-version 1.19.5 \
  --node-version 24.14.0 \
  --otp-version 28.4.1
```

Regular Elixir apps:

```bash
mix optimum.gen.infra \
  --no-phoenix \
  --no-ecto \
  --github-url https://github.com/optimumBA/github_workflows_generator \
  --elixir-version 1.19.5 \
  --node-version 24.14.0 \
  --otp-version 28.4.1
```

## Maintenance status

This repository is archived. Issues and pull requests are not accepted.

## License

The source code is available under the [Apache License 2.0](LICENSE). The
license does not grant permission to use the Optimum name or branding except
as required to describe the origin of the code.
