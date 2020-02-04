---
---

### Mix CLI

mix is the elixir command line tool.

* mix test <test_file_path>


### make a console app

in mix.esx add this to the list

> escript: [main_module: Commandline.CLI]

Make a module called Commandline.CLI and define a function main/1

now you can run "mix escript.build". this pops out an executable you can run

### elixir package manager

Called HEX

https://hex.pm/

### elixir map dependencies

mix xref graph 

### Credo

in mix.exs deps

      {:credo, "~> 0.3", only: [:dev, :test], runtime: false}

run mix credo

generate config file 

> mix credo.gen.config