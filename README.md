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

- `--fly-app-prefix`

## Installation

To install OptimumGenInfra, you will need to purchase a license. OptimumGenInfra is hosted on [Code Code Ship](https://hex.codecodeship.com/package/optimum_gen_infra).

Once you have purchased a license, follow the installation instructions.

First add `codecodeship` as a Hex repository:

```bash
mix hex.repo add codecodeship https://hex.codecodeship.com/api/repo \
  --fetch-public-key SHA256:5hyUvvnGT45CntYCrHAOO3tn94l1xz8fUlyQS7qDhxg \
  --auth-key [YOUR AUTH KEY]
```

Then install `optimum_gen_infra`:

```bash
mix archive.install hex optimum_gen_infra --repo codecodeship
```

## Examples

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

Phoenix apps with a database:

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
