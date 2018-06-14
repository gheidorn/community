defmodule CommunityWeb.PageController do
  use CommunityWeb, :controller
  import CommunityWeb.MagicInfo

  def index(conn, _params) do
    CommunityWeb.MagicInfo.artist(4)

    render(conn, "index.html")
  end
end
