# Various Linux/macOS Utilities Used Daily

## Commands

### tar

* List contents of a tarball
```
tar -tvf archive.tar.gz | more
```
* List and filter contents of a tarball
```
tar -tvf archive.tar.gz | grep 'some_term' 
```
* Extract a file from a tarball
```
tar -xvf archive.tar path/to/file
```
[More details...](https://www.cyberciti.biz/faq/linux-unix-extracting-specific-files/)

## Data Quality
* [deadlink_checker_md.py](deadlink_checker_md.py) checks a folder (non-recursively) for .md files and tries to discover link rot indicated by a HTTP 404 response. Dead links will be appended to each markdown file and tagged with #dead-links.

## Backup and Analysis

* [inc_backup.sh](inc_backup.sh) is a backup script based on ``rsync``

## Network

* ``iftop`` top for network traffic
* ``ethtool`` network diagnostics

## Spyware
* [Claude_Launch_Without_Spying.shortcut](claude_doc.md) A macOS shortcut that deletes the spyware components Claude Desktop installs on every launch.

## Knowledge Management

### Obsidian and Logseq

##### Setup

Making [Obsidian](https://obsidian.md) and [Logseq](https://logseq.com) to work on the same documents is fairly easy when configured properly.

##### Obsidian
1. Create a folder that should store your markdown documents, e.g. `obsidian`.
2. In this folder create the following subdirectories:
    * `assets`
    * `journals`
    * `pages`
    * `obsidian_canvas` (optional if you plan to use Obsidian's canvas)
    It is important to create these directories __before launching__ Obsidian, otherwise it might complain about non-existent folders during setup. In addition, if all folders are created before configuration, you can choose them from drop-down menus.
3. Open Obsidian, "Manage vaults", "Open folder as vault": chose the newly created folder, e.g. `obsidian`.
4. Go to Settings, "Files & Links" and set everything as follows:
    * "Default location for new notes": "In the folder specified below." 
    * "Folder to create new notes in": set to `pages`
    * "Default location for new attachments": "In the folder specified below." 
    * "Attachment folder path": "" set to `assets`
     * "New link format": set to "Relative path to file."
    * "Use [[Wikilinks]]": switch off
    * _Optional but recommended:_ If you want to avoid cluttered graphs after working a while with Logseq, adjust "Excluded files" to include: `whiteboards`, `logseq`
5. Go to Settings, "Core plugins" and set up the "Daily Notes" plugin as follows:
    * "Date format": yyyy-MM-dd, e.g. 2026-04-23
    * "New file location": set to `journals`
6. _Optional:_ If you want to use the canvas, go to Settings, "Core plugins" and set up the "Canvas" plugin to use the `obsidian_canvas` folder.
7. Ignore

##### Logseq
1. Open Logseq and choose "Add new graph" and point to the newly created folder, e.g. `obsidian`.
2. You will most likely be prompted to re-index the Logseq graph (see drop down menu of the current graph, e.g. `obsidian`).
3. Go to Settings, "Editor" and make sure that the "Preferred date format" matches Obsidian's format, i.e. `yyyy-MM-dd` if you followed this guide.
4. _Optional:_ Activate "Prefer pasting file" to let Logseq download images from the web instead of linking them. I recommend this settings as it will reduce link rot.
5. You are completely set up.

##### Conversion Utilities
* [obsidian_todo_2_logseq.py](obsidian_todo_2_logseq.py) replaces all `- [ ]` (checkmark to-do bullet points in Obsidian) with Logseq's `- TODO` format. To make most out of the script, create a task management page in Logseq with this query: 

    ```
    {{query (and (task TODO DOING LATER) (not [[done]]))}}
    ```

    In case you have used the deadlink checker, you could also add
    ```
    {{query #dead-links }}
    ```
    to get an overview over all dead links.

* [obsidian_tags_2_logseq.py](obsidian_tags_2_logseq.py) takes all Obsidian `#foo` tags and converts them to Logseq page tags for each markdown document.

---

## Links
* [nixCraft](https://www.cyberciti.biz), a generally good read for all topics dealing with Un*x-oid OS