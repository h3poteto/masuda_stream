defmodule MasudaStreamWeb.UserView do
  use MasudaStreamWeb, :view

  def render("index.json", %{auth: auth}) do
    %{
      user: %{
        user: auth.info.name,
        name: auth.info.nickname,
        avatar_url: auth.extra.raw_info.user["profile_image_url"]
      }
    }
  end
end
