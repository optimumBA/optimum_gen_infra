defmodule Mix.Tasks.Optimum.Gen.Infra do
  @shortdoc "Generates Optimum infrastructure code"

  @moduledoc """
  Generates Optimum infrastructure code
  Should be run after Phoenix app is generated.
  """

  use Mix.Task

  @aliases ~S"""
        setup: [
          "deps.get",
          "cmd npm i -D prettier prettier-plugin-toml"<%= if ecto or phoenix do %>,
          <%= if ecto do %>"ecto.setup",
          <% end %><%= if phoenix do %>"assets.setup",
          "assets.build"<% end %><% end %>
        ],
        <%= if ecto do %>"ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
        "ecto.reset": ["ecto.drop", "ecto.setup"],
        test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
        <% end %><%= if phoenix do %>"assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
        "assets.build": ["tailwind <%= app_name %>", "esbuild <%= app_name %>"],
        "assets.deploy": [
          "tailwind <%= app_name %> --minify",
          "esbuild <%= app_name %> --minify",
          "phx.digest"
        ],<% end %>
        ci: [
          "deps.unlock --check-unused",
          "deps.audit",
          "hex.audit",
          <%= if phoenix do %>"sobelow --config .sobelow-conf",
          <% end %>"format --check-formatted",
          "cmd npx prettier -c .",
          "credo --strict",
          "dialyzer",
          "test --cover --warnings-as-errors"
        ],
        prettier: ["cmd npx prettier -w ."]
  """

  @gitignore ~S"""
  # Optimum development/test artifacts
  /node_modules/
  /priv/plts/
  <%= if phoenix do %>/screenshots/
  <% end %>/package.json
  /package-lock.json
  .DS_Store
  <%= if phoenix do %>.env
  <% end %>
  """

  @git_submodules ~S"""
  <%= if phoenix do %>https://github.com/optimumBA/optimum_templates priv/templates<% end %>
  """

  @switches [
    ecto: :boolean,
    elixir_version: :string,
    github_url: :string,
    node_version: :string,
    otp_version: :string,
    phoenix: :boolean
  ]

  @deps ~S"""
        <%= if phoenix do %>{:appsignal_phoenix, "~> 2.8"},
        <% end %>{:credo, "~> 1.7", only: :test, runtime: false},
        {:dialyxir, "~> 1.4", only: :test, runtime: false},
        {:doctest_formatter, "~> 0.4", only: [:dev, :test], runtime: false},
        {:ex_doc, "~> 0.40", only: :dev, runtime: false},
        <%= if ecto do %>{:ex_machina, "~> 2.8", only: :test},
        <% end %>{:excoveralls, "~> 0.18", only: :test},
        <%= if ecto do %>{:faker, "~> 0.18", only: :test},
        <% end %>{:github_workflows_generator, "~> 0.1", only: :dev, runtime: false},
        {:mix_audit, "~> 2.1", only: :test, runtime: false},
        {:optimum_credo, "~> 0.2", only: :test, runtime: false}<%= if phoenix do %>,
        {:sobelow, "~> 0.14", only: :test, runtime: false},
        {:tidewave, "~> 0.5", only: :dev}<% end %>
  """

  @file_paths [
    config: "config/config.exs",
    coveralls: "coveralls.json",
    credo: ".credo.exs",
    dialyzer_ignore: ".dialyzer_ignore.exs",
    env_prod_sample: ".env.prod.sample",
    env_sample: ".env.sample",
    env: ".env",
    formatter: ".formatter.exs",
    github_workflows: ".github/github_workflows.ex",
    gitignore: ".gitignore",
    health_controller: "lib/<app_name>_web/controllers/health_controller.ex",
    health_controller_test: "test/<app_name>_web/controllers/health_controller_test.exs",
    makefile: "Makefile",
    mise: ".mise.toml",
    mix: "mix.exs",
    prettierignore: ".prettierignore",
    prettierrc: ".prettierrc.js",
    prod_config: "config/prod.exs",
    readme: "README.md",
    router: "lib/<app_name>_web/router.ex",
    runtime_config: "config/runtime.exs",
    sobelow_conf: ".sobelow-conf",
    tool_versions: ".tool-versions"
  ]

  @new_files [
    @file_paths[:coveralls],
    @file_paths[:credo],
    @file_paths[:dialyzer_ignore],
    @file_paths[:env],
    @file_paths[:env_prod_sample],
    @file_paths[:env_sample],
    @file_paths[:github_workflows],
    @file_paths[:health_controller],
    @file_paths[:health_controller_test],
    @file_paths[:makefile],
    @file_paths[:mise],
    @file_paths[:prettierignore],
    @file_paths[:prettierrc],
    @file_paths[:readme],
    @file_paths[:sobelow_conf]
  ]

  @phoenix_files [
    @file_paths[:env],
    @file_paths[:env_prod_sample],
    @file_paths[:env_sample],
    @file_paths[:health_controller],
    @file_paths[:health_controller_test],
    @file_paths[:mise],
    @file_paths[:sobelow_conf]
  ]

  @config ~S"""
  # AppSignal
  config :appsignal, :config,
    active: false,
    <%= if ecto do %>ecto_repos: [<%= app_name_camel_case %>.Repo],
    <% end %>env: config_env(),
    ignore_actions: ["<%= app_name_camel_case %>Web.HealthController#index"],
    name: "<%= app_name %>",
    otp_app: :<%= app_name %>
  """

  @prod_config ~S"""
  # Do not print debug messages in production
  config :logger,
    backends: [:console, {Appsignal.Logger.Backend, [group: "phoenix"]}],
    level: :info

  # AppSignal
  config :appsignal, :config, active: true
  """

  @project ~S"""
        # CI
        dialyzer: [
          plt_add_apps: [:ex_unit, :mix],
          plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
        ],
        test_coverage: [tool: ExCoveralls],

        # Docs
        name: "<%= app_name_camel_case %>",
        source_url: "<%= github_url %>",
        docs: [
          extras: ["README.md"],
          main: "readme",
          source_ref: "main"
        ]<%= if phoenix do %>,

        # Release
        releases: [
          <%= app_name %>: [
            include_executables_for: [:unix]
          ]
        ]<% end %>
  """

  @cli ~S"""
    [
      preferred_envs: [
        ci: :test,
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.html": :test,
        credo: :test,
        dialyzer: :test<%= if phoenix do %>,
        sobelow: :test<% end %>
      ]
    ]
  """

  @runtime_config ~S'''
    appsignal_app_env =
      System.get_env("APPSIGNAL_APP_ENV") ||
        raise """
        environment variable APPSIGNAL_APP_ENV is missing.
        """

    appsignal_push_api_key =
      System.get_env("APPSIGNAL_PUSH_API_KEY") ||
        raise """
        environment variable APPSIGNAL_PUSH_API_KEY is missing.
        """

    appsignal_revision =
      System.get_env("APP_REVISION") ||
        raise """
        environment variable APP_REVISION is missing.
        """

    config :appsignal, :config,
      env: appsignal_app_env,
      push_api_key: appsignal_push_api_key,
      revision: appsignal_revision
  '''

  @impl Mix.Task
  def run(args, _opts \\ []) do
    project_root = Path.expand(".")

    opts = validate_opts(args)
    validate_project(project_root, opts)

    versions = get_versions(opts)
    bindings = get_bindings(project_root, opts, versions)

    create_new_files(project_root, bindings, opts)
    update_existing_files(project_root, bindings, opts)
    setup_project()
    setup_git_submodules(project_root, bindings, opts)

    if opts[:phoenix] do
      setup_release(project_root)
      setup_tidewave(project_root, bindings)
    end

    generate_github_workflows()
    format_files()
  end

  defp validate_opts(args) do
    {opts, _remaining_args} = OptionParser.parse!(args, switches: @switches)

    check_switches(@switches, opts)

    opts
  end

  defp check_switches(switches, opts) do
    Enum.each(switches, fn {key, _type} ->
      unless Keyword.has_key?(opts, key) do
        raise "Option #{key} not set"
      end
    end)
  end

  defp validate_project(project_root, opts) do
    path = get_file_path(@file_paths[:mix], project_root, [])

    File.exists?(path) ||
      raise "Missing file: #{@file_paths[:mix]}. Are you in the right directory?"

    project_file = File.read!(path)

    if opts[:phoenix] and !String.match?(project_file, ~r/\{:phoenix,[^\}]+}/) do
      raise "Not a Phoenix app."
    end
  end

  defp get_versions(opts) do
    versions = [
      elixir: Keyword.fetch!(opts, :elixir_version),
      node: Keyword.fetch!(opts, :node_version),
      otp: Keyword.fetch!(opts, :otp_version)
    ]

    [otp_major_version, _rest] = String.split(versions[:otp], ".", parts: 2)

    Keyword.put(versions, :otp_major_version, otp_major_version)
  end

  defp get_bindings(project_root, opts, versions) do
    mix_file_path = Path.join(project_root, @file_paths[:mix])
    mix_file = File.read!(mix_file_path)

    [app_name_camel_case] = Regex.run(~r/defmodule ([^\.]+)\./, mix_file, capture: :all_but_first)
    [app_name_snake_case] = Regex.run(~r/app: :([^,]+)/, mix_file, capture: :all_but_first)

    [repo_name] =
      Regex.run(~r|github\.com/[^/]+/(.+)|, Keyword.fetch!(opts, :github_url),
        capture: :all_but_first
      )

    [
      app_name: app_name_snake_case,
      app_name_camel_case: app_name_camel_case,
      elixir_version: versions[:elixir],
      github_url: Keyword.fetch!(opts, :github_url),
      node_version: versions[:node],
      otp_major_version: versions[:otp_major_version],
      otp_version: versions[:otp],
      repo_name: repo_name
    ]
  end

  defp update_mix_file(project_root, bindings, opts) do
    mix_file_path = Path.join(project_root, @file_paths[:mix])
    mix_file = File.read!(mix_file_path)

    updated_mix_file =
      mix_file
      |> inject_aliases(bindings, opts)
      |> inject_cli(bindings, opts)
      |> inject_project_info(bindings, opts)
      |> inject_mix_dependencies(bindings, opts)

    File.write!(mix_file_path, updated_mix_file)
  end

  defp create_new_files(project_root, bindings, opts) do
    Enum.each(@new_files, fn path ->
      cond do
        path in @phoenix_files and not opts[:phoenix] ->
          :skip

        true ->
          create_file(project_root, path, bindings, opts)
      end
    end)
  end

  defp update_existing_files(project_root, bindings, opts) do
    update_mix_file(project_root, bindings, opts)
    update_formatter_file(project_root, bindings)
    update_gitignore_file(project_root, bindings, opts)
    create_tool_versions_file(project_root, bindings, opts)

    if opts[:phoenix] do
      update_router(project_root, bindings, opts)
      update_config_file(project_root, bindings, opts)
      update_runtime_config_file(project_root, bindings, opts)
      update_prod_config_file(project_root, bindings)
    end
  end

  defp create_file(project_root, path, bindings, opts) do
    file_path = get_file_path(path, project_root, bindings)
    template_path = get_template_path(path, bindings)

    if File.exists?(file_path) do
      Mix.shell().info([:yellow, "* updating file #{file_path}"])
    else
      Mix.shell().info([:green, "* creating file #{file_path}"])

      file_path
      |> String.split(~r/\/[^\/]+$/, parts: 2)
      |> List.first()
      |> File.mkdir_p!()

      File.touch!(file_path)
    end

    if File.exists?(template_path) do
      content =
        template_path
        |> File.read!()
        |> inject_bindings(bindings, opts)

      File.write!(file_path, content)
    end
  end

  defp get_file_path(path, project_root, bindings) do
    Enum.reduce(bindings, Path.join(project_root, path), fn {key, value}, path ->
      if is_binary(value) do
        String.replace(path, "<#{key}>", value)
      else
        path
      end
    end)
  end

  defp get_template_path(path, bindings) do
    path =
      Enum.reduce(
        bindings,
        Path.join([:code.priv_dir(:optimum_gen_infra), "templates", path]),
        fn {key, _value}, path -> String.replace(path, "<#{key}>", "#{key}") end
      )

    path <> ".eex"
  end

  defp inject_bindings(content, bindings, opts) do
    content
    |> EEx.compile_string()
    |> Code.eval_quoted(bindings ++ opts)
    |> elem(0)
  end

  defp update_ignore_file_content(new_content, existing_content, bindings, opts) do
    new_content
    |> inject_bindings(bindings, opts)
    |> String.split("\n\n", trim: true)
    |> Enum.reduce(existing_content, fn section, content ->
      [section_name] = Regex.run(~r/(# [^\n]+)/, section, capture: :all_but_first)

      content =
        if String.match?(content, ~r/#{section_name}/) do
          remove_existing_ignore_section(content, section_name)
        else
          content
        end

      String.trim(content) <> "\n\n" <> String.trim(section) <> "\n"
    end)
  end

  defp remove_existing_ignore_section(content, section_name) do
    [before_section, rest] = String.split(content, "#{section_name}", parts: 2)

    after_section =
      case String.split(rest, "\n\n", parts: 2) do
        [_section, after_section] ->
          String.trim(after_section)

        [_section] ->
          ""
      end

    String.trim(before_section) <> "\n\n" <> after_section
  end

  defp inject_aliases(mix_file, bindings, opts) do
    Mix.shell().info([:green, "* injecting Mix aliases"])

    aliases = inject_bindings(@aliases, bindings, opts)

    [beginning, rest] = String.split(mix_file, "defp aliases do\n    [", parts: 2)
    [_aliases, rest_of_mix_file] = String.split(rest, "]\n  end", parts: 2)

    "#{beginning}defp aliases do\n    [\n#{aliases}    ]\n  end#{rest_of_mix_file}"
  end

  defp inject_cli(mix_file, bindings, opts) do
    Mix.shell().info([:green, "* injecting Mix CLI config"])

    cli_config = inject_bindings(@cli, bindings, opts)

    if String.contains?(mix_file, "def cli do") do
      [beginning, rest] = String.split(mix_file, ~r/def cli do\n    \[/, parts: 2)
      [_cli, rest_of_mix_file] = String.split(rest, ~r/\]\n  end/, parts: 2)

      "#{beginning}def cli do\n#{cli_config}  end#{rest_of_mix_file}"
    else
      String.replace(
        mix_file,
        ~r/(  def application do\n.*?\n  end\n)/s,
        "\\1\n  def cli do\n#{cli_config}  end\n",
        global: false
      )
    end
  end

  defp inject_project_info(mix_file, bindings, opts) do
    Mix.shell().info([:green, "* injecting Mix project info"])

    [beginning, rest] = String.split(mix_file, ~r/def project do\n    \[/, parts: 2)
    [project_part, rest_of_mix_file] = String.split(rest, ~r/,?\n    ]\n  end/, parts: 2)
    project = project_part <> ","

    updated_project =
      @project
      |> inject_bindings(bindings, opts)
      |> String.split("\n\n", trim: true)
      |> Enum.reduce(project, fn section, project ->
        [section_name] = Regex.run(~r/(# [^\n]+)/, section, capture: :all_but_first)

        project =
          if String.match?(project, ~r/#{section_name}/) do
            [before_section, project_rest] =
              String.split(project, "      #{section_name}", parts: 2)

            [_section, project_rest] = String.split(project_rest, "\n\n", parts: 2)

            before_section <> project_rest
          else
            project
          end

        project <> "\n\n" <> section
      end)

    "#{beginning}def project do\n    \[#{updated_project}    ]\n  end#{rest_of_mix_file}"
  end

  defp inject_mix_dependencies(content, bindings, opts) do
    Mix.shell().info([:green, "* injecting Mix dependencies"])

    optimum_deps =
      @deps
      |> inject_bindings(bindings, opts)
      |> String.trim()

    content =
      if opts[:phoenix] do
        String.replace(
          content,
          "deps: deps(),",
          "deps: phoenix_deps() ++ optimum_deps() ++ app_deps(),"
        )
      else
        String.replace(
          content,
          "deps: deps(),",
          "deps: optimum_deps() ++ app_deps(),"
        )
      end

    if String.match?(content, ~r/defp deps do/) do
      transform_deps(content, optimum_deps, opts[:phoenix])
    else
      [beginning, rest] = String.split(content, "defp optimum_deps do", parts: 2)

      rest =
        rest
        |> String.split("end", parts: 2)
        |> Enum.at(1)
        |> String.trim_trailing()
        |> remove_duplicate_deps(optimum_deps)

      ~s"""
      #{beginning}defp optimum_deps do
          [
            #{optimum_deps}
          ]
        end#{rest}
      """
    end
  end

  defp transform_deps(content, optimum_deps, true = _phoenix) do
    replacement = ~s"""
      defp app_deps do
        []
      end

      defp optimum_deps do
        [
          #{optimum_deps}
        ]
      end

      defp phoenix_deps do
    """

    updated_content = String.replace(content, "  defp deps do\n", replacement)
    [beginning, rest] = String.split(updated_content, "defp phoenix_deps do", parts: 2)
    rest_without_duplicates = remove_duplicate_deps(rest, optimum_deps)

    "#{beginning}defp phoenix_deps do#{rest_without_duplicates}"
  end

  defp transform_deps(content, optimum_deps, _phoenix) do
    replacement = ~s"""
      defp optimum_deps do
        [
          #{optimum_deps}
        ]
      end

      defp app_deps do
    """

    updated_content = String.replace(content, "  defp deps do\n", replacement)
    [beginning, rest] = String.split(updated_content, "defp app_deps do", parts: 2)
    rest_without_duplicates = remove_duplicate_deps(rest, optimum_deps)

    "#{beginning}defp app_deps do#{rest_without_duplicates}"
  end

  defp remove_duplicate_deps(content, optimum_deps) do
    ~r/\{:([^,]+)[^\}]+\},?/
    |> Regex.scan(optimum_deps, capture: :all_but_first)
    |> Enum.reduce(content, fn [dep], content ->
      String.replace(content, ~r/\n\s+\{:#{dep}[^\}]+\},?$/m, "")
    end)
  end

  defp update_formatter_file(project_root, bindings) do
    path = get_file_path(@file_paths[:formatter], project_root, bindings)

    Mix.shell().info([:yellow, "* updating file #{path}"])

    formatter_file =
      path
      |> File.read!()
      |> String.replace(
        ~r/(?:DoctestFormatter,[\s\n]+)?Phoenix\.LiveView\.HTMLFormatter/,
        "DoctestFormatter, Phoenix.LiveView.HTMLFormatter"
      )
      |> String.replace(
        ~r|"\*\.{heex,ex,exs}"(?:,[\s\n]+"\.github/github_workflows\.ex")?|,
        ~S|"*.{heex,ex,exs}", ".github/github_workflows.ex"|
      )

    File.write!(path, formatter_file)
  end

  defp update_gitignore_file(project_root, bindings, opts) do
    path = get_file_path(@file_paths[:gitignore], project_root, bindings)

    Mix.shell().info([:yellow, "* updating file #{path}"])

    content = File.read!(path)
    updated_content = update_ignore_file_content(@gitignore, content, bindings, opts)
    File.write!(path, updated_content)
  end

  defp create_tool_versions_file(project_root, bindings, opts) do
    file_path = get_file_path(@file_paths[:tool_versions], project_root, bindings)
    template_path = get_template_path(@file_paths[:tool_versions], bindings)

    if File.exists?(file_path) do
      Mix.shell().info([:yellow, "* updating file #{file_path}"])
    else
      Mix.shell().info([:green, "* creating file #{file_path}"])
    end

    template_file =
      template_path
      |> File.read!()
      |> inject_bindings(bindings, opts)

    tools = String.split(template_file, "\n", trim: true)

    File.touch!(file_path)

    content = File.read!(file_path)

    updated_content =
      Enum.reduce(tools, content, fn tool, content ->
        [tool_name, _version] = String.split(tool, " ", trim: true)

        if String.contains?(content, tool_name) do
          String.replace(content, ~r/#{tool_name} [^\n]+/, tool)
        else
          content <> tool <> "\n"
        end
      end)

    File.write!(file_path, updated_content)
  end

  defp update_router(project_root, bindings, opts) do
    path = get_file_path(@file_paths[:router], project_root, bindings)

    Mix.shell().info([:yellow, "* updating file #{path}"])

    content = File.read!(path)

    health_route =
      inject_bindings(
        ~s|resources "/health", <%= app_name_camel_case %>Web.HealthController, only: [:index]\n|,
        bindings,
        opts
      )

    updated_content =
      if String.contains?(content, health_route) do
        content
      else
        String.replace(content, ~r/^end/m, "\n" <> health_route <> "end")
      end

    File.write!(path, updated_content)
  end

  defp update_config(new_content, content, add_fun, edit_fun) do
    new_content
    |> String.split("\n\n", trim: true)
    |> Enum.reduce(content, fn section, content ->
      [section_name] = Regex.run(~r/(# [^\n]+)/, section, capture: :all_but_first)

      if String.contains?(content, section_name) do
        edit_fun.(content, section, section_name)
      else
        add_fun.(content, section)
      end
    end)
  end

  defp update_config_file(project_root, bindings, opts) do
    path = get_file_path(@file_paths[:config], project_root, bindings)

    Mix.shell().info([:yellow, "* updating file #{path}"])

    content = File.read!(path)

    add_fun = fn content, section ->
      String.replace(
        content,
        "# Import environment specific config.",
        section <> "\n# Import environment specific config."
      )
    end

    edit_fun = fn content, section, section_name ->
      [before_section, rest] = String.split(content, ~r/\n\n#{section_name}/s, parts: 2)
      [_section, rest] = String.split(rest, "\n\n", parts: 2)
      before_section <> "\n\n" <> section <> "\n" <> rest
    end

    updated_content =
      @config
      |> inject_bindings(bindings, opts)
      |> update_config(content, add_fun, edit_fun)

    File.write!(path, updated_content)
  end

  defp update_runtime_config_file(project_root, bindings, opts) do
    path = get_file_path(@file_paths[:runtime_config], project_root, bindings)

    Mix.shell().info([:yellow, "* updating file #{path}"])

    runtime_config = inject_bindings(@runtime_config, bindings, opts)

    content =
      path
      |> File.read!()
      |> String.replace(
        ~r/(if config_env\(\) == :prod do.*)\nend/s,
        "\\1\n\n" <> runtime_config <> "end"
      )

    File.write!(path, content)
  end

  defp update_prod_config_file(project_root, bindings) do
    path = get_file_path(@file_paths[:prod_config], project_root, bindings)

    Mix.shell().info([:yellow, "* updating file #{path}"])

    content = File.read!(path)

    add_fun = fn content, section ->
      content <> "\n" <> section
    end

    edit_fun = fn content, section, section_name ->
      [before_section, rest] = String.split(content, ~r/\n\n#{section_name}/s, parts: 2)

      rest =
        if String.contains?(rest, "\n\n") do
          [_section, rest] = String.split(rest, "\n\n", parts: 2)
          rest
        else
          ""
        end

      [before_section, section, rest]
      |> Enum.reject(&(&1 == ""))
      |> Enum.join("\n\n")
    end

    updated_content = update_config(@prod_config, content, add_fun, edit_fun)

    File.write!(path, updated_content)
  end

  defp setup_project do
    Mix.shell().info([:green, "* activating mise"])

    System.cmd("mise", ["trust"], env: %{})

    :timer.sleep(1000)

    System.cmd("mise", ["install"], env: %{})

    Mix.shell().info([:green, "* running project setup"])

    System.cmd("mix", ["setup"], env: %{})
  end

  defp setup_git_submodules(project_root, bindings, opts) do
    git_dir = Path.join(project_root, ".git")

    if File.exists?(git_dir) do
      Mix.shell().info([:green, "* setting up git submodules"])

      @git_submodules
      |> inject_bindings(bindings, opts)
      |> String.split("\n")
      |> Stream.map(&String.trim/1)
      |> Stream.reject(&(&1 == ""))
      |> Stream.map(fn line ->
        [url, path] = String.split(line, " ")
        {url, path}
      end)
      |> Enum.each(fn {url, path} ->
        System.cmd("git", ["submodule", "add", url, path], cd: project_root, env: %{})
      end)

      System.cmd("git", ["submodule", "foreach", "git", "pull"], cd: project_root, env: %{})
    else
      Mix.shell().info([:yellow, "* not a git repository, skipping submodules"])
    end
  end

  defp setup_release(project_root) do
    Mix.shell().info([:green, "* generating release"])

    case System.shell("yes 2>/dev/null | mix phx.gen.release") do
      {_output, 0} ->
        patch_app_script(project_root)

      {output, exit_code} ->
        raise """
        mix phx.gen.release failed (exit code: #{exit_code})

        Error output:
        #{output}
        """
    end
  end

  defp patch_app_script(project_root) do
    app_script = Path.join(project_root, "rel/overlays/bin/server")

    Mix.shell().info([:yellow, "* updating file #{app_script}"])

    content = File.read!(app_script)

    updated_content =
      String.replace(
        content,
        "PHX_SERVER=true exec",
        ~S'APP_REVISION=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown") PHX_SERVER=true exec'
      )

    File.write!(app_script, updated_content)
  end

  defp setup_tidewave(project_root, bindings) do
    Mix.shell().info([:green, "* setting up Tidewave"])
    update_endpoint(project_root, bindings)
    show_mcp_proxy_instructions()
  end

  defp update_endpoint(project_root, bindings) do
    app_name = Keyword.fetch!(bindings, :app_name)
    path = Path.join(project_root, "lib/#{app_name}_web/endpoint.ex")

    Mix.shell().info([:yellow, "* updating file #{path}"])

    content = File.read!(path)

    tidewave_plug = """
      if Code.ensure_loaded?(Tidewave) do
        plug Tidewave
      end

    """

    updated_content =
      if String.contains?(content, "plug Tidewave") do
        content
      else
        String.replace(
          content,
          ~r/(  # Code reloading.*)/s,
          tidewave_plug <> "\\1"
        )
      end

    File.write!(path, updated_content)
  end

  defp show_mcp_proxy_instructions do
    if !System.find_executable("mcp-proxy") do
      Mix.shell().info([
        :magenta,
        "* MCP Proxy needs to be installed manually (https://elixirdrops.net/d/UAo4BtYi)"
      ])
    end
  end

  defp generate_github_workflows do
    Mix.shell().info([:green, "* generating github workflows"])

    File.rm_rf!(".github/workflows")
    System.cmd("mix", ["github_workflows.generate"], env: %{})
  end

  defp format_files do
    Mix.shell().info([:green, "* formatting files"])

    System.cmd("mix", ["format"], env: %{})
    System.cmd("mix", ["prettier"], env: %{})
  end
end
