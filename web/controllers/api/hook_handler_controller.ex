defmodule Hooks.Api.HookHandlerController do
  use Hooks.Web, :controller

  def handler(conn, _params) do
    headers = for e <- conn.req_headers, into: %{}, do: e
    raw_body = conn.private[:raw_body]

    response = %{
      headers: headers,
      raw_body: raw_body
    }
    json conn, response
  end
end
