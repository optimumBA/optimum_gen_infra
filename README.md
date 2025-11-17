# OptimumGenInfra

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

- `--fly-app-prefix` - When provided, enables Fly.io deployment setup (preview apps, staging deployment, Docker files)

## Installation

Install OptimumGenInfra directly from GitHub:

```bash
mix archive.install github optimumBA/optimum_gen_infra
```

## Examples

Phoenix apps with database and Fly.io deployment:

```bash
mix optimum.gen.infra \
  --phoenix \
  --ecto \
  --github-url https://github.com/StoryDeckIO/story_deck \
  --fly-app-prefix storydeck \
  --elixir-version 1.19.3 \
  --node-version 22.21.1 \
  --otp-version 28.1.1
```

Phoenix apps without database:

```bash
mix optimum.gen.infra \
  --phoenix \
  --no-ecto \
  --github-url https://github.com/optimumBA/phx.tools \
  --fly-app-prefix phx-tools \
  --elixir-version 1.19.3 \
  --node-version 22.21.1 \
  --otp-version 28.1.1
```

Phoenix apps without Fly.io deployment:

```bash
mix optimum.gen.infra \
  --phoenix \
  --ecto \
  --github-url https://github.com/StoryDeckIO/story_deck \
  --elixir-version 1.19.3 \
  --node-version 22.21.1 \
  --otp-version 28.1.1
```

Regular Elixir apps:

```bash
mix optimum.gen.infra \
  --no-phoenix \
  --no-ecto \
  --github-url https://github.com/optimumBA/github_workflows_generator \
  --elixir-version 1.19.3 \
  --node-version 22.21.1 \
  --otp-version 28.1.1
```

## Contact

For any questions contact us at [tools@optimum.ba](mailto:tools@optimum.ba).
