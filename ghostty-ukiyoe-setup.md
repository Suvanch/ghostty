# Ghostty Ukiyo-e Terminal Setup

A complete record and rebuild guide for my customized Ghostty terminal on Linux Mint: an ink-wash / ukiyo-e theme with a painted intro of tonight's real moon phase, a darkened Hokusai background, live system info, Japanese quotes, a washi-paper shader and a vermilion brush-stroke cursor trail.

*Created 2026-10-19 · Ghostty 1.3.1 · fastfetch 2.70.0 · Linux Mint 22.3 (Cinnamon, X11)*

---

## Contents

0. [About this folder](#0-about-this-folder)
1. [Purpose](#1-purpose)
2. [Summary of what was done](#2-summary-of-what-was-done)
3. [The final result](#3-the-final-result)
4. [How it all fits together](#4-how-it-all-fits-together)
5. [Rebuild on a new PC](#5-rebuild-on-a-new-pc-step-by-step)
6. [Full file contents](#6-full-file-contents)
7. [Customizing](#7-customizing)
8. [Troubleshooting](#8-troubleshooting)
9. [Reverting](#9-reverting)

---

## 0. About this folder

This guide lives in `~/Desktop/Projects/ghostty-terminal/` together with a copy of every file that was created or changed for the setup. The copy was taken on 2026-10-20. The `files/` folder mirrors where each file goes, using visible names (`config` instead of `.config`) so nothing is hidden in the file manager:

```
ghostty-terminal/
├── ghostty-ukiyoe-setup.md          # this guide
└── files/
    ├── config/                      # → ~/.config/
    │   ├── ghostty/                 #   config, themes/, shaders/, backgrounds/ (prints + sumi_tone.py),
    │   │                            #   config.backup (original), neon-backup/ (first neon version)
    │   ├── fastfetch/               #   config.jsonc, quotes.txt, moon-logo.txt + moon-phase.txt (regenerated
    │   │                            #   on every run), ghost/fish/totoro-logo.txt (earlier unused art drafts)
    │   └── starship.toml            # → ~/.config/starship.toml
    ├── local/bin/term-intro         # → ~/.local/bin/term-intro
    └── bashrc-additions.sh          # the block appended to the end of ~/.bashrc
```

**Not included** (download them instead): the Ghostty, fastfetch and Starship programs (Steps 1, 4, 4b) and the JetBrainsMono font (Step 2, 233 MB). They're platform-specific and newer versions are better.

**Keeping the copy current:** this folder is a snapshot. The live files are the ones in `~/.config` and `~/.local/bin`. After changing the live setup, refresh the copy by running the cp commands from Step 7 in reverse, for example `cp -a ~/.config/ghostty/. files/config/ghostty/`.

---

## 1. Purpose

I had just installed Ghostty and the default look was plain. The goal was to make it look like the setups people share online, with custom colors, fonts, a theme and GPU shaders, and an animated ASCII picture next to system stats ("performance logs") when a terminal opens.

After a first neon version, I changed the direction to something **clean and minimal**, styled after **Ukiyo-e / traditional Japanese art**: classical ink-wash painting (sumi-e), woodblock prints and hanging scrolls, like the anime *Mononoke* and *Katanagatari*.

This document has two jobs:
- record what was changed and why
- give step-by-step instructions to rebuild the exact same setup on a new PC

---

## 2. Summary of what was done

The work went through these stages, in order:

| # | Stage | What happened |
|---|-------|---------------|
| 1 | **Inspection** | Found Ghostty 1.3.1 with a basic config (Catppuccin Mocha, Ubuntu Mono). No Nerd Font, no fastfetch (only the older neofetch). |
| 2 | **Tools installed** | Installed **JetBrainsMono Nerd Font** (programming font with icon glyphs) and **fastfetch 2.70.0** (fast system-info tool). Both went into the home folder, so no `sudo` was needed. |
| 3 | **Neon version** | TokyoNight theme, transparency, a neon *bloom* shader, a glowing cursor trail and an animated ghost logo with fastfetch. It worked, but I wanted a different style. It's saved in `neon-backup/`. |
| 4 | **Ukiyo-e redesign** | Two custom themes (**Washi** light paper, **Sumi** dark scroll), a **washi paper** shader, a **brush-stroke** cursor trail, a hand-built **ink-wash Mount Fuji** intro that "soaks in" like ink, and a minimal fastfetch layout with **kanji labels**. |
| 5 | **Dark mode** | Switched the default to **Sumi** and darkened its background to near-black `#121110`. |
| 6 | **Visible brush trail** | The first trail loaded fine but was too faint to notice. It was rebuilt as a bold smear of the whole cursor block with bristle streaks. |
| 7 | **Japanese quotes** | Added a random haiku or proverb under the painting each time a terminal opens, written one character at a time. |
| 8 | **Prompt & background** | Installed **Starship 1.27.0** with a minimal kanji-marked prompt, and set Hokusai's *Red Fuji* print as a faint background image behind the text. *The Great Wave* is downloaded as an alternative. |
| 9 | **Readable background** | The print's white clouds made text hard to read. A small Python script now makes darkened, color-muted copies that are extra dim on the text side, keeping Fuji visible as a deep vermilion silhouette. |
| 10 | **Moon & darker tones** | Replaced the Fuji intro art with a waxing **harvest moon** (名月) in muted gold. Darkened the background further (`STRENGTH` 0.22 → 0.14). Changed the paper shader so its grain only darkens: on black, the old lighten-and-darken grain looked like grey slate. |
| 11 | **Live moon & adjustable brightness** | The moon is now **white and shows the real phase** for tonight, computed offline from the date, oriented for your hemisphere (from the timezone). It's labeled with the traditional Japanese name of the phase (新月, 三日月, 上弦, 十三夜, 満月, 十六夜, 下弦, 有明), and a 月 *moon* line was added to the system info. The background turned out too dark, so the image is now made brighter (`STRENGTH` 0.35) and dimmed in the config with `background-image-opacity = 0.6`. That turns brightness into a single number you can change and reload, with no script re-runs. |

---

## 3. The final result

When a Ghostty window opens:

```
        ·····▟████▙▄▄▖              suvanch · suvanch
      ······███████████▄            ━━━━━━━━━━  ━━━━  ━
    ·······▐▓▓██▓▓███████▖   十     機  os      Linux Mint 22.3
   ········▓▓████▓████▓▓██▖  三     核  kernel  7.0.0-38-generic
   ········██████▓▓▓▓██████  夜     時  uptime  1 day, 5 hours, 18 mins
   ········█████████▓▓▓████         包  pkgs    2348
   ········▓▓▓████████████▘         殻  shell   bash 5.2.21
    ·······▐█████████████▘   墨
      ······███████████▀            脳  cpu     11th Gen Intel(R) Core(TM) i7-1165G7  57.0°C
        ·····▜████▛▀▀▘              憶  memory  7.60 GiB / 11.48 GiB
    ━━━━━━━━━      ━━━━━━━━         蔵  disk    62.12 GiB / 467.89 GiB
         ━━━━━━━━━━━     ━━━━       電  power   23%
                                    月  moon    waxing gibbous  十三夜 · 67% lit

    古池や蛙飛び込む水の音
    furuike ya kawazu tobikomu mizu no oto
    An old pond, a frog jumps in, the sound of water.  — Bashō
```

(This sample is from 20 Oct 2026, a waxing gibbous. In the real terminal the lit moon is white, the `▓` maria (its "seas") are pale grey, and the `·` shadowed part is a faint solid dark disk, like earthshine. The 墨 seal is vermilion, the mist is grey and the phase name, here 十三夜 "thirteenth night", is ink. The shape changes every night.)

**Feature list:**

| Feature | Details |
|---|---|
| **Theme** | *Sumi*: pale paper-colored ink on a near-black scroll (`#121110`), with traditional Japanese accent colors: shu (vermilion), koke (moss), kuchiba (ochre), ai (indigo), budō (plum), seiheki (teal). A light *Washi* theme is also included. |
| **Font** | JetBrainsMono Nerd Font 13pt. Japanese falls back to Noto Serif CJK JP, a brush-like Mincho style. |
| **Window** | Fully opaque, wide margins like a scroll (28×20 px padding). |
| **Cursor** | A still vermilion block. Shell integration is told not to turn it into a bar. |
| **Paper shader** | Fine grain and faint horizontal paper fibers that only *darken* (deep ink mottling rather than grey slate), slightly soft ink edges, darker corners like an aged scroll. It's static and doesn't flicker. |
| **Brush trail shader** | When the cursor jumps, the block smears to its new spot like a loaded brush, with bristle streaks, then dries up over 0.3 s. |
| **Intro animation** | Tonight's real moon is painted in stages. The faint shadowed disk appears first, then light soaks in from the bright edge toward the terminator, mist is brushed in left to right, the phase's traditional name appears vertically, and finally the 墨 seal is stamped. Lit cells go `░ → ▒ → final` like ink soaking into paper. About 1.5 s; any key skips it. |
| **Moon phase** | Computed offline from the date (mean synodic month, accurate to within about half a day). Northern hemisphere: a waxing moon is lit on the right. In southern-hemisphere timezones the moon is drawn rotated 180°, as it's seen there. Eight phase names: 新月 new, 三日月 crescent, 上弦 first quarter, 十三夜 "13th night" (waxing gibbous), 満月 full, 十六夜 *izayoi* (waning gibbous), 下弦 last quarter, 有明 *ariake* "dawn moon" (waning crescent). |
| **System info** | fastfetch with one vermilion kanji per line: 機 machine, 核 kernel, 時 time, 包 packages, 殻 shell, 脳 brain (CPU), 憶 memory, 蔵 storehouse (disk), 電 electricity (battery), 月 moon (tonight's phase and % lit). |
| **Quote** | A random haiku or proverb from a text file, in Japanese, then romaji, then English and the source. |
| **Background** | Hokusai's *Fine Wind, Clear Morning* ("Red Fuji", public domain), heavily darkened and muted to ink tones, extra dim on the left behind the text. Fuji shows as a faint deep-vermilion silhouette on the right. |
| **Prompt** | Starship, two lines: the folder in bold, then grey kanji markers only when relevant: 枝 git branch, 蛇 Python version, 時 time a slow command took, 錠 read-only folder. Git changes show in ochre. The `›` arrow is grey normally and vermilion after a failed command. |

---

## 4. How it all fits together

```
Ghostty starts
 ├─ reads ~/.config/ghostty/config
 │    ├─ theme = Sumi            → ~/.config/ghostty/themes/Sumi
 │    ├─ font-family ×3          → JetBrainsMono Nerd Font, then Noto CJK for kanji
 │    └─ custom-shader ×2        → brush_trail.glsl, then washi_paper.glsl (run in order on the GPU)
 └─ launches bash
      └─ ~/.bashrc (last block) → only if interactive + inside Ghostty + not yet shown
           └─ ~/.local/bin/term-intro
                ├─ computes tonight's moon phase (awk, offline)
                ├─ writes the finished painting to ~/.config/fastfetch/moon-logo.txt
                │    and the phase line to ~/.config/fastfetch/moon-phase.txt
                ├─ plays the ink-soak animation (skippable)
                ├─ moves the cursor back up and runs fastfetch
                │    └─ ~/.config/fastfetch/config.jsonc uses moon-logo.txt as its logo,
                │       so the info appears beside the exact same painting
                └─ prints a random line from ~/.config/fastfetch/quotes.txt
           └─ starship init bash  → every prompt is drawn by Starship from ~/.config/starship.toml
```

**Design notes:**
- **The ink uses theme colors, the moon uses fixed RGB.** The inscription is the default foreground, the mist is ANSI color 8 and the seal is ANSI color 1, so they follow the theme. The moon's white, sea grey and shadow are exact truecolor values (`MOON_LIGHT`, `MOON_SEA`, `MOON_DARK`) so it stays white in any theme.
- **The moon is drawn, not stored.** Each character cell is split into 2×2 sub-pixels using quadrant blocks (`▘ ▝ ▖ ▗ ▀ ▄ ▌ ▐ ▙ ▟ ▛ ▜ █`), which gives a smooth round edge. The lit side is decided per sub-pixel from the phase angle. Where a cell straddles the terminator, the lit quadrants are drawn in white on a shadow-colored background.
- **The animation draws in the same place fastfetch will.** The script draws the painting, moves the cursor back to where it started and lets fastfetch draw the identical final frame with stats beside it. The handoff is seamless.
- **Every line of the painting must be exactly 30 columns wide**, matching `"width": 30` in the fastfetch config. Kanji are 2 columns wide, so rows with kanji have one less character.

### Files at a glance

```
~/.config/ghostty/
├── config                      # main Ghostty settings
├── themes/
│   ├── Sumi                    # dark theme (active)
│   └── Washi                   # light theme
├── backgrounds/
│   ├── red-fuji-sumi.jpg       # darkened print (active)
│   ├── great-wave-sumi.jpg     # darkened alternative
│   ├── red-fuji.jpg            # original print
│   ├── great-wave.jpg          # original print
│   └── sumi_tone.py            # script that makes the darkened copies
├── shaders/
│   ├── brush_trail.glsl        # cursor brush-stroke trail (active)
│   ├── washi_paper.glsl        # paper texture (active)
│   ├── bloom.glsl              # old neon glow (unused)
│   └── cursor_trail.glsl       # old neon trail (unused)
├── config.backup               # original config from before any changes
└── neon-backup/                # complete first (neon) version

~/.config/fastfetch/
├── config.jsonc                # system-info layout with kanji labels
├── quotes.txt                  # Japanese quotes, one per line
├── moon-logo.txt               # generated automatically by term-intro
└── moon-phase.txt              # tonight's phase line, also generated by term-intro

~/.config/starship.toml          # prompt layout

~/.local/bin/
├── term-intro                  # animation + fastfetch + quote script
├── fastfetch                   # fastfetch program
└── starship                    # Starship program

~/.local/share/fonts/JetBrainsMono/   # Nerd Font files
~/.bashrc                             # last blocks run term-intro and start Starship
```

---

## 5. Rebuild on a new PC (step by step)

These steps assume Linux Mint / Ubuntu on an x86_64 machine with bash. Run each command in a terminal. Every command block explains what it does first.

> **Different username?** Two files contain the full path `/home/suvanch/`: the Ghostty `config` (shader paths) and the fastfetch `config.jsonc` (logo path). After copying them in, Step 9 replaces the username automatically.

### Step 1 — Install Ghostty

Ghostty isn't in Mint's default repositories. Follow the Linux instructions at **https://ghostty.org/download**. For Ubuntu-based systems like Mint, those instructions point to a community-maintained `.deb` package. Check it installed:

```bash
ghostty --version
```

### Step 2 — Install the JetBrainsMono Nerd Font

What it does: downloads the font zip from the official Nerd Fonts GitHub releases, extracts only the `.ttf` files into your personal font folder (no `sudo`), and refreshes the font cache so apps can see them. The last line should print a number, about 48.

```bash
mkdir -p ~/Downloads/nerdfont ~/.local/share/fonts/JetBrainsMono
curl -L -o ~/Downloads/nerdfont/JetBrainsMono.zip \
  https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip -o ~/Downloads/nerdfont/JetBrainsMono.zip '*.ttf' -d ~/.local/share/fonts/JetBrainsMono
fc-cache -f
fc-list | grep -c "JetBrainsMono Nerd Font"
```

### Step 3 — Make sure Japanese fonts are installed

What it does: lists installed Japanese fonts. Mint usually ships Noto CJK. If the list is empty, install the package with `apt`. This one needs `sudo`.

```bash
fc-list :lang=ja family | sort -u
# If nothing is listed:
sudo apt install fonts-noto-cjk
```

### Step 4 — Install fastfetch

What it does: downloads the official prebuilt fastfetch for x86_64 Linux, unpacks it and copies only the program into `~/.local/bin` (no `sudo`). For the newest version, check https://github.com/fastfetch-cli/fastfetch/releases and change `2.70.0`.

```bash
mkdir -p ~/Downloads/fastfetch ~/.local/bin
curl -L -o ~/Downloads/fastfetch/ff.tar.gz \
  https://github.com/fastfetch-cli/fastfetch/releases/download/2.70.0/fastfetch-linux-amd64.tar.gz
tar -xzf ~/Downloads/fastfetch/ff.tar.gz -C ~/Downloads/fastfetch
install -m755 "$(find ~/Downloads/fastfetch -type f -name fastfetch -path '*bin*' | head -1)" ~/.local/bin/fastfetch
~/.local/bin/fastfetch --version
```

Make sure `~/.local/bin` is on your PATH. Mint usually includes it, but if `fastfetch --version` (without the path) fails, add this line to the end of `~/.bashrc`:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

### Step 4b — Install Starship (the prompt)

What it does: downloads the official prebuilt Starship for x86_64 Linux from GitHub, unpacks it and copies the program into `~/.local/bin` (no `sudo`).

```bash
mkdir -p ~/Downloads/starship
curl -L -o ~/Downloads/starship/starship.tar.gz \
  https://github.com/starship/starship/releases/latest/download/starship-x86_64-unknown-linux-gnu.tar.gz
tar -xzf ~/Downloads/starship/starship.tar.gz -C ~/Downloads/starship
install -m755 ~/Downloads/starship/starship ~/.local/bin/starship
starship --version
```

### Step 5 — Create the folders

What it does: creates every folder the setup uses. `-p` means it does nothing if a folder already exists.

```bash
mkdir -p ~/.config/ghostty/themes ~/.config/ghostty/shaders ~/.config/ghostty/backgrounds ~/.config/fastfetch ~/.local/bin
```

### Step 5b — Download the background prints

What it does: downloads two public-domain Hokusai woodblock prints from Wikimedia Commons as 1920-pixel-wide JPEGs. `-A` sends a short description of the request, which Wikimedia asks for. `file` confirms both are real JPEG images.

```bash
UA="ghostty-wallpaper-setup/1.0 (personal use)"
curl -L -A "$UA" -o ~/.config/ghostty/backgrounds/red-fuji.jpg \
  "https://commons.wikimedia.org/wiki/Special:FilePath/Red_Fuji_southern_wind_clear_morning.jpg?width=1920"
curl -L -A "$UA" -o ~/.config/ghostty/backgrounds/great-wave.jpg \
  "https://commons.wikimedia.org/wiki/Special:FilePath/Tsunami_by_hokusai_19th_century.jpg?width=1920"
file ~/.config/ghostty/backgrounds/*
```

### Step 5c — Make the dark "sumi" versions of the prints

The original prints are far too bright behind text. This step makes darkened, color-muted copies that are extra dim on the left, where text sits. First create `~/.config/ghostty/backgrounds/sumi_tone.py` with the contents of [Section 6.11](#611-background-darkening-script). It needs Python's image library (PIL), which Mint includes; if it's missing, run `sudo apt install python3-pil`. Then:

What it does: runs the script on each print, writing `*-sumi.jpg` next to the original plus a preview with sample text into `/tmp`. The originals aren't changed.

```bash
cd ~/.config/ghostty/backgrounds
python3 -I sumi_tone.py red-fuji.jpg red-fuji-sumi.jpg /tmp/preview-fuji.png
python3 -I sumi_tone.py great-wave.jpg great-wave-sumi.jpg /tmp/preview-wave.png
```

### Step 6 — Back up any existing Ghostty config

What it does: if a config already exists, saves a copy so you can go back.

```bash
[ -f ~/.config/ghostty/config ] && cp ~/.config/ghostty/config ~/.config/ghostty/config.backup
```

### Step 7 — Create the files

**Fast way: copy them from this folder.** If you have the `ghostty-terminal` folder on the new PC, run this from inside it (`cd` into the folder first). It copies the configs, themes, shaders, prints, intro script and prompt into place. If you use this, skip Steps 5b and 5c too, because the darkened prints are already included:

```bash
mkdir -p ~/.config ~/.local/bin
cp -a files/config/ghostty files/config/fastfetch ~/.config/
cp -a files/config/starship.toml ~/.config/
cp -a files/local/bin/term-intro ~/.local/bin/
```

`cp -a` keeps file dates and the executable permission. It overwrites files of the same name, so do Step 6 (backup) first. Then continue with Step 8.

**Manual way:** create each file below with the exact contents from **[Section 6](#6-full-file-contents)**. Use any text editor, for example `xed ~/.config/ghostty/config` on Mint or `nano`.

| File | Section |
|---|---|
| `~/.config/ghostty/config` | [6.1](#61-ghostty-config) |
| `~/.config/ghostty/themes/Sumi` | [6.2](#62-sumi-theme-dark-active) |
| `~/.config/ghostty/themes/Washi` | [6.3](#63-washi-theme-light) |
| `~/.config/ghostty/shaders/brush_trail.glsl` | [6.4](#64-brush-trail-shader) |
| `~/.config/ghostty/shaders/washi_paper.glsl` | [6.5](#65-washi-paper-shader) |
| `~/.local/bin/term-intro` | [6.6](#66-intro-script) |
| `~/.config/fastfetch/config.jsonc` | [6.7](#67-fastfetch-config) |
| `~/.config/fastfetch/quotes.txt` | [6.8](#68-quotes) |
| `~/.config/starship.toml` | [6.10](#610-starship-prompt) |

> Tip: copy each code block exactly. Characters such as `▟ ░ ━ 富` and the spaces inside the painting matter.

### Step 8 — Make the intro script executable

What it does: lets `term-intro` run as a program.

```bash
chmod +x ~/.local/bin/term-intro
```

### Step 9 — Fix the username in paths (only if your username isn't `suvanch`)

What it does: `sed -i` replaces `/home/suvanch/` with your own home folder inside the two files that contain full paths.

```bash
sed -i "s#/home/suvanch/#$HOME/#g" ~/.config/ghostty/config ~/.config/fastfetch/config.jsonc
```

### Step 10 — Run the intro and Starship when a terminal opens

What it does: adds the blocks from [Section 6.9](#69-bashrc-block) to the end of `~/.bashrc`. Nothing else in the file is changed. Then `bash -n` checks the file for syntax errors. (From this folder, `cat files/bashrc-additions.sh >> ~/.bashrc` does the same thing.)

```bash
cat >> ~/.bashrc <<'EOF'

# Ghostty intro: ink-wash moon + fastfetch system info + quote (remove to disable)
if [[ $- == *i* && $TERM_PROGRAM == ghostty && -z $TERM_INTRO_SHOWN ]] && command -v term-intro >/dev/null; then
    export TERM_INTRO_SHOWN=1
    term-intro
fi

# Starship prompt (config: ~/.config/starship.toml)
command -v starship >/dev/null && eval "$(starship init bash)"
EOF
bash -n ~/.bashrc && echo "bashrc syntax OK"
```

Starship goes **last** so it controls the prompt. It only runs if Starship is installed, so `.bashrc` keeps working without it.

The block runs `term-intro` only when all three are true:
- the shell is **interactive**, so scripts are unaffected
- you're **inside Ghostty**, so other terminals and VS Code are unaffected
- it **hasn't already run** in this window, so typing `bash` again doesn't replay it

### Step 11 — Check and launch

What it does: `+validate-config` checks the Ghostty config for mistakes without opening a window. Then `term-intro` is run once by hand to check the painting and fastfetch.

```bash
ghostty +validate-config && echo "CONFIG OK"
term-intro
```

Now **fully close and reopen Ghostty**. You should see the animation, the stats and a quote.

### Step 12 — Confirm the shaders loaded

What it does: searches the system log for Ghostty's shader messages. You want two `loaded custom shader` lines and no `error`.

```bash
journalctl --user --since "10 min ago" | grep -i ghostty | grep -i shader
```

---

## 6. Full file contents

### 6.1 Ghostty config
`~/.config/ghostty/config`
```ini
# Ukiyo-e / ink-wash setup. Previous neon setup is in neon-backup/

# --- Theme ---
# Washi = ink on paper, Sumi = dark scroll (both in themes/)
# To follow the system light/dark mode: theme = light:Washi,dark:Sumi
theme = Sumi
background-opacity = 1
window-theme = ghostty

# --- Background print (Hokusai, public domain; files in backgrounds/) ---
# *-sumi.jpg are pre-darkened copies (dimmer on the left where text sits).
# Swap to great-wave-sumi.jpg for The Great Wave.
background-image = /home/suvanch/.config/ghostty/backgrounds/red-fuji-sumi.jpg
# BACKGROUND BRIGHTNESS: 0 = plain black ... 1 = brightest. Save, then Ctrl+Shift+, to see it.
# (Need brighter than 1? Raise STRENGTH in backgrounds/sumi_tone.py and re-run it.)
background-image-opacity = 0.6
background-image-fit = cover
background-image-position = center

# --- Font ---
font-family = "JetBrainsMono Nerd Font"
font-family = "Noto Serif CJK JP"
font-family = "Noto Sans CJK JP"
font-size = 13
adjust-cell-height = 12%

# --- Window: wide margins like a scroll ---
window-padding-x = 28
window-padding-y = 20
window-padding-balance = true
window-width = 110
window-height = 30
unfocused-split-opacity = 0.9

# --- Cursor: a vermilion block, still ---
cursor-style = block
cursor-style-blink = false
shell-integration-features = no-cursor

# --- Behavior ---
mouse-hide-while-typing = true
confirm-close-surface = false

# --- Shaders (applied in order; comment a line out to disable) ---
# PAPER TEXTURE strength (the "slate"): GRAIN, FIBERS, VIGNETTE at the top of washi_paper.glsl
custom-shader = /home/suvanch/.config/ghostty/shaders/brush_trail.glsl
custom-shader = /home/suvanch/.config/ghostty/shaders/washi_paper.glsl
custom-shader-animation = true
```

**What each section does:**
- **Theme:** `theme = Sumi` loads `themes/Sumi`. `window-theme = ghostty` colors the title bar to match the theme.
- **Background print:** points at the pre-darkened `red-fuji-sumi.jpg` (Step 5c). That image is made at a brightness ceiling (`STRENGTH` 0.35), and `background-image-opacity` (0.6) dims it from there. **This is the brightness knob:** 0 = black, 1 = the ceiling. Using the bright original even at low opacity made the white clouds wash out the text, which is why the darkened copy is used. `cover` fills the window without stretching (edges may be cropped). These options need Ghostty 1.2 or newer.
- **Font:** the first `font-family` is the main font. The next two are fallbacks for characters it lacks (kanji). `adjust-cell-height` adds line spacing for a calmer look.
- **Window:** padding gives the scroll-like margins. `window-padding-balance` centers the text grid.
- **Cursor:** `shell-integration-features = no-cursor` stops Ghostty from turning the block into a bar at the prompt.
- **Shaders:** they run in the order listed: the trail first, then paper texture over everything. `custom-shader-animation = true` lets the trail animate.

### 6.2 Sumi theme (dark, active)
`~/.config/ghostty/themes/Sumi`
```ini
# Sumi: paper-white ink on an ink-black scroll
background = #121110
foreground = #e3d9c3
cursor-color = #d0563f
cursor-text = #121110
selection-background = #332e27
selection-foreground = #f2ead8

palette = 0=#24211c
palette = 1=#d0563f
palette = 2=#8f9e62
palette = 3=#c9a04f
palette = 4=#6d8bab
palette = 5=#a5849e
palette = 6=#739f99
palette = 7=#c8bead
palette = 8=#7d7466
palette = 9=#e06d52
palette = 10=#a6b475
palette = 11=#dcb563
palette = 12=#85a2c0
palette = 13=#b99ab2
palette = 14=#8ab5ae
palette = 15=#f2ead8
```

### 6.3 Washi theme (light)
`~/.config/ghostty/themes/Washi`
```ini
# Washi: sumi ink on unbleached rice paper
background = #efe5cf
foreground = #2d2924
cursor-color = #b8432f
cursor-text = #f5eddc
selection-background = #d9ccb0
selection-foreground = #2d2924

# sumi, shu (vermilion), koke (moss), kuchiba (ochre), ai (indigo), budō (plum), seiheki (teal), kinari
palette = 0=#2d2924
palette = 1=#b8432f
palette = 2=#5e7046
palette = 3=#a8781f
palette = 4=#2f4f6f
palette = 5=#7a4f6e
palette = 6=#3d6e6a
palette = 7=#c9bea8
palette = 8=#7a6f5f
palette = 9=#c9573f
palette = 10=#6f8250
palette = 11=#b8892c
palette = 12=#3f6386
palette = 13=#8c6080
palette = 14=#4f807b
palette = 15=#f7f0e1
```

**Palette meaning** (ANSI color numbers that programs use):

| # | Role | Traditional color |
|---|---|---|
| 0 / 8 | black / grey (comments, wash) | sumi ink |
| 1 / 9 | red (errors, the sun, the seal) | shu, vermilion |
| 2 / 10 | green | koke, moss |
| 3 / 11 | yellow | kuchiba, ochre |
| 4 / 12 | blue | ai, indigo |
| 5 / 13 | magenta | budō, plum |
| 6 / 14 | cyan | seiheki, blue-green |
| 7 / 15 | white | kinari, unbleached silk |

### 6.4 Brush trail shader
`~/.config/ghostty/shaders/brush_trail.glsl`
```glsl
// Brush trail: the cursor block smears from its old position to its new one
// like a loaded brush, with bristle streaks, then the tail dries up.

const float DURATION = 0.3;  // seconds the stroke stays visible
const float OPACITY = 0.85;
const int STEPS = 24;        // samples along the stroke

float hash(float n) {
    return fract(sin(n * 91.345) * 47453.5453);
}

// Signed distance to a box centered at the origin
float sdBox(vec2 p, vec2 halfSize) {
    vec2 d = abs(p) - halfSize;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

vec2 cursorCenter(vec4 c) {
    // xy = top-left corner (y grows upward), zw = width/height
    return c.xy + vec2(c.z, -c.w) * 0.5;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec4 term = texture(iChannel0, fragCoord / iResolution.xy);
    fragColor = term;

    float progress = (iTime - iTimeCursorChange) / DURATION;
    if (progress >= 1.0) return;

    vec2 head = cursorCenter(iCurrentCursor);
    vec2 tail = cursorCenter(iPreviousCursor);
    vec2 ba = head - tail;
    float len = length(ba);
    if (len < 1.0) return;

    vec2 halfSize = iCurrentCursor.zw * 0.5;
    vec2 dir = ba / len;

    // Sweep the cursor box along the stroke; the brush is thinner at the tail
    // and the tail retracts toward the head as time passes
    float start = smoothstep(0.0, 1.0, progress);
    float d = 1e9;
    for (int i = 0; i <= STEPS; i++) {
        float s = mix(start, 1.0, float(i) / float(STEPS));
        vec2 size = halfSize * mix(0.35, 1.0, s);
        d = min(d, sdBox(fragCoord - (tail + ba * s), size));
    }

    float alpha = 1.0 - smoothstep(-1.0, 1.0, d);

    // Bristle streaks run along the stroke direction
    float across = dot(fragCoord - tail, vec2(-dir.y, dir.x));
    alpha *= 0.55 + 0.45 * hash(floor(across * 0.6));

    // Ink runs out: fade over time, and more toward the tail
    float along = clamp(dot(fragCoord - tail, dir) / len, 0.0, 1.0);
    alpha *= (1.0 - progress) * mix(0.5, 1.0, along);

    // Never paint over the cursor cell itself
    if (sdBox(fragCoord - head, halfSize) < 0.0) alpha = 0.0;

    fragColor = vec4(mix(term.rgb, iCurrentCursorColor.rgb, alpha * OPACITY), term.a);
}
```

How it works: Ghostty gives every shader the cursor's current and previous rectangles (`iCurrentCursor`, `iPreviousCursor`) and the time it last moved (`iTimeCursorChange`). For each pixel, the shader measures the distance to the cursor box swept along the path from old to new position. The box shrinks toward the tail, and the tail pulls in toward the head as time passes. Pixels inside the stroke are tinted with the cursor color and broken into "bristle" streaks by a hash of their position across the stroke. After `DURATION` seconds it returns early and costs nothing.

### 6.5 Washi paper shader
`~/.config/ghostty/shaders/washi_paper.glsl`
```glsl
// Washi paper: static grain and fibers, a touch of ink bleed, aged scroll edges.
// The texture only darkens, so on a dark theme it reads as deep ink mottling.

// Tweak these, save, then Ctrl+Shift+, in Ghostty. 0.0 turns an effect off.
const float BLEED = 0.12;     // how much glyph edges soften into the paper (0 - 0.3)
const float GRAIN = 0.020;    // fine speckle; higher = darker, rougher (0 - 0.08)
const float FIBERS = 0.028;   // long paper fibers; higher = darker streaks (0 - 0.10)
const float VIGNETTE = 0.30;  // darker edges like an old scroll (0 - 0.8)

float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i), hash(i + vec2(1, 0)), f.x),
               mix(hash(i + vec2(0, 1)), hash(i + vec2(1, 1)), f.x), f.y);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec2 px = 1.0 / iResolution.xy;
    vec4 color = texture(iChannel0, uv);

    vec3 blur = (texture(iChannel0, uv + vec2(px.x, 0)).rgb +
                 texture(iChannel0, uv - vec2(px.x, 0)).rgb +
                 texture(iChannel0, uv + vec2(0, px.y)).rgb +
                 texture(iChannel0, uv - vec2(0, px.y)).rgb) * 0.25;
    vec3 col = mix(color.rgb, blur, BLEED);

    // Fibers run mostly horizontally, slightly tilted, at two scales
    mat2 tilt = mat2(0.97, 0.24, -0.24, 0.97);
    vec2 fp = tilt * fragCoord;
    float fibers = noise(fp * vec2(0.015, 0.22)) * 0.6 + noise(fp * vec2(0.04, 0.5)) * 0.4;
    float grain = hash(floor(fragCoord));
    col = max(col - grain * GRAIN - fibers * FIBERS, 0.0);

    vec2 q = uv - 0.5;
    col *= 1.0 - dot(q, q) * VIGNETTE;

    fragColor = vec4(col, color.a);
}
```

How it works: it blends each pixel slightly with its four neighbors (ink bleed), *subtracts* per-pixel random grain and stretched value-noise (paper fibers, tilted a few degrees), and darkens toward the corners (vignette). Because the texture only subtracts, it never lightens the black background into a grey "slate" look. Nothing depends on time, so the paper never shimmers.

### 6.6 Intro script
`~/.local/bin/term-intro`
```bash
#!/usr/bin/env bash
# Ink-wash moon intro showing tonight's real phase, then fastfetch draws the
# finished painting beside system info. The shadowed disk appears first, the lit
# part soaks in from its bright edge, then the phase name and seal. Any key skips.
#
# The phase is computed offline from the date. Your hemisphere (which side is lit,
# and whether the moon looks upside-down) comes from your timezone; override it
# with MOON_HEMISPHERE=south or MOON_HEMISPHERE=north. Preview another night with
# MOON_DATE=2026-12-24 term-intro (any date `date -d` understands).

LOGO_FILE="$HOME/.config/fastfetch/moon-logo.txt"
PHASE_FILE="$HOME/.config/fastfetch/moon-phase.txt"  # read by fastfetch's 月 line
FRAMES=36
DELAY=0.04
PAD="  "  # must match fastfetch logo padding.left

ESC=$'\e'
RST="${ESC}[0m"
MOON_LIGHT="${ESC}[38;2;240;236;228m"  # lit surface (white)
MOON_SEA="${ESC}[38;2;168;163;152m"    # maria, the darker "seas"
MOON_DARK="${ESC}[38;2;46;43;38m"      # unlit part, faint earthshine
DARK_BG="${ESC}[48;2;46;43;38m"
INK="${ESC}[39m"                       # theme foreground
WASH="${ESC}[90m"                      # pale grey wash
SHU="${ESC}[31m"                       # vermilion
SEAL="${ESC}[41;97m"                   # white on vermilion

# Traditional names for the eight phases, shown vertically beside the moon
NAME_JP=(新月 三日月 上弦 十三夜 満月 十六夜 下弦 有明)
NAME_EN=("new moon" "waxing crescent" "first quarter" "waxing gibbous"
         "full moon" "waning gibbous" "last quarter" "waning crescent")
MIST=(
"  ━━━━━━━━━      ━━━━━━━━     "
"       ━━━━━━━━━━━     ━━━━   "
)
QUAD=(" " ▘ ▝ ▀ ▖ ▌ ▞ ▛ ▗ ▚ ▐ ▜ ▄ ▙ ▟ █)  # index = UL 1 + UR 2 + LL 4 + LR 8

hemisphere() {
    local tz
    [[ -n $MOON_HEMISPHERE ]] && { echo "$MOON_HEMISPHERE"; return; }
    tz=$(cat /etc/timezone 2>/dev/null || readlink /etc/localtime)
    tz=${tz#*zoneinfo/}
    if [[ $tz =~ ^(Australia|Antarctica)/|^Pacific/(Auckland|Chatham|Fiji|Tongatapu|Apia|Noumea)|^America/(Argentina|Santiago|Sao_Paulo|Montevideo|Asuncion|La_Paz|Lima)|^Africa/(Johannesburg|Maputo|Harare|Lusaka|Windhoek|Gaborone|Maseru|Mbabane)|^Indian/(Mauritius|Reunion) ]]; then
        echo south
    else
        echo north
    fi
}

# Prints "phase illum% litside", then for each of 10 rows three 24-cell strings:
# lit quadrant mask, disk quadrant mask (hex digits) and maria flags (1/0)
moon_cells() {
    awk -v now="$(date -d "${MOON_DATE:-now}" +%s)" -v south="$([[ $(hemisphere) == south ]] && echo 1 || echo 0)" '
    function sea(x, y,   i) {
        for (i = 1; i <= 8; i++)
            if (((x - mx[i]) / rx[i]) ^ 2 + ((y - my[i]) / ry[i]) ^ 2 <= 1) return 1
        return 0
    }
    function bits(m) { return m % 2 + int(m / 2) % 2 + int(m / 4) % 2 + int(m / 8) }
    BEGIN {
        # Maria as ellipses on the near side, as seen from the northern hemisphere
        split("-0.30 0.18 0.32 0.68 0.55 -0.58 -0.18 -0.45", mx, " ")
        split("0.45 0.42 0.12 0.33 -0.15 0.05 -0.38 -0.42", my, " ")
        split("0.24 0.14 0.18 0.09 0.10 0.22 0.15 0.08", rx, " ")
        split("0.20 0.13 0.15 0.10 0.15 0.38 0.12 0.08", ry, " ")

        # Moon age as a fraction of the synodic month since the new moon of 2000-01-06 18:14 UTC
        pi = atan2(0, -1)
        age = (now / 86400 + 2440587.5 - 2451550.1) / 29.530588853
        age -= int(age); if (age < 0) age += 1
        k = cos(2 * pi * age); waxing = age < 0.5
        # New, quarter and full moons last about a day either side; the rest are in between
        split("0.034 0.216 0.284 0.466 0.534 0.716 0.784 0.966", edge, " ")
        for (phase = 0; phase < 8 && age >= edge[phase + 1]; phase++);
        phase %= 8
        side = (waxing != south) ? 1 : -1   # 1 = bright limb on the right
        printf "%d %d %d\n", phase, (1 - k) / 2 * 100 + 0.5, side

        # 24 cols x 10 rows of 2x2 sub-cells; terminal cells are ~2.4x taller than wide
        for (r = 0; r < 10; r++) {
            lit = disk = mar = ""
            for (c = 0; c < 24; c++) {
                lm = dm = 0
                for (q = 0; q < 4; q++) {
                    x = (2 * c + q % 2 + 0.5 - 24) / 24
                    y = (10 - (2 * r + int(q / 2)) - 0.5) / 10
                    if (x * x + y * y > 1) continue
                    dm += 2 ^ q
                    fx = south ? -x : x
                    w = sqrt(1 - y * y)
                    if (waxing ? fx > k * w : fx < -k * w) lm += 2 ^ q
                }
                # A rim cell can only hold one color: keep its round outline, in
                # whichever of light or shadow covers most of it
                if (dm < 15 && lm) lm = (bits(lm) * 2 >= bits(dm)) ? dm : 0
                x = (2 * c + 1 - 24) / 24; y = (10 - 2 * r - 1) / 10
                if (south) { x = -x; y = -y }
                lit = lit sprintf("%x", lm); disk = disk sprintf("%x", dm)
                mar = mar (lm == 15 && sea(x, y) ? 1 : 0)
            }
            print lit, disk, mar
        }
    }'
}

# Lay out every cell once: K kind, CH char, ST style, T frame it lands on,
# and for lit moon cells D/TD, the shadowed version shown before the light arrives.
# Kinds: p row padding, n row end, s space, d drawn at once, g graded ░ ▒ final,
#        k wide kanji (grey first), w wide drawn at once
N=0
add() { K[N]=$1 CH[N]=$2 ST[N]=$3 T[N]=$4 D[N]=$5 TD[N]=$6; ((N++)); }

layout() {
    local r c lm dm j t td name nlen kr lit disk mar
    { read -r PHASE ILLUM SIDE
      for ((r = 0; r < 10; r++)); do read -r lit disk mar; LIT[r]=$lit DISK[r]=$disk MAR[r]=$mar; done
    } < <(moon_cells)
    name=${NAME_JP[PHASE]} nlen=${#name}

    for ((r = 0; r < 10; r++)); do
        add p
        add s
        for ((c = 0; c < 24; c++)); do
            lm=$((16#${LIT[r]:c:1})) dm=$((16#${DISK[r]:c:1}))
            j=$(((c * 7 + r * 13) % 4))
            td=$((1 + j))
            if ((dm == 0)); then
                add s
            elif ((lm == 0)); then
                add d "${QUAD[dm]}" "$MOON_DARK" "$td"
            else
                # The light soaks in from the bright limb toward the terminator
                ((SIDE > 0)) && t=$((6 + (23 - c) * 3 / 4 + j / 2)) || t=$((6 + c * 3 / 4 + j / 2))
                if ((${MAR[r]:c:1})); then
                    add g █ "$MOON_SEA" "$t" "$MOON_DARK█$RST" "$td"
                elif ((lm < 15 && dm == 15)); then
                    add g "${QUAD[lm]}" "$MOON_LIGHT$DARK_BG" "$t" "$MOON_DARK█$RST" "$td"
                else
                    add g "${QUAD[lm]}" "$MOON_LIGHT" "$t" "$MOON_DARK${QUAD[dm]}$RST" "$td"
                fi
            fi
        done
        add s; add s
        kr=$((r - 2))
        if ((kr >= 0 && kr < nlen)); then
            add k "${name:kr:1}" "$INK" $((26 + kr * 2))
        elif ((r == 7)); then
            add w 墨 "$SEAL" 32
        else
            add s; add s
        fi
        add s
        add n
    done

    for ((r = 0; r < ${#MIST[@]}; r++)); do
        add p
        for ((c = 0; c < ${#MIST[r]}; c++)); do
            if [[ ${MIST[r]:c:1} == " " ]]; then
                add s
            else
                add d ━ "$WASH" $((12 + c / 3 + (c * 7 + r * 13) % 4))
            fi
        done
        add n
    done
}

# render <frame> <left pad> <line end>; a frame past the last stroke draws the finished art
render() {
    local f=$1 pad=$2 eol=$3 out="" i age
    for ((i = 0; i < N; i++)); do
        case ${K[i]} in
            p) out+=$pad; continue ;;
            n) out+="$eol"$'\n'; continue ;;
            s) out+=" "; continue ;;
        esac
        age=$((f - T[i]))
        if ((age < 0)); then
            if [[ -n ${D[i]} ]] && ((f >= TD[i])); then
                out+=${D[i]}
            elif [[ ${K[i]} == [kw] ]]; then
                out+="  "
            else
                out+=" "
            fi
        elif [[ ${K[i]} == k ]] && ((age < 2)); then
            out+="${WASH}${CH[i]}${RST}"
        elif [[ ${K[i]} == g ]] && ((age < 2)); then
            ((age == 0)) && out+="${ST[i]}░${RST}" || out+="${ST[i]}▒${RST}"
        else
            out+="${ST[i]}${CH[i]}${RST}"
        fi
    done
    printf '%s' "$out"
}

(
    export LC_ALL=C.UTF-8 # count block and kanji characters as single chars
    layout
    H=12
    mkdir -p "${LOGO_FILE%/*}"
    render 999 "" "" >"$LOGO_FILE"
    printf '%s  %s · %s%% lit\n' "${NAME_EN[PHASE]}" "${NAME_JP[PHASE]}" "$ILLUM" >"$PHASE_FILE"

    [[ -t 0 && -t 1 ]] || exit 0
    trap 'printf "%s" "${ESC}[?25h"' EXIT
    printf '%s\n' "${ESC}[?25l"
    for ((f = 0; f <= FRAMES; f++)); do
        ((f > 0)) && printf '%s' "${ESC}[${H}A"
        render "$f" "$PAD" "${ESC}[K"
        read -rsn1 -t "$DELAY" && break
    done
    # Return to where the animation started so fastfetch draws over it
    printf '%s' "${ESC}[$((H + 1))A${ESC}[G"
)

command -v fastfetch >/dev/null && fastfetch

# A random quote beneath the painting and system info
QUOTES="$HOME/.config/fastfetch/quotes.txt"
[[ -r $QUOTES ]] || exit 0
IFS='|' read -r jp romaji en src < <(grep -v -e '^#' -e '^[[:space:]]*$' "$QUOTES" | shuf -n1)
[[ -n $jp ]] || exit 0
QPAD="    "
(
    export LC_ALL=C.UTF-8
    printf '%s' "$QPAD"
    if [[ -t 0 && -t 1 ]]; then
        # Write the Japanese one character at a time, like brushwork
        for ((i = 0; i < ${#jp}; i++)); do
            printf '%s' "${jp:i:1}"
            read -rsn1 -t 0.05 && { printf '%s' "${jp:i+1}"; break; }
        done
        printf '\n'
    else
        printf '%s\n' "$jp"
    fi
)
printf '%s%s%s%s\n' "$QPAD" "${ESC}[90m" "$romaji" "$RST"
printf '%s%s%s%s  %s— %s%s\n\n' "$QPAD" "${ESC}[90m" "$en" "$RST" "$SHU" "$src" "$RST"
```

How it works:
- **`hemisphere`:** reads your timezone (`/etc/timezone`) and returns `south` for Australian, New Zealand, South American and southern-African zones, otherwise `north`. Override it with `MOON_HEMISPHERE=south`.
- **`moon_cells` (awk):** finds the moon's age as a fraction of the 29.53-day synodic month, counted from a known new moon (6 Jan 2000, 18:14 UTC). From that it gets the phase name and % lit. Then, for a 24×10-cell disk (48×20 sub-pixels, since a terminal cell is about 2.4× taller than wide), it marks each sub-pixel as on the disk and lit or unlit. The terminator is the ellipse `x = cos(phase) · √(1−y²)`. The maria are eight ellipses at the real seas' positions (Imbrium, Serenitatis, Tranquillitatis, Crisium, Fecunditatis, Procellarum, Nubium, Humorum). It prints hex masks that bash turns into quadrant characters. `MOON_DATE=2026-12-24 term-intro` previews any night.
- **`layout`:** builds the 12 rows once, giving every cell its character, color, the frame it lands on, and (for lit cells) the shadowed version shown before the light arrives. Order: shadow disk → light from the bright limb inward → mist → phase name → seal.
- **`render`:** draws one frame from that layout. Lit cells go `░ → ▒ → final`, kanji appear grey first, then darken.
- **Colors:** `MOON_LIGHT`, `MOON_SEA`, `MOON_DARK` (+ `DARK_BG`, keep equal to `MOON_DARK`) are truecolor `38;2;R;G;B` codes at the top of the script.
- **Main block:** saves the finished painting for fastfetch, hides the cursor, plays the frames (`read -t` acts as both the frame delay and the "any key skips" check), moves the cursor back up, then runs fastfetch.
- **Quote:** picks a random non-comment line from `quotes.txt` with `shuf`, writes the Japanese one character at a time, then the romaji and English.

### 6.7 fastfetch config
`~/.config/fastfetch/config.jsonc`
```jsonc
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
  "logo": {
    "type": "file-raw",
    "source": "/home/suvanch/.config/fastfetch/moon-logo.txt",
    "width": 30,
    "height": 12,
    "padding": { "top": 1, "left": 2, "right": 4 }
  },
  "display": {
    "separator": "  ",
    "color": { "keys": "red", "title": "default", "separator": "default" }
  },
  // One kanji per line in vermilion, a quiet grey label after it
  "modules": [
    "break",
    { "type": "title", "format": "{user-name} \u001b[90m·\u001b[39m {host-name}" },
    { "type": "custom", "format": "\u001b[90m━━━━━━━━━━  ━━━━  ━" },
    { "type": "os",       "key": "機\u001b[90m  os    ", "format": "{pretty-name}" },
    { "type": "kernel",   "key": "核\u001b[90m  kernel", "format": "{release}" },
    { "type": "uptime",   "key": "時\u001b[90m  uptime" },
    { "type": "packages", "key": "包\u001b[90m  pkgs  ", "format": "{all}" },
    { "type": "shell",    "key": "殻\u001b[90m  shell " },
    "break",
    { "type": "cpu",      "key": "脳\u001b[90m  cpu   ", "format": "{name}  {temperature}", "temp": true },
    { "type": "memory",   "key": "憶\u001b[90m  memory", "format": "{used} / {total}" },
    { "type": "disk",     "key": "蔵\u001b[90m  disk  ", "format": "{size-used} / {size-total}", "folders": "/" },
    { "type": "battery",  "key": "電\u001b[90m  power ", "format": "{capacity}" },
    // Tonight's phase, written by term-intro
    { "type": "command",  "key": "月\u001b[90m  moon  ", "text": "cat ~/.config/fastfetch/moon-phase.txt 2>/dev/null" }
  ]
}
```

Notes:
- `"type": "file-raw"` prints the logo file as-is, keeping its color codes. `width` and `height` must match the painting, 30×12.
- Each `key` is a kanji (colored red by `"keys": "red"`), then `\u001b[90m`, which switches to grey for the English label. The labels are padded with spaces so the values line up.
- `format` strings use fastfetch placeholders such as `{used}` and `{total}` to keep each line short.
- The 月 moon line is a `command` module: it just `cat`s `moon-phase.txt`, which `term-intro` rewrote a moment earlier.

### 6.8 Quotes
`~/.config/fastfetch/quotes.txt`
```text
# One quote per line: japanese|romaji|english|source
# Lines starting with # are ignored. Add your own.
蝸牛そろそろ登れ富士の山|katatsumuri soro soro nobore fuji no yama|O snail, climb Mount Fuji, but slowly, slowly.|Issa
古池や蛙飛び込む水の音|furuike ya kawazu tobikomu mizu no oto|An old pond, a frog jumps in, the sound of water.|Bashō
静かさや岩にしみ入る蝉の声|shizukasa ya iwa ni shimiiru semi no koe|Such stillness: the cicada's cry seeps into the rocks.|Bashō
七転び八起き|nana korobi ya oki|Fall seven times, rise eight.|proverb
一期一会|ichigo ichie|One time, one meeting. Treasure every encounter.|proverb
千里の道も一歩から|senri no michi mo ippo kara|A journey of a thousand miles begins with a single step.|proverb
塵も積もれば山となる|chiri mo tsumoreba yama to naru|Even dust, piled up, becomes a mountain.|proverb
石の上にも三年|ishi no ue ni mo san nen|Sit on a cold stone for three years and it grows warm.|proverb
継続は力なり|keizoku wa chikara nari|Persistence is power.|proverb
急がば回れ|isogaba maware|If you are in a hurry, take the long way round.|proverb
雨降って地固まる|ame futte ji katamaru|After the rain, the ground grows firm.|proverb
猿も木から落ちる|saru mo ki kara ochiru|Even monkeys fall from trees.|proverb
能ある鷹は爪を隠す|nō aru taka wa tsume wo kakusu|The skilled hawk hides its talons.|proverb
井の中の蛙大海を知らず|i no naka no kawazu taikai wo shirazu|A frog in a well knows nothing of the great sea.|proverb
花より団子|hana yori dango|Dumplings over flowers.|proverb
知らぬが仏|shiranu ga hotoke|Not knowing is Buddha. Ignorance is bliss.|proverb
```

### 6.9 .bashrc block
Appended to the end of `~/.bashrc` (Step 10):
```bash
# Ghostty intro: ink-wash moon + fastfetch system info + quote (remove to disable)
if [[ $- == *i* && $TERM_PROGRAM == ghostty && -z $TERM_INTRO_SHOWN ]] && command -v term-intro >/dev/null; then
    export TERM_INTRO_SHOWN=1
    term-intro
fi

# Starship prompt (config: ~/.config/starship.toml)
command -v starship >/dev/null && eval "$(starship init bash)"
```

### 6.10 Starship prompt
`~/.config/starship.toml`
```toml
"$schema" = 'https://starship.rs/config-schema.json'

# Sumi prompt: minimal ink-wash style with kanji markers.
# Colors are ANSI names, so they follow the Ghostty theme (Sumi or Washi).
#
#   ~/Desktop/Projects 枝 main ! 時 3s
#   ›
#
# Only the modules listed in `format` are shown.

add_newline = true
format = """
$directory$git_branch$git_status$python$cmd_duration
$character"""

[directory]
style = "bold"
format = "[$path]($style)[$read_only]($read_only_style) "
truncation_length = 3
truncate_to_repo = true
truncation_symbol = "…/"
read_only = " 錠"
read_only_style = "red"

# 枝 = branch
[git_branch]
symbol = "枝 "
style = "bright-black"
format = "[$symbol$branch]($style) "

[git_status]
style = "yellow"
format = "([$all_status$ahead_behind]($style) )"

# 蛇 = snake
[python]
symbol = "蛇 "
style = "bright-black"
format = '[${symbol}${version}( \($virtualenv\))]($style) '

# 時 = time, shown when a command takes 2 seconds or more
[cmd_duration]
min_time = 2000
style = "bright-black"
format = "[時 $duration]($style) "

# Grey when the last command succeeded, vermilion when it failed
[character]
success_symbol = "[›](bright-black)"
error_symbol = "[›](red)"
```

Notes:
- Only the modules named in `format` appear, which keeps the prompt minimal. Starship has many more (node, rust, docker, battery…): https://starship.rs/config/
- Colors are ANSI names (`bright-black`, `red`, `yellow`), so the prompt follows whichever Ghostty theme is active.
- Preview without opening a new terminal: `starship prompt`, or `starship prompt --status 1` to see the failed-command arrow.

### 6.11 Background darkening script
`~/.config/ghostty/backgrounds/sumi_tone.py`
```python
"""Make a dark, ink-toned copy of a print for use behind terminal text.

usage: sumi_tone.py <input.jpg> <output.jpg> <preview.png>
"""
import sys
from PIL import Image, ImageChops, ImageDraw, ImageFont, ImageOps

BG = (0x12, 0x11, 0x10)  # Sumi theme background
TEXT = (0xE3, 0xD9, 0xC3)  # Sumi theme foreground
KEEP_COLOR = 0.5  # 0 = grey ink, 1 = original colors
STRENGTH = 0.35  # brightness ceiling; dial it down live with background-image-opacity
LEFT = 0.25  # strength on the left (text side) relative to the right


def smoothstep(a, b, x):
    t = min(max((x - a) / (b - a), 0.0), 1.0)
    return t * t * (3 - 2 * t)


src, dst, preview = sys.argv[1:4]
img = Image.open(src).convert("RGB")

gray = ImageOps.grayscale(img).convert("RGB")
toned = Image.blend(gray, img, KEEP_COLOR)

# Left-to-right fade: dim where text sits, strongest on the right
ramp = Image.linear_gradient("L").rotate(90).resize(img.size)
ramp = ramp.point(
    lambda v: round(255 * STRENGTH * (LEFT + (1 - LEFT) * smoothstep(0.3, 0.7, v / 255)))
)
toned = ImageChops.multiply(toned, Image.merge("RGB", [ramp] * 3))

out = ImageChops.add(Image.new("RGB", img.size, BG), toned)
out.save(dst, quality=92)

# Preview with sample terminal text on top
p = out.copy()
draw = ImageDraw.Draw(p)
try:
    font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf", 26)
except OSError:
    font = ImageFont.load_default()
for i in range(30):
    y = 30 + i * 41
    draw.text((40, y), "~/Desktop/Projects  ls -la  drwxr-xr-x  suvanch  4096  config", fill=TEXT, font=font)
    draw.text((1000, y), "readable text test 0123456789", fill=TEXT, font=font)
p.save(preview)
print("wrote", dst)
```

How it works: it blends the print with a greyscale copy (`KEEP_COLOR`), multiplies it by a left-to-right ramp (dim `LEFT` on the text side, full `STRENGTH` on the right), and adds the result onto the Sumi background color. So the darkest parts of the print match the terminal background exactly. The preview draws sample text over the result so you can judge readability before using it.

---

## 7. Customizing

Reload Ghostty's config at any time with **`Ctrl+Shift+,`**. Shader and theme edits apply immediately. Font changes may need a new window.

| I want to… | Do this |
|---|---|
| Switch to the light paper theme | `theme = Washi` in `config` |
| Follow Mint's light/dark setting | `theme = light:Washi,dark:Sumi` |
| Pure black background | In `themes/Sumi` set `background = #000000` |
| Browse other built-in themes | `ghostty +list-themes` |
| Longer / stronger brush trail | Raise `DURATION` / `OPACITY` at the top of `brush_trail.glsl` |
| Turn off an effect | Put `#` in front of its `custom-shader =` line |
| Less or more paper texture | Change `GRAIN`, `FIBERS`, `VIGNETTE`, `BLEED` in `washi_paper.glsl` |
| Faster / slower intro | `DELAY` (seconds per frame) and `FRAMES` in `term-intro` |
| Add my own quote | Add a line `japanese|romaji|english|source` to `quotes.txt` |
| Change which stats appear | Add or remove entries in `"modules"` in `config.jsonc`. All module types: `fastfetch --list-modules` |
| Turn off the intro | Delete the last block of `~/.bashrc` |
| Run the intro manually | `term-intro` |
| Bigger text | `font-size = 14` in `config` |
| Use The Great Wave as background | `background-image = …/backgrounds/great-wave-sumi.jpg` in `config` |
| **Background brighter / darker** | `background-image-opacity` in `config`: `0` = plain black, `1` = brightest (default `0.6`). Save, then `Ctrl+Shift+,` |
| Background brighter than opacity 1 allows | Raise `STRENGTH` (default `0.35`) at the top of `sumi_tone.py` and re-run it (Step 5c) |
| Paper texture ("slate") darker / lighter | `GRAIN` and `FIBERS` in `washi_paper.glsl` (higher = darker mottling, `0` = off); `VIGNETTE` for the corners |
| Moon color | `MOON_LIGHT` / `MOON_SEA` / `MOON_DARK` in `term-intro` (truecolor `R;G;B`). Gold: `MOON_LIGHT="${ESC}[38;2;201;160;79m"` |
| Preview another night's moon | `MOON_DATE=2026-12-24 term-intro` |
| Wrong side lit (hemisphere) | `export MOON_HEMISPHERE=south` (or `north`) in `~/.bashrc` before the intro block |
| More / less color in the print | `KEEP_COLOR` in `sumi_tone.py` (0 = grey ink, 1 = full color) |
| Use my own image | Put it in `backgrounds/`, run `python3 -I sumi_tone.py mine.jpg mine-sumi.jpg /tmp/preview.png`, check the preview, then point `background-image` at `mine-sumi.jpg` |
| Remove the background | Put `#` in front of the `background-image =` line |
| Change the prompt | Edit `~/.config/starship.toml`. It applies to the next prompt immediately |
| Go back to the plain bash prompt | Delete the Starship lines at the end of `~/.bashrc` |

**Editing the painting:** the moon is generated, so its size is set by the 24×10 grid in `moon_cells` and the cell order in `layout`. The mist rows are in `MIST`. Every row must stay **exactly 30 columns** (kanji count as 2). Check with:

```bash
sed 's/\x1b\[[0-9;]*m//g' ~/.config/fastfetch/moon-logo.txt | while IFS= read -r l; do printf '%s' "$l" | LC_ALL=C.UTF-8 wc -L; done
```

(Run `term-intro` once first so `moon-logo.txt` is regenerated. Every number printed should be 30.)

---

## 8. Troubleshooting

| Problem | Cause & fix |
|---|---|
| **Boxes or blank squares instead of kanji** | No Japanese font installed. Do [Step 3](#step-3--make-sure-japanese-fonts-are-installed). |
| **Icons or odd symbols look broken** | The Nerd Font isn't installed or its name is misspelled. Check `fc-list \| grep "JetBrainsMono Nerd Font"`. |
| **No animation or stats when opening Ghostty** | Check `command -v term-intro` (is `~/.local/bin` on your PATH?), check the script is executable (Step 8) and that the `.bashrc` block exists. |
| **Stats appear but no painting beside them** | `moon-logo.txt` is missing or the path in `config.jsonc` is wrong, for example a different username (Step 9). Run `term-intro` once to regenerate it. |
| **Stats are crooked next to the painting** | A row of `ART` isn't 30 columns wide. See "Editing the painting" above. |
| **Shader has no visible effect** | Check the log (Step 12). An error line means a typo in the `.glsl` file. If it loaded fine, the effect may be too subtle: raise its strength settings. |
| **Brush trail doesn't show while typing** | Expected. It's designed for cursor *jumps*: clicking, `Home`/`End`, moving lines in an editor. Normal typing gives only a tiny flick. |
| **No background image** | The path in `background-image` must be absolute and correct (Step 9 fixes the username). Run `file` on the image to check it's a real PNG/JPEG. Needs Ghostty 1.2+. |
| **Prompt still looks plain** | Starship isn't found: check `command -v starship`, and that the Starship line is the last thing in `~/.bashrc`. Open a new terminal afterwards. |
| **Config error on start** | Run `ghostty +validate-config`. It names the bad line. |
| **Shader paths not found** | Paths in `config` must be absolute and match your username (Step 9). |
| **A `config.ghostty` file exists** | Newer Ghostty also reads `config.ghostty`. Keep it empty or delete it so settings live in one place, `config`. |

---

## 9. Reverting

- **Original plain config:** `cp ~/.config/ghostty/config.backup ~/.config/ghostty/config`
- **The neon version:** everything is in `~/.config/ghostty/neon-backup/` (`config`, `shaders/`, `term-intro`, `fastfetch-config.jsonc`). Copy each back to its original location.
- **Remove everything:** delete the two `.bashrc` blocks, then remove `~/.config/ghostty/themes`, `~/.config/ghostty/shaders`, `~/.config/ghostty/backgrounds`, `~/.local/bin/term-intro`, `~/.config/fastfetch`, `~/.config/starship.toml` and optionally `~/.local/bin/fastfetch`, `~/.local/bin/starship` and `~/.local/share/fonts/JetBrainsMono` (run `fc-cache -f` afterwards).
