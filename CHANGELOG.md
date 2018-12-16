
## 1.1.0 (2018-12-16)
### Config changed
The configuration of routjes can now be scoped under the umbrella name.
  Previously the config would sit in its own scope like
  ```elixir
  config :routjes, ...
  ```
  This will still work so we are backwards compatible.

  The problem with this config is, when used in umbrella apps, the last umbrella app loaded would override the config of all other apps.
  To mitigate this Routjes config can now be scoped within your app config like
  ```elixir
  config :my_app, :routjes, ...
  ```

  Then you can run the mix tasks with the name of the umbrella
  ```elixir
  mix routjes.generate my_app
  ```

## 1.0.0 (2018-12-04)

  - Initial commit
