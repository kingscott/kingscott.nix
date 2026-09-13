{ ... }:
let
  browser = [ "zen-beta.desktop" ];
  files = [ "org.gnome.Nautilus.desktop" ];
  # okular registers each format under its own okularApplication_* desktop
  # file, not the top-level org.kde.okular.desktop (which only claims okular's
  # own archive format), so PDFs must point at the pdf one specifically.
  pdf = [ "okularApplication_pdf.desktop" ];
  djvu = [ "okularApplication_djvu.desktop" ];
  comic = [ "okularApplication_comicbook.desktop" ];
  images = [ "org.kde.gwenview.desktop" ];
  ebook = [ "calibre-ebook-viewer.desktop" ];
  video = [ "vlc.desktop" ];
  audio = [ "vlc.desktop" ];
  markdown = [ "typora.desktop" ];
  text = [ "org.kde.kate.desktop" ];

  # forEach: give every mime type in `types` the same handler, so the lists
  # below read as "these formats open with X" instead of one line each.
  forEach = types: app: builtins.listToAttrs
    (map (t: { name = t; value = app; }) types);
in
{
  xdg.mimeApps = {
    enable = true;
    defaultApplications =
      # Web
      {
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;
        "x-scheme-handler/chrome" = browser;
        "text/html" = browser;
        "application/x-extension-htm" = browser;
        "application/x-extension-html" = browser;
        "application/x-extension-shtml" = browser;
        "application/xhtml+xml" = browser;
        "application/x-extension-xhtml" = browser;
        "application/x-extension-xht" = browser;
      }
      # File manager: what `xdg-open` on a folder uses.
      // { "inode/directory" = files; }
      # Documents
      // forEach [
        "application/pdf"
        "application/x-gzpdf"
        "application/x-bzpdf"
      ] pdf
      // forEach [
        "application/epub+zip"
        "application/x-mobipocket-ebook"
        "application/x-mobi8-ebook"
        "application/vnd.oasis.opendocument.text"
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
      ] ebook
      // forEach [ "application/x-cbz" "application/x-cbr" ] comic
      // forEach [ "image/vnd.djvu" ] djvu
      # Images
      // forEach [
        "image/png"
        "image/jpeg"
        "image/gif"
        "image/webp"
        "image/tiff"
        "image/bmp"
        "image/svg+xml"
        "image/x-icon"
        "image/heif"
        "image/avif"
      ] images
      # Text / notes
      // forEach [ "text/markdown" "text/x-markdown" ] markdown
      // forEach [ "text/plain" ] text
      # Video
      // forEach [
        "video/mp4"
        "video/x-matroska"
        "video/webm"
        "video/quicktime"
        "video/mpeg"
        "video/x-msvideo"
        "video/x-flv"
        "video/3gpp"
      ] video
      # Audio
      // forEach [
        "audio/mpeg"
        "audio/flac"
        "audio/ogg"
        "audio/opus"
        "audio/x-wav"
        "audio/mp4"
        "audio/aac"
        "audio/x-m4a"
      ] audio;
  };
}
