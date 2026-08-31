{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  # https://devenv.sh/languages/
  languages.elm = {
    enable = true;
    lsp.enable = true;
  };

  packages = with pkgs; [
    elmPackages.elm-json
    elmPackages.elm-spa
    elmPackages.elm-live
  ];

  # https://devenv.sh/processes/
  processes = {
    server.exec = "elm-live src/Main.elm --open --  --output gen/source.js";
  };

  scripts = {
    build.exec = ''
      elm make src/Main.elm --output gen/source.js --optimize
    '';
  };

  enterShell = ''
    echo "Elm $(elm --version)"
    echo "Run build to rebuild"
    echo "Run 'devenv up -d' to start elm-live at port 8000"
  '';

  # See full reference at https://devenv.sh/reference/options/
}
