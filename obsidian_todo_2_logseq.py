from pathlib import Path
import os
import tempfile

# replaces all '- [ ]' (checkmark to-do bullet points in Obsidian) with logseq's '- TODO' format

# * * * * * * * * * * * * * * * * * * * * * * * *
#
# adjust path to your Obsidian/logseq vault here
#
# * * * * * * * * * * * * * * * * * * * * * * * *
base_dir="/Users/david/src/obsidian_logseq/pages/"

md_files = list(Path(base_dir).glob("*.md"))
ignored_files = ["Offene Aufgaben.md"]

mod_count=0
for md_file in md_files:
    # make sure that we only modify files that should be converted (and not the ones created with logseq)
    if md_file.name not in ignored_files:
        mod_count+=1
        with open(md_file, "r", encoding="utf-8") as inp_file, tempfile.NamedTemporaryFile("w", encoding="utf-8", delete=False) as tmp:
            for line in inp_file:
                if line.startswith("* - [ ]"):
                    line=line.replace("* - [ ]","- TODO")
                elif line.startswith("	* - [ ]"):
                    line=line.replace("	* - [ ]","- TODO")
                else:
                    line=line.replace("- [ ]","- TODO")
                tmp.write(line)
        tmp_path = tmp.name

        os.replace(tmp_path, md_file)  # replace the original file with the temporary; in case something failed the original will be save

print(f"Converted {mod_count} files of {len(md_files)} in total.")