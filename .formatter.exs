# Used by "mix format"
[
  plugins: [DoctestFormatter],
  inputs: [
    "{mix,.credo,.formatter}.exs",
    ".github/github_workflows.ex",
    "{config,lib,test}/**/*.{ex,exs}"
  ]
]
