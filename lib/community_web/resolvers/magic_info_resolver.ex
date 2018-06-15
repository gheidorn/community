defmodule CommunityWeb.MagicInfoResolver do
  alias CommunityWeb.MagicInfo

  def cards(_root, _args, _info) do
    cards = MagicInfo.cards()

    IO.inspect(cards)
    {:ok, cards}
  end
end
