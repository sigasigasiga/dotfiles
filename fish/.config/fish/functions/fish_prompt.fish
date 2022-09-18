function fish_prompt --description 'Write out the prompt'
    set -l last_pipestatus $pipestatus
    set -l normal_color (set_color normal)
    set -l user_color (set_color -o yellow)

    # Color the prompt differently when we're root
    set -l pwd_color $fish_color_cwd
    set -l prefix
    set -l suffix '>'
    if contains -- $USER root toor
        if set -q fish_color_cwd_root
            set pwd_color $fish_color_cwd_root
        end
        set suffix '#'
    end

    # If we're running via SSH, change the host color.
    set -l host_color (set_color magenta)
    if set -q SSH_TTY
        set host_color (set_color cyan)
    end

    # Write pipestatus
    set -l prompt_status (__fish_print_pipestatus " [" "]" "|" (set_color $fish_color_status) (set_color --bold $fish_color_status) $last_pipestatus)

    # default prompt
    echo -n -s \
        "$user_color$USER$normal_color@$host_color$hostname" $normal_color ' '      (: user@host)       \
        (set_color $pwd_color) (prompt_pwd -d 0) $normal_color                      (: ~/path/name)     \
        (fish_vcs_prompt) $normal_color                                             (: git branch name) \
        $prompt_status \n                                                           (: exit code)       \
        $suffix " "                                                                 (: '>' prompt)
end
