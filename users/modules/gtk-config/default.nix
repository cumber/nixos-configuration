{ pkgs, ... }:
{
  gtk = {
    enable = true;

    theme = {
      package = pkgs.graphite-gtk-theme.override { tweaks = [ "nord" ]; };
      name = "Graphite-Light-nord";
    };
    iconTheme = {
      package = pkgs.tela-icon-theme;
      name = "Tela-blue-light";
    };
    cursorTheme = {
      package = pkgs.graphite-cursors;
      name = "graphite-light";
    };
    font = {
      name = "Overpass Regular";
      size = 12;
    };

    gtk4.extraCss = ''
      /* Graphite theme styles subtitles black, but when they're in a row that
         is selected the background is dark, so override to be more readable */
      .navigation-sidebar > row:selected label.subtitle {
        color: rgba(255, 255, 255, 0.6);
      }
    '';
  };
}
