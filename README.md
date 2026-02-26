# super-trucs

**Attention pauvre fou ! Tout ceci est encore en cours de développement.**

Ce répo contient des supers trucs !

Il me sert à centraliser mes fichiers de configuration ainsi que les différents
outils que j'utilise (et comment les installer !).

Chaque section est relativement indépendante des autres, mais l'ordre permet une
progression agréable si l'on part d'un OS (Ubuntu 24.04) ...

## Firefox

Installer les extensions qui vont bien - UBlock, 1password, Proton VPN, etc.
J'ai eu des problèmes quand `apt` et `snap` coexistent.

## Terminal

Installation de [Ghostty](https://ghostty.org/) et [Starship](https://starship.rs/), zéro configuration à prévoir.

## Gestionnaire de versions

Installation de [Mise-en-place](https://mise.jdx.dev/) puis de `pipx` via ce super outil.

```text
# malin !
mise use -g pipx@latest
pipx ensurepath
```

## Github

Installation de LFS, configuration globale, création de la clé SSH, etc.

```bash
sudo apt install git-lfs

git config --global user.name "Your Name"
git config --global user.email "your_email@example.com"
git config --global help.autocorrect 13

ssh-keygen -t ed25519 -C "your_email@example.com"
eval "$(ssh-agent -s)"
ssh-add .ssh/id_github

ssh -T git@github.com
```

On n'hésitera pas à utiliser un fichier de configuration (`~/.ssh/config`) pour
affiner:

```text
# Default
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_github
    IdentitiesOnly yes

# Alias for other accounts
Host github.com-other
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_github_other
    IdentitiesOnly yes
```

## Clavier

On va aller installer Kalamine, puis build le layout (de ce repo) et le mettre
au bon endroit.

Cette étape est bien sur optionnelle pour tout clavier normal ...

```bash
pipx install kalamine
kalamine build layout.toml
sudo cp dist/custom.xkb_symbols ${XKB_CONFIG_ROOT:-/usr/share/X11/xkb}/symbols/custom
```

On va également installer `brightnessctl` et faire la configuration nécessaire
(autrement les boutons lié à la luminosité vont pas marcher avec Niri).

```bash
sudo apt update brightnessctl
sudo usermod -aG video $USER
sudo usermod -aG input $USER
```

Puis on ajoute ça dans `/etc/udev/rules.d/90-backlight.rules`

```text
ACTION=="add", SUBSYSTEM=="backlight", RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness"
ACTION=="add", SUBSYSTEM=="backlight", RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"
ACTION=="add", SUBSYSTEM=="leds", RUN+="/bin/chgrp input /sys/class/leds/%k/brightness"
ACTION=="add", SUBSYSTEM=="leds", RUN+="/bin/chmod g+w /sys/class/leds/%k/brightness"
```

## Wayland-verse

Bon c'est parti pour le gros du travail.

### Niri

Installation via le PPA de `glostis`.

```bash
sudo add-apt-repository ppa:glostis/danklinux
sudo apt update
sudo apt install niri
```

### Outils disponible via `apt`

Si seulement ça pouvait toujours être aussi facile ...

```bash
sudo apt install swaylock swayidle fuzzel mako-notifier
```

### Waybar

Normalement ça se build bien (voir les instructions du [repo](https://github.com/Alexays/Waybar)).

```bash
# Clone et checkout de la version la plus à jour
git clone git@github.com:Alexays/Waybar.git
cd Waybar
git checkout 0.15.0

# Installer tout ce qu'il faut pour build (voir le repo pour le reste)
sudo apt install cmake meson scdoc wayland-protocols

# Build
meson setup build
ninja -C build install
```

### Waypaper

Franchement c'est ridicule qu'installer [cet outil](https://github.com/anufrievroman/waypaper)
soit si complexe, j'hésite sèrieusement à vibecoder une alternative.

```bash
# mon dieu
sudo apt install \
    python3.12-venv \
    python3-dev \
    pkg-config \
    python3-pip \
    python3-imageio \
    python3-screeninfo \
    python3-platformdirs \
    python3-gi \
    python3-gi-cairo \
    libcairo2-dev \
    gir1.2-gtk-4.0 \
    libgirepository-2.0-dev \
    swaybg
pipx install waypaper
```

### Fonts

Normalement il suffit de choper les [Nerd Fonts](https://www.nerdfonts.com/)
pour JetBrainsMono. Normalement ...

```bash
cd Downloads/JetBrainsMono
sudo cp *ttf /usr/local/share/fonts/
sudo fc-cache -fv

fc-list | grep -i "JetBrainsMonoNerd"
```

### Configuration

Ouvrir une session Niri, puis lancer le script `setup_niri.sh` pour placer les
fichiers de configuration au bon endroit, et créer les services systemd pour
démarrer les outils au bon moment. Lancer `waypaper` pour mettre un fond d'écran
et on est bon !

## Visual Studio Code

Mon éditeur de code _bloated_ de choix, voir la [documentation](https://code.visualstudio.com/docs/setup/linux).

## Utilitaires en vrac

Quelques bon bails à avoir:

```bash
sudo apt install vim tree blueman pavucontrol mkcert
```
