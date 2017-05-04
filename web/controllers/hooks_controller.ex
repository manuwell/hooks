require IEx

defmodule Hooks.HooksController do
  use Hooks.Web, :controller
  alias Exredis.Api, as: Redis

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, _params) do
    id = UUID.uuid4()
         |> String.split("-")
         |> List.first
    id_requests = [id, "requests"]
    |> Enum.join(":")

    Redis.set(:redis, id, DateTime.utc_now)
    Redis.set(:redis, id_requests, "")

    conn
    |> redirect(to: hooks_path(conn, :show, id: id))
  end

  def show(conn, %{"id" => id}) do
    ids = Redis.get(:redis, [id, "requests"] |> Enum.join(":"))
          |> String.split("|")
          |> List.delete_at(-1)

    responses = Redis.mget(:redis, ids)
    json conn, %{ "responses" => responses }
  end
end
