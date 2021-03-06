# shell/java.sh

export DKO_SOURCE="${DKO_SOURCE} -> shell/java.sh {"

export GRADLE_USER_HOME="${XDG_CONFIG_HOME}/gradle"

export UNCRUSTIFY_CONFIG="${DOTFILES}/uncrustify/uncrustify"

# Ruby use brew openssl if available
if __dko_has 'jenv'; then
  DKO_SOURCE="${DKO_SOURCE} -> jenv"
  eval "$(jenv init -)"

else
  __java_version="1.9"
  [ -x '/usr/libexec/java_home' ] \
    && JAVA_HOME="$(/usr/libexec/java_home -v"$__java_version" 2>/dev/null)"
  [ -n "$JAVA_HOME" ] \
    && export JAVA_HOME \
    && export PATH="${JAVA_HOME}/bin:${PATH}"
fi

# java settings - mostly for minecraft launcher
alias jgui="_JAVA_OPTIONS=\"-Dawt.useSystemAAFontSettings=on \\ \
  -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel \\ \
  -Dswing.systemlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel\" \\ \
  JAVA_FONTS=\"/usr/share/fonts/TTF\" java"

export DKO_SOURCE="${DKO_SOURCE} }"
