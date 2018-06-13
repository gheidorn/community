defmodule CommunityWeb.MagicInfo do
  def types() do
    %{body: body} = HTTPoison.get!("https://api.magicthegathering.io/v1/types")
    %{types: types} = Poison.decode!(body, keys: :atoms)
  end

  def cards() do
    %{body: body} = HTTPoison.get!("https://api.magicthegathering.io/v1/cards")
    %{cards: cards} = Poison.decode!(body, keys: :atoms)
  end

  def card(id) do
    %{body: body} = HTTPoison.get!("https://api.magicthegathering.io/v1/cards/#{id}")
    Poison.decode!(body)
  end

  def artist(card_id) do
    %{body: body} = HTTPoison.get!("https://api.magicthegathering.io/v1/cards/#{id}")
    Poison.decode!(body)
  end
end
