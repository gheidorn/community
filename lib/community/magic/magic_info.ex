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
    url = "https://api.magicthegathering.io/v1/cards/#{card_id}"
    IO.puts(url)

    conn = nil

    # check cache for response
    case Redix.start_link(
           "redis://h:pfaceab4fb17b1fb2bb6b14c4f0667fc5fe8f3e70d6366b571b6e90b7e3db9cea@ec2-18-207-82-91.compute-1.amazonaws.com:13169",
           name: :redix
         ) do
      {:ok, the_conn} -> conn = the_conn
      {:error, reason} -> IO.puts("error")
    end

    IO.puts("trying to find card:#{card_id} in cache")
    {:ok, val} = Redix.command(conn, ["GET", "card:#{card_id}"])

    if val do
      IO.puts("found #{val}")
    else
      IO.puts("card:#{card_id} not found")
    end

    # nothing in cache?  call the api
    %{body: body} = HTTPoison.get!(url)
    artist = Poison.decode!(body)["card"]["artist"]

    Redix.pipeline(conn, [["SET", "card:#{card_id}", artist], ["GET", "card:#{card_id}"]])
  end
end
