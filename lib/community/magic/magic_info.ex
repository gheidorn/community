defmodule CommunityWeb.MagicInfo do
  @moduledoc """
  Acts as a client to the Magic The Gathering APIs at api.magicthegathering.io.

  Functions typically return structs.

  ## Examples

      iex> CommunityWeb.MagicInfo.card(123)
      %MagicCard{
        image_url: "http://gatherer.wizards.com/Handlers/Image.ashx?multiverseid=123&type=card",
        multiverse_id: 123,
        name: "Psychic Venom",
        text: "Enchant land\nWhenever enchanted land becomes tapped, Psychic Venom deals 2 damage to that land's controller."
      }     

  """

  def types() do
    %{body: body} = HTTPoison.get!("https://api.magicthegathering.io/v1/types")
    Poison.decode!(body)
  end

  def cards() do
    %{body: body} = HTTPoison.get!("https://api.magicthegathering.io/v1/cards?pageSize=5")
    cards = Poison.decode!(body)["cards"]

    for card <- cards do
      %MagicCard{
        multiverse_id: card["multiverseid"],
        name: card["name"],
        text: card["text"],
        image_url: card["imageUrl"]
      }
    end
  end

  def cards_by_set(set) do
    %{body: body} =
      HTTPoison.get!("https://api.magicthegathering.io/v1/cards?set=#{set}&pageSize=5")

    cards = Poison.decode!(body)["cards"]

    for card <- cards do
      %MagicCard{
        multiverse_id: card["multiverseid"],
        name: card["name"],
        text: card["text"],
        image_url: card["imageUrl"]
      }
    end
  end

  def set(%{code: code}) do
    %{body: body} = HTTPoison.get!("https://api.magicthegathering.io/v1/sets/#{code}")
    set = Poison.decode!(body)["set"]

    %MagicSet{
      code: set["code"],
      name: set["name"],
      type: set["type"],
      block: set["block"],
      release_date: set["releaseDate"]
    }
  end

  def card(id) do
    %{body: body} = HTTPoison.get!("https://api.magicthegathering.io/v1/cards/#{id}")
    card = Poison.decode!(body)["card"]

    %MagicCard{
      multiverse_id: card["multiverseid"],
      name: card["name"],
      text: card["text"],
      image_url: card["imageUrl"]
    }
  end

  def artist(card_id) do
    url = "https://api.magicthegathering.io/v1/cards/#{card_id}"
    IO.puts(url)

    # check cache for response
    conn =
      case Redix.start_link(
             "redis://h:pfaceab4fb17b1fb2bb6b14c4f0667fc5fe8f3e70d6366b571b6e90b7e3db9cea@ec2-18-207-82-91.compute-1.amazonaws.com:13169",
             name: :redix
           ) do
        {:ok, the_conn} -> the_conn
        {:error} -> IO.puts("error")
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
