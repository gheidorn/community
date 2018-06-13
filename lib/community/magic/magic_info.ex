defmodule CommunityWeb.MagicInfo do

    def types() do
        %{body: body} = HTTPoison.get! "https://api.magicthegathering.io/v1/types"
        %{types: types} = Poison.decode! body, keys: :atoms
    end

end