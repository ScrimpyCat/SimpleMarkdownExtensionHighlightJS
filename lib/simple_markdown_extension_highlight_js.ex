defmodule SimpleMarkdownExtensionHighlightJS do
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
        end |> Code.eval_quoted
    end

    @doc false
    def render(input, lang), do: "<pre><code class=\"#{lang}\">#{SimpleMarkdown.Renderer.HTML.render(input) |> HtmlEntities.encode}</code></pre>"
end
