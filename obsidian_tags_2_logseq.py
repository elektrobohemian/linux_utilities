from pathlib import Path
import os
import tempfile
import re

# takes all Obsidian '#foo" tags and converts them to logseq page tags for each markdown document

# * * * * * * * * * * * * * * * * * * * * * * * *
#
# adjust path to your Obsidian/logseq vault here
#
# * * * * * * * * * * * * * * * * * * * * * * * *
base_dir="../obsidian_logseq/pages/"

md_files = list(Path(base_dir).glob("*.md"))
ignored_files = ["Offene Aufgaben.md"]
ignored_tags=["#dead-links"]

mod_count=0
# regex to ignore tags like #1234
num_tag_pattern=re.compile(r"#\d+")
# regex to ignore header tags
header_hash_pattern=re.compile(r"##+")

for md_file in md_files:
    # make sure that we only modify files that should be converted (and not the ones created with logseq)
    if md_file.name not in ignored_files:
        mod_count+=1
        with open(md_file, "r", encoding="utf-8") as inp_file, tempfile.NamedTemporaryFile("w", encoding="utf-8", delete=False) as tmp:
            tags_present=False
            first_line=True # only take care of tags in the first line
            for line in inp_file:
                # find potential tags beginning with # and one or more non-whitespace characters
                tags = re.findall(r"#\S+", line)
                tag_line=""
                if tags:
                    # if there are tag candidates, only deal with real ones
                    #print(f"{md_file}: {tags}")
                    for tag in tags:
                        # ignore tags like '#12345'
                        if not num_tag_pattern.match(tag):
                            # ignore header lines
                            if not header_hash_pattern.match(tag):
                                if not tags_present:
                                    # add page tag prefix once
                                    tag_line="tags::"
                                    tags_present = True
                                tag_line=tag_line+" "+tag+","
                            else:
                                print(f"{md_file}: Ignoring {tag}")
                        else:
                            print(f"{md_file}: Ignoring {tag}")
                if first_line:
                    if tag_line:
                        #tmp.write(tag_line+"\n"+line) # keep original Obsidian tags in the second line (unnecessarily verbose as Obsidian can deal with logseq page tags as well)
                        tmp.write(tag_line)
                    else:
                        tmp.write(line)
                else:
                    tmp.write(line)
                tags_present=False
                first_line=False
        tmp_path = tmp.name
        os.replace(tmp_path, md_file)  # replace the original file with the temporary; in case something failed the original will be save

print(f"Converted {mod_count} files of {len(md_files)} in total.")