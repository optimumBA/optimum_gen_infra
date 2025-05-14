defmodule OptimumGenInfra.MixProject do
  use Mix.Project

  def project do
    [
      app: :optimum_gen_infra,
      version: "0.1.5",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: optimum_deps() ++ app_deps(),

      # Hex package
      description: "Generate GitHub Actions workflows",
      package: package(),
      hex: [
        api_url: "https://hex.codecodeship.com/api"
      ],

      # CI
      dialyzer: [
        plt_add_apps: [:ex_unit, :mix],
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ],
      preferred_cli_env: [
        ci: :test,
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.html": :test,
        credo: :test,
        dialyzer: :test
      ],
      test_coverage: [tool: ExCoveralls],

      # Docs
      name: "OptimumGenInfra",
      docs: [
        extras: ["README.md"],
        main: "readme"
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      licenses: [],
      links: %{},
      maintainers: ["Almir Sarajčić"]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp app_deps do
    []
  end

  defp optimum_deps do
    [
      {:credo, "~> 1.7", only: :test, runtime: false},
      {:dialyxir, "~> 1.4", only: :test, runtime: false},
      {:doctest_formatter, "~> 0.3", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false},
      {:excoveralls, "~> 0.18", only: :test},
      {:github_workflows_generator, "~> 0.1", only: :dev, runtime: false},
      {:mix_audit, "~> 2.1", only: :test, runtime: false},
      {:optimum_credo, "~> 0.1", only: :test, runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "archive.build": "archive.build --include-dot-files",
      setup: [
        "deps.get",
        "cmd npm i -D prettier prettier-plugin-toml"
      ],
      ci: [
        "deps.unlock --check-unused",
        "deps.audit",
        "hex.audit",
        "format --check-formatted",
        "cmd npx prettier -c .",
        "credo --strict",
        "dialyzer",
        "test --cover --warnings-as-errors"
      ],
      prettier: ["cmd npx prettier -w ."]
    ]
  end
end
