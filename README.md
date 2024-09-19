# OptimumGenInfra

Mix task which generates infrastructure code for Elixir apps.

```bash
mix optimum.gen.infra
```

### Flags

Required:

- `--ecto` or `--no-ecto`
- `--elixir-version`
- `--github-url`
- `--node-version`
- `--otp-version`
- `--phoenix` or `--no-phoenix`

Optional:

- `--fly-app-prefix`

## Installation

To install OptimumGenInfra, you will need to purchase a license. OptimumGenInfra is hosted on [Code Code Ship](https://hex.codecodeship.com/package/optimum_gen_infra).

Once you have purchased a license, follow the installation instructions.

First add `codecodeship` as a Hex repository:

```bash
mix hex.repo add codecodeship https://hex.codecodeship.com/api/repo --fetch-public-key SHA256:5hyUvvnGT45CntYCrHAOO3tn94l1xz8fUlyQS7qDhxg --auth-key [YOUR AUTH KEY]
```

Then install `optimum_gen_infra`:

```bash
mix archive.install hex optimum_gen_infra --repo codecodeship
```

## Examples

Phoenix apps without database:

```bash
mix optimum.gen.infra --no-ecto --elixir-version 1.17.1 --fly-app-prefix phx-tools --github-url https://github.com/optimumBA/phx.tools --node-version 20.14.0 --otp-version 27.0
```

Phoenix apps with a database:

```bash
mix optimum.gen.infra --ecto --elixir-version 1.15.8 --fly-app-prefix storydeck --github-url https://github.com/StoryDeckIO/story_deck --node-version 20.14.0 --otp-version 26.2.5
```

Regular Elixir apps:

```bash
mix optimum.gen.infra --no-ecto --no-phoenix --elixir-version 1.17.1 --github-url https://github.com/optimumBA/github_workflows_generator --node-version 20.14.0 --otp-version 27.0
```

## Contact

For any questions contact us at [tools@optimum.ba](mailto:tools@optimum.ba).
