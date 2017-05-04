defmodule Hooks.Api.HookHandlerController do
  use Hooks.Web, :controller
  alias Exredis.Api, as: Redis

  def handler(conn, %{"id" => id}) do
    headers = for e <- conn.req_headers, into: %{}, do: e
    raw_body = conn.private[:raw_body]

    key = [id, "request", request_id] |> Enum.join(":")
    requests_key = [id, "requests"] |> Enum.join(":")

    response = %{
      headers: headers,
      raw_body: raw_body
    }

    Redis.append(:redis,
      requests_key,
      [key, "|"] |> Enum.join
    )
    content = response |> Poison.encode!
    Redis.set(:redis, key, content)

    conn
    |> send_resp(200, "")
  end

  defp request_id do
    UUID.uuid4()
    |> String.split("-")
    |> List.first
  end
end
