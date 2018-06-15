defmodule CommunityWeb.Schema do
  use Absinthe.Schema

  alias CommunityWeb.NewsResolver
  alias CommunityWeb.MagicInfoResolver

  object :card do
    field(:multiverse_id, non_null(:integer))
    field(:name, non_null(:string))
    field(:text, non_null(:string))
  end

  object :link do
    field(:id, non_null(:id))
    field(:url, non_null(:string))
    field(:description, non_null(:string))
  end

  query do
    # this is the query entry point to our app
    field :all_links, non_null(list_of(non_null(:link))) do
      resolve(&NewsResolver.all_links/3)
    end

    field :cards, non_null(list_of(non_null(:card))) do
      resolve(&MagicInfoResolver.cards/3)
    end
  end

  mutation do
    field :create_link, :link do
      arg(:url, non_null(:string))
      arg(:description, non_null(:string))

      resolve(&NewsResolver.create_link/3)
    end
  end
end
