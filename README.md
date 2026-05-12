# Various Linux/macOS Utilities Used Daily

## Commands

### tar

- List contents of a tarball

```
tar -tvf archive.tar.gz | more
```

- List and filter contents of a tarball

```
tar -tvf archive.tar.gz | grep 'some_term'
```

- Extract a file from a tarball

```
tar -xvf archive.tar path/to/file
```

[More details...](https://www.cyberciti.biz/faq/linux-unix-extracting-specific-files/)

### Image Processing

- Convert all "image" files in a directory (bash, requires imagemagick and works on a myriad of file types)

```
for f in *.png; do
  convert ./"$f" ./"${f%.png}.pdf"
done
```

### Fonts

- Reset font cache (e.g., Ubuntu): `fc-cache -f -v`

## Command Line Configuration

[Starship](https://starship.rs) simplifies working with the same looking shell on various computer tremendously. It works best with the so-called nerd fonts.

Typically, I use the `AtkynsonMono Nerd Font` from https://www.nerdfonts.com. You might want to use this font in Visual Studio Code etc. as well.

My personal setup is based on [starship.toml](./starship.toml) that has to be copied to `~/.config/starship.toml`.

### Personal Setup

Requirements:

- Installed Nerd font
- curl
- fish

```
curl -sS https://starship.rs/install.sh | sh
printf '\n#daz: starship.rs\nstarship init fish | source' >> ~/.config/fish/config.fish
curl --output ~/.config/starship.toml https://raw.githubusercontent.com/elektrobohemian/linux_utilities/refs/heads/main/starship.toml
```

## Useful CLI Tools

- `duf` visual display of storage usage
- `htop` better looking `top` alternative
- `nvtop` an `htop`equivalent for the GPU
- `ffmpeg` an audio/video conversion tool
- `tldr` prints typical usage scenarios for a given command, e.g. for the infamous `ffmpeg`:

```
    - Extract the sound from a video and save it as MP3:
        ffmpeg -i path/to/video.mp4 -vn path/to/sound.mp3

    - Transcode a FLAC file to Red Book CD format (44100kHz, 16bit):
        ffmpeg -i path/to/input_audio.flac -ar 44100 -sample_fmt s16 path/to/output_audio.wav
```

- `uv` an alternative to _python venv_ described by `tldr` as "
  A fast Python package and project manager."
- `fastfetch` displays relevant information regarding your system as below (running under macOS):

```
                     ..'          user@0uuid
                 ,xNMM.           ------------------------------------------
               .OMMMMo            OS: macOS Tahoe 26.4.1 (25E253) arm64
               lMM"               Host: MacBook Air (13-inch, M4, 2025)
     .;loddo:.  .olloddol;.       Kernel: Darwin 25.4.0
   cKMMMMMMMMMMNWMMMMMMMMMM0:     Uptime: 26 days, 13 hours, 33 mins
 .KMMMMMMMMMMMMMMMMMMMMMMMWd.     Packages: 166 (brew), 6 (brew-cask)
 XMMMMMMMMMMMMMMMMMMMMMMMX.       Shell: fish 4.6.0
;MMMMMMMMMMMMMMMMMMMMMMMM:        Display (HP U28 4K HDR): 6016x3384 @ 2x in 28", 60 Hz [External]
:MMMMMMMMMMMMMMMMMMMMMMMM:        WM: Quartz Compositor 1.600.0
.MMMMMMMMMMMMMMMMMMMMMMMMX.       WM Theme: Multicolor (Light)
 kMMMMMMMMMMMMMMMMMMMMMMMMWd.     Theme: Liquid Glass
 'XMMMMMMMMMMMMMMMMMMMMMMMMMMk    Font: .AppleSystemUIFont [System], Helvetica [User]
  'XMMMMMMMMMMMMMMMMMMMMMMMMK.    Cursor: Fill - Black, Outline - White (36px)
    kMMMMMMMMMMMMMMMMMMMMMMd      Terminal: Tabby 1.0.230
     ;KMMMMMMMWXXWMMMMMMMk.       Terminal Font: AtkynsonMono Nerd Font (14pt)
       "cooc*"    "*coo'"         CPU: Apple M4 (10) @ 4.46 GHz
                                  GPU: Apple M4 (10) @ 1.47 GHz [Integrated]
                                  Memory: 28.31 GiB / 32.00 GiB (88%)
                                  Swap: 5.11 GiB / 6.00 GiB (85%)
                                  Disk (/): 775.56 GiB / 926.35 GiB (84%) - apfs [Read-only]
                                  Disk (/Volumes/xxx): 1.69 TiB / 1.86 TiB (91%) - apfs [External]
                                  Local IP (en5): xxx.xxx.xxx.xxx/zz
                                  Battery (xxx): 76% [AC connected]
                                  Power Adapter: 85W
                                  Locale: en_US.UTF-8
```

## Data Management

- Compare directories https://linuxhandbook.com/compare-directories/
- List contents of very large directories (in terms of number of files): `ls -1Ua`, i.e., `-1` one file per line, `-U` skips sorting and `-a` all files, including hidden files, will be listed
- Count number of files `ls -1Ua | wc -l`
- Get size of a directory `du -sh dir/`
- Get size of directory when symlinks are handled as separate files `du -sh --count-links dir/`

## Data Quality

- [deadlink_checker_md.py](deadlink_checker_md.py) checks a folder (non-recursively) for .md files and tries to discover link rot indicated by a HTTP 404 response. Dead links will be appended to each markdown file and tagged with #dead-links.

## Backup and Analysis

- [inc_backup.sh](inc_backup.sh) is a backup script based on `rsync`

## Network

- `iftop` top for network traffic
- `ethtool` network diagnostics

### SSH

Execute a command on a remote server that relies on a password

```
SSH_PASS="my_password"
ssh -i ~/.ssh/my_private_key user@server "echo '$SSH_PASS' | sudo -S ls"
```

## Spyware

- [Claude_Launch_Without_Spying.shortcut](claude_doc.md) A macOS shortcut that deletes the spyware components Claude Desktop installs on every launch.

## Knowledge Management

### Obsidian and Logseq

##### Setup

Making [Obsidian](https://obsidian.md) and [Logseq](https://logseq.com) to work on the same documents is fairly easy when configured properly.

##### Obsidian

1. Create a folder that should store your markdown documents, e.g. `obsidian`.
2. In this folder create the following subdirectories:
   - `assets`
   - `journals`
   - `pages`
   - `obsidian_canvas` (optional if you plan to use Obsidian's canvas)
     It is important to create these directories **before launching** Obsidian, otherwise it might complain about non-existent folders during setup. In addition, if all folders are created before configuration, you can choose them from drop-down menus.
3. Open Obsidian, "Manage vaults", "Open folder as vault": chose the newly created folder, e.g. `obsidian`.
4. Go to Settings, "Files & Links" and set everything as follows:
   - "Default location for new notes": "In the folder specified below."
   - "Folder to create new notes in": set to `pages`
   - "Default location for new attachments": "In the folder specified below."
   - "Attachment folder path": "" set to `assets`
   - "New link format": set to "Relative path to file."
   - "Use [[Wikilinks]]": switch off
   - _Optional but recommended:_ If you want to avoid cluttered graphs after working a while with Logseq, adjust "Excluded files" to include: `whiteboards`, `logseq`
5. Go to Settings, "Core plugins" and set up the "Daily Notes" plugin as follows:
   - "Date format": yyyy-MM-dd, e.g. 2026-04-23
   - "New file location": set to `journals`
6. _Optional:_ If you want to use the canvas, go to Settings, "Core plugins" and set up the "Canvas" plugin to use the `obsidian_canvas` folder.
7. Ignore

##### Logseq

1. Open Logseq and choose "Add new graph" and point to the newly created folder, e.g. `obsidian`.
2. You will most likely be prompted to re-index the Logseq graph (see drop down menu of the current graph, e.g. `obsidian`).
3. Go to Settings, "Editor" and make sure that the "Preferred date format" matches Obsidian's format, i.e. `yyyy-MM-dd` if you followed this guide.
4. _Optional:_ Activate "Prefer pasting file" to let Logseq download images from the web instead of linking them. I recommend this settings as it will reduce link rot.
5. You are completely set up.

##### Conversion Utilities

- [obsidian_todo_2_logseq.py](obsidian_todo_2_logseq.py) replaces all `- [ ]` (checkmark to-do bullet points in Obsidian) with Logseq's `- TODO` format. To make most out of the script, create a task management page in Logseq with this query:

  ```
  {{query (and (task TODO DOING LATER) (not [[done]]))}}
  ```

  In case you have used the deadlink checker, you could also add

  ```
  {{query #dead-links }}
  ```

  to get an overview over all dead links.

- [obsidian_tags_2_logseq.py](obsidian_tags_2_logseq.py) takes all Obsidian `#foo` tags and converts them to Logseq page tags for each markdown document.

---

## Links

- [nixCraft](https://www.cyberciti.biz), a generally good read for all topics dealing with Un\*x-oid OS
