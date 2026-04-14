from pathlib import Path
from marko import Markdown
from marko.ast_renderer import ASTRenderer
import requests

# * * * * * * * * * * * * * * * * * * * * * * * *
#
# adjust path to your Obsidian vault here
#
# * * * * * * * * * * * * * * * * * * * * * * * *

base_dir="../obsidian/"

def extract_links(node):
    links = []
    if isinstance(node, dict):
        if node.get('element') == 'link':
            links.append(node.get('dest'))
        if 'children' in node:
            for child in node['children']:
                links.extend(extract_links(child))
    elif isinstance(node, list):
        for item in node:
            links.extend(extract_links(item))
    return links


md_files = list(Path(base_dir).glob("*.md"))

links_in_file=dict()

for md_file in md_files:
    md = Markdown(renderer=ASTRenderer)
    with open(md_file, 'r') as f:
        content = f.read()
        ast = md(content)
    links_in_file[str(md_file)] = extract_links(ast)

# check HTTP responses
i=0
for file in links_in_file:
    #i=i+1
    #if i>5:
    #    break
    links_in_file[str(file)] = links_in_file[str(file)]
    print(file)
    write_file=open(file, 'a')
    first_error=True

    for url in links_in_file[file]:
        try:
            response = requests.get(url)
            if response.status_code != 200:
                if response.status_code == 404:
                    if first_error:
                        write_file.write("---\n# Dead Links\n#dead-links\n")
                        first_error=False
                    write_file.write(f"- [ ] {response.status_code}: {url}\n")
                print(f"\t{response.status_code}: {url}")
        except:
            print(f"\t{url}")
    write_file.close()

print("Detected dead links have been added to your Markdown documents and tagged with '#dead-links'.\nDone.")
