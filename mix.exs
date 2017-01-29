defmodule SimpleMarkdownExtensionHighlightJS.Mixfile do
    use Mix.Project

    def project do
        [
            app: :simple_markdown_extension_highlight_js,
            description: "An extension for SimpleMarkdown to add a renderers for code snippets to add highlighting when using highlight.js.",
            version: "0.0.1",
            elixir: "~> 1.3",
            build_embedded: Mix.env == :prod,
            start_permanent: Mix.env == :prod,
            consolidate_protocols: Mix.env != :test,
            deps: deps,
            package: package
        ]
    end

    # Configuration for the OTP application
    #
    # Type `mix help compile.app` for more information
    def application do
        [applications: [:logger, :simple_markdown, :html_entities]]
    end

    # Dependencies can be Hex packages:
    #
    #   {:mydep, "~> 0.3.0"}
    #
    # Or git/path repositories:
    #
    #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
    #
    # Type `mix help deps` for more examples and options
    defp deps do
        [
            { :simple_markdown, "~> 0.2.1" },
            { :html_entities, "~> 0.3" },
            { :httpoison, "~> 0.9" },
            { :ex_doc, "~> 0.13", only: :dev }
        ]
    end

    defp package do
        [
            maintainers: ["Stefan Johnson"],
            licenses: ["BSD 2-Clause"],
            links: %{ "GitHub" => "https://github.com/ScrimpyCat/SimpleMarkdownExtensionHighlightJS" }
        ]
    end
end
