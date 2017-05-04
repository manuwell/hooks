defmodule Hooks.Router do
  use Hooks.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
  end

  # Other scopes may use custom stacks.
  scope "/api", Hooks do
    pipe_through :api

    get     "/:id", Api.HookHandlerController, :handler
    post    "/:id", Api.HookHandlerController, :handler
    put     "/:id", Api.HookHandlerController, :handler
    delete  "/:id", Api.HookHandlerController, :handler
    patch   "/:id", Api.HookHandlerController, :handler
    options "/:id", Api.HookHandlerController, :handler
  end

  # Other scopes may use custom stacks.
  scope "/", Hooks do
    pipe_through :browser

    resources     "/", HooksController, only: [:new, :create, :show]

    get "/", HooksController, :new
  end
end
