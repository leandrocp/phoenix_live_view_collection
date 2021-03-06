defmodule LiveViewCollectionWeb.CollectionLive do
  @moduledoc "Collection Live Page"
  use LiveViewCollectionWeb, :live_view
  require Logger
  alias LiveViewCollection.Collection

  @impl true
  def mount(_params, _session, socket) do
    current_page = 1
    search = ""
    collection = Collection.fetch(page: current_page, search: search)
    collection_count = Collection.count()

    {:ok,
     assign(socket,
       current_page: current_page,
       search: search,
       collection: collection,
       collection_count: collection_count
     ), temporary_assigns: [collection: []]}
  end

  @impl true
  def handle_event("search", %{"search" => search}, socket) do
    path = Routes.collection_path(socket, :index, search: search, page: 1)
    socket = push_patch(socket, to: path)
    {:noreply, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    search = Map.get(params, "search", "")
    page = params |> Map.get("page", "1") |> String.to_integer()
    collection = Collection.fetch(search: search, page: page)
    {:noreply, assign(socket, collection: collection, search: search, current_page: page, page_title: search)}
  end

  ## Helpers

  def pages(search) do
    Collection.pages(search)
  end
end
