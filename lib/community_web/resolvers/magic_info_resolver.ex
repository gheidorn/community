defmodule CommunityWeb.MagicInfoResolver do
  alias CommunityWeb.MagicInfo

  def cards(_root, _args, _info) do
    {:ok, MagicInfo.cards()}
  end

  def set(_root, args, _info) do
    {:ok, MagicInfo.set(args)}
  end

  def set_of_cards(_root, {:set_code, set_code}, _info) do
    {:ok,
     %MagicSetOfCards{
       set: MagicInfo.set(set_code),
       cards: MagicInfo.cards()
     }}
  end
end
