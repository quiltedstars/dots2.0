cd $(dirname $0)

function exe () {
    local cmd=$@
    if ! pgrep -x $cmd; then
        $cmd &
    fi
}

exe picom --config=./picom/picom.conf -b
#exe xfce4-panel
exe $HOME/.config/awesome/scripts/redshift.sh restore
exe xinput set-prop --type=int --format=8 "ELAN0412:01 04F3:3162 Touchpad" "Synaptics Tap Action" 1 1 1 2 1 3
exe conky -c ~/.config/conky/minimalismRC -d


xrdb merge $HOME/.Xresources

