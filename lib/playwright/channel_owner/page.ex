defmodule Playwright.ChannelOwner.Page do
  use Playwright.ChannelOwner, owned_context: nil

  def new(parent, args) do
    channel_owner(parent, args)
  end

  def click(channel_owner, selector) do
    frame(channel_owner)
    |> Channel.send("click", %{selector: selector})

    channel_owner
  end

  def close(channel_owner) do
    channel_owner |> Channel.send("close")

    if channel_owner.owned_context do
      BrowserContext.close(channel_owner.owned_context)
    end

    channel_owner
  end

  def evaluate(channel_owner, expression) do
    frame(channel_owner)
    |> Channel.send("evaluateExpression", %{
      expression: expression,
      isFunction: true,
      arg: %{
        value: %{v: "undefined"},
        handles: []
      }
    })
    |> case do
      %{"s" => result} ->
        result

      %{"n" => result} ->
        result
    end
  end

  def fill(channel_owner, selector, value) do
    frame(channel_owner) |> Channel.send("fill", %{selector: selector, value: value})
    channel_owner
  end

  def goto(channel_owner, url) do
    frame(channel_owner) |> Channel.send("goto", %{url: url, waitUntil: "load"})
    channel_owner
  end

  def press(channel_owner, selector, key) do
    frame(channel_owner) |> Channel.send("press", %{selector: selector, key: key})
    channel_owner
  end

  def q(channel_owner, selector), do: query_selector(channel_owner, selector)

  def query_selector(channel_owner, selector) do
    frame(channel_owner) |> Channel.send("querySelector", %{selector: selector})
  end

  def query_selector_all(channel_owner, selector) do
    frame(channel_owner) |> Channel.send("querySelectorAll", %{selector: selector})
  end

  def set_viewport_size(channel_owner, params) do
    channel_owner |> Channel.send("setViewportSize", %{"viewportSize" => params})
    channel_owner
  end

  def text_content(channel_owner, selector) do
    frame(channel_owner) |> Channel.send("textContent", %{selector: selector})
  end

  def title(channel_owner) do
    frame(channel_owner) |> Channel.send("title")
  end

  # private
  # ---------------------------------------------------------------------------

  defp frame(channel_owner) do
    Connection.get(channel_owner.connection, {:guid, channel_owner.initializer["mainFrame"]["guid"]})
  end
end
