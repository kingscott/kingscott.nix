{ ... }: {
  services.dunst = {
    enable = true;
    settings = {
      global = {
        monitor = 0;
        follow = "mouse";

        width = 300;
        height = 300;
        origin = "top-right";
        offset = "10x50";

        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;

        padding = 8;
        horizontal_padding = 8;
        text_icon_padding = 0;
        frame_width = 2;
        gap_size = 0;
        separator_height = 2;
        separator_color = "frame";

        font = "CaskaydiaMono Nerd Font Mono 12";
        line_height = 0;
        markup = "full";
        format = "<b>%s</b>\\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        word_wrap = true;
        ellipsize = "middle";
        ignore_newline = false;
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = true;

        icon_position = "left";
        min_icon_size = 0;
        max_icon_size = 32;

        sticky_history = true;
        history_length = 20;

        dmenu = "dmenu -p dunst:";
        browser = "xdg-open";
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        corner_radius = 0;
        ignore_dbusclose = false;

        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
      };

      urgency_low = {
        background = "#1f1d2e";
        foreground = "#908caa";
        frame_color = "#1f1d2e";
        timeout = 3;
      };

      urgency_normal = {
        background = "#1f1d2e";
        foreground = "#e0def4";
        frame_color = "#c4a7e7";
        timeout = 3;
      };

      urgency_critical = {
        background = "#1f1d2e";
        foreground = "#e0def4";
        frame_color = "#eb6f92";
        timeout = 0;
      };
    };
  };
}
