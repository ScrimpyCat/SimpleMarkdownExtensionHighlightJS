defmodule SimpleMarkdownExtensionHighlightJSTest do
    use ExUnit.Case

    test "Protocols implementations are created" do
        imps = Protocol.extract_impls(SimpleMarkdown.Renderer.HTML, [:code.lib_dir(:simple_markdown_extension_highlight_js, :ebin)])
        assert true == Enum.any?(imps, &(&1 == SimpleMarkdown.Attribute.PreformattedCode.C))
        assert true == Enum.any?(imps, &(&1 == SimpleMarkdown.Attribute.PreformattedCode.Elixir))
        assert false == Enum.any?(imps, &(&1 == SimpleMarkdown.Attribute.PreformattedCode.Erlang))
    end

    test "Renders correctly" do
        assert "<pre><code class=\"c\">test</code></pre>" == SimpleMarkdown.convert("```c\ntest\n```")
        assert "<pre><code class=\"elixir\">test</code></pre>" == SimpleMarkdown.convert("```elixir\ntest\n```")
        assert "<pre><code>test</code></pre>" == SimpleMarkdown.convert("```erlang\ntest\n```")
    end
end
