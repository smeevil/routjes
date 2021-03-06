Routjes
=======
![](https://img.shields.io/hexpm/v/routjes.svg) ![](https://img.shields.io/hexpm/dt/routjes.svg) ![](https://img.shields.io/hexpm/dw/routjes.svg) ![](https://img.shields.io/github/issues/smeevil/routjes.svg) ![](https://img.shields.io/github/issues-pr/smeevil/routjes.svg)

Routjes is an Elixir library that can extract Phoenix router paths and create a java/typescript module of them.

Routjes is a Dutch / English word. In Dutch there is an habit of referring to normal things as small, we do this by adding 'tje' to the object.
Coincidentally you pronounce Routjes the same as your would in English as "Route JS".

## Getting started

```elixir
defp deps do
  [  {:routjes, "~> 1.0.0"},  ]
end
```

## Settings

Routjes requires a small configuration in your config.exs:

```elixir
config :routjes,
  output_dir: __DIR__ <> "/../assets/js",
  output_file: "routjes.ts",
  router: MyApp.Web.Router,
  end_point: MyApp.Web.Endpoint
```

## Plain Javascript or Typescript
I'd highly recommend to let Routjes generate a typescript source file. You can enable this by making sure the output_file config setting carries the .ts extension.
If you do prefer to use a plain vanilla javascript source file, then ensure the output_file config setting carries the .js extension.

### Usage
Routjes can generate the (type|java)script source files by invoking the mix task :
`mix routjes.generate`

If you like you can also call the function directly by using :
`Routjes.generate()`

If the configuration is successful you will now have your routes available in js :)
An example looks like :

```javascript
    import Routjes from './routjes'

    Routjes.UserIndex().path
    "/users"

    Routjes.ProjectTaskShow({project_id: 1, id: 1})
    "/projects/1/tasks/1"

    Routjes.ProjectTaskShow({project_id: "my-project", id: 7}, {foo: "bar", baz: true}).url
    "http://your.amazing.host:4000/projects/my-project/tasks/7?foo=bar&baz=true"
```

All routes are made into functions to help with autocomplete.

# When using Routjes in umbrella apps

### Settings

When you are using routjes in multiple umbralla apps you need to scope the config in config.exs like so:

```elixir
config :my_app, :routjes,
  output_dir: __DIR__ <> "/../assets/js",
  output_file: "routjes.ts",
  router: MyApp.Web.Router,
  end_point: MyApp.Web.Endpoint
```

### Usage
Then to generate the (type|java)script source files in the umbrella, invoking the mix task with:
`mix routjes.generate my_app`

## License

The Routjes Elixir library is released under the DWTFYW license. See the LICENSE file.
