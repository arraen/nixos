{
  config,
  pkgs,
  lib,
  inputs',
  ...
}: {
  # Fonts
  fonts.packages = with pkgs; [
    iosevka
    liberation_ttf
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    source-code-pro
    uiua386
    (nerdfonts.override { fonts = [ "SourceCodePro" ]; })
  ];
}
