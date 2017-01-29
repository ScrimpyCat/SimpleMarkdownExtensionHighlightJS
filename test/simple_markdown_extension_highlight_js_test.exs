defmodule SimpleMarkdownExtensionHighlightJSTest do
    use ExUnit.Case
    require SimpleMarkdownExtensionHighlightJS

    SimpleMarkdownExtensionHighlightJS.impl_renderers

    test "Protocols implementations are created" do
        assert :ok = Protocol.assert_impl!(SimpleMarkdown.Renderer.HTML, SimpleMarkdown.Attribute.PreformattedCode.C)
        assert :ok = Protocol.assert_impl!(SimpleMarkdown.Renderer.HTML, SimpleMarkdown.Attribute.PreformattedCode.Elixir)
        assert_raise ArgumentError, fn -> Protocol.assert_impl!(SimpleMarkdown.Renderer.HTML, SimpleMarkdown.Attribute.PreformattedCode.Erlang) end
    end

    test "Renders correctly" do
        assert "<pre><code class=\"c\">test</code></pre>" == SimpleMarkdown.convert("```c\ntest\n```")
        assert "<pre><code class=\"elixir\">test</code></pre>" == SimpleMarkdown.convert("```elixir\ntest\n```")
        assert "<pre><code>test</code></pre>" == SimpleMarkdown.convert("```erlang\ntest\n```")
    end
end
