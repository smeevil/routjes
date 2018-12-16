defmodule RoutjesTest do
  use ExUnit.Case
  doctest Routjes


  test "at can parse routes" do
    routes = [
      %Phoenix.Router.Route{
        helper: "project",
        opts: :index,
        path: "/projects",
      },
      %Phoenix.Router.Route{
        helper: "project",
        opts: :edit,
        path: "/projects/:id/edit",
      },
      %Phoenix.Router.Route{
        helper: "project",
        opts: :new,
        path: "/projects/new",
      },
      %Phoenix.Router.Route{
        helper: "project",
        opts: :show,
        path: "/projects/:id",
      }
    ]

    assert %{
             "ProjectEdit" => %{
               args: ["id"],
               path: "/projects/:id/edit"
             },
             "ProjectIndex" => %{
               args: [],
               path: "/projects"
             },
             "ProjectNew" => %{
               args: [],
               path: "/projects/new"
             },
             "ProjectShow" => %{
               args: ["id"],
               path: "/projects/:id"
             }
           } == Enum.reduce(routes, %{}, &Routjes.parse(&1, &2))
  end
end
