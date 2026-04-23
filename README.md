# Various Linux/macOS Utilities Used Daily

## Commands


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

### Obsidian and logseq

#### Conversion Utilities
* [obsidian_todo_2_logseq.py](obsidian_todo_2_logseq.py) replaces all `- [ ]` (checkmark to-do bullet points in Obsidian) with logseq's `- TODO` format. To make most out of the script, create a task management page in logseq with this query: 

    ```
    {{query (and (task TODO DOING LATER) (not [[done]]))}}
    ```

    In case you have used the deadlink checker, you could also add
    ```
    {{query #dead-links }}
    ```
    to get an overview over all dead links.

* [obsidian_tags_2_logseq.py](obsidian_tags_2_logseq.py) takes all Obsidian `#foo` tags and converts them to logseq page tags for each markdown document.
---

## Links
* [nixCraft](https://www.cyberciti.biz), a generally good read for all topics dealing with Un*x-oid OS