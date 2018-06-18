defmodule CommunityWeb.Schema do
  use Absinthe.Schema

  alias CommunityWeb.NewsResolver
  alias CommunityWeb.MagicInfoResolver

  object :card do
    field(:multiverse_id, non_null(:integer))
    field(:name, non_null(:string))

    field(:new_key, non_null(:string)) do
      resolve(fn card, _, _ -> {:ok, new_key(card)} end)
    end

    field(:text, non_null(:string))
    field(:image_url, :string)
  end

  object :set do
    field(:code, non_null(:string))
    field(:name, non_null(:string))
    field(:block, :string)
    field(:type, non_null(:string))
    field(:release_date, :string)
  end

  object :link do
    field(:id, non_null(:id))
    field(:url, non_null(:string))
    field(:description, non_null(:string))
  end

  # object :set_of_cards do
  #   field(:set, :set)
  #   field(:cards, :cards)
  # end

  # scalar :set do
  #   parse fn input ->
  #     {:ok, input}
  #   end

  #   serialize fn set ->

  #   end
  # end

  query do
    # this is the query entry point to our app
    field :all_links, non_null(list_of(non_null(:link))) do
      resolve(&NewsResolver.all_links/3)
    end

    field :cards, non_null(list_of(non_null(:card))) do
      resolve(&MagicInfoResolver.cards/3)
    end

    field :set, non_null(:set) do
      arg(:code, :string)
      resolve(&MagicInfoResolver.set/3)
    end

    # field :card_link, list_of(:card_link) do
    # end
  end

  mutation do
    field :create_link, :link do
      arg(:url, non_null(:string))
      arg(:description, non_null(:string))

      resolve(&NewsResolver.create_link/3)
    end
  end

  @doc "used to compute a field in the card object of this schema"
  def new_key(card) do
    Integer.to_string(card.multiverse_id) <> "::" <> card.name
  end
end
