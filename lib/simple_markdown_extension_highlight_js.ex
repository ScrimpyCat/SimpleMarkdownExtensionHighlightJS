defmodule SimpleMarkdownExtensionHighlightJS do
    @moduledoc """
      Generates HTML renderer implementations for all supported languages
      that were provided in the config.

      Configuration options are as follows:

      * `:source` - Set the source (path or URL) to the highlight.js
      file that will be used. It will read the languages used within
      it.
      * `:include` - Include any additional languages the extension
      should support.
      * `:exclude` - Exclude any languages from the extension.

      ###Example

        config :simple_markdown_extension_highlight_js,
            source: Path.join(__DIR__, "highlight.pack.js"),
            include: ["c"],
            exclude: ["erlang"]

      Finally implement the renderers using `impl_renderers/0`.

      ###Note

      This extension assumes the default HTML rendering behaviour
      for `SimpleMarkdown.Attribute.PreformattedCode` has not been
      overriden.

      If it has then the new implementation must pass the call to
      `SimpleMarkdown.Attribute.PreformattedCode.*`. Where `*` is
      replaced with the supported language.

      Otherwise if it has not overriden the implementation, then
      no extra work is needed.
    """

    @doc """
      Implement the HTML renderers for the provided code snippets
    """
    defmacro impl_renderers() do
        source = Application.get_env(:simple_markdown_extension_highlight_js, :source)

        code = if source != nil do
            case File.read(source) do
                { :ok, code } -> code
                { :error, :enoent } ->
                    HTTPoison.start
                    HTTPoison.get!(source).body
            end
        else
            ""
        end

        includes = Application.get_env(:simple_markdown_extension_highlight_js, :include, [])
        excludes = Application.get_env(:simple_markdown_extension_highlight_js, :exclude, [])

        languages = Regex.scan(~r/((?<=registerLanguage\(")|(?<=registerLanguage\(\\"))[^\\"]*/, code)
        |> Enum.map(fn [lang|_] -> lang end)
        |> Enum.concat(includes)
        |> Enum.uniq
        |> Enum.filter(&(!Enum.any?(excludes, fn lang -> &1 == lang end)))

        for lang <- languages do
            quote do
                defimpl SimpleMarkdown.Renderer.HTML, for: unquote(String.to_atom("Elixir.SimpleMarkdown.Attribute.PreformattedCode.#{String.capitalize(lang)}")) do
                    def render(%{ input: input }), do: SimpleMarkdownExtensionHighlightJS.render(input, unquote(lang))
                end
            end
        end
    end

    @doc false
    def render(input, lang), do: "<pre><code class=\"#{lang}\">#{SimpleMarkdown.Renderer.HTML.render(input) |> HtmlEntities.encode}</code></pre>"
end
