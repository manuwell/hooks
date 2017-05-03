require IEx

defmodule Hooks.Api.HookHandlerControllerTest do
  use Hooks.ConnCase, async: true

  test "index/2 responds with all Users" do
    response = build_conn
    |> put_req_header("accept", "application/json")
    |> get(hook_handler_path(build_conn, :handler, "123"))
    |> json_response(200)

    expected = %{
      "headers" => %{ "accept" => "application/json" },
      "raw_body" => ""
    }

    assert response == expected
  end
end
