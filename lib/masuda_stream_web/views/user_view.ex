defmodule MasudaStreamWeb.UserView do
  use MasudaStreamWeb, :view

  def render("index.json", %{user: user}) do
    %{
      user: %{
        user: user.identifier,
        name: user.display_name,
        avatar_url: user.icon
      }
    }
  end
end
