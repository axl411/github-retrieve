# github-retrieve

A command-line interface (CLI) for retrieving raw content from individual files or directories within a GitHub repository. It supports filtering by file path suffixes, and the retrieved content is written directly to stdout.

This tool can be used in workflows to efficiently construct prompts that include file contents. These prompts are then sent to a generative AI model, allowing for conversations and questions with access to all the provided source code.

# Usage

```bash
github-retrieve jimmy/project Documents Source/App.swift \
    --github-token <PERSONAL_ACCESS_TOKEN> \
    --github-host <GIT_HUB_HOST> \ # no need to provide when retrieving from the public GitHub
    --file-postfixes-to-retrieve .swift \
    --file-postfixes-to-retrieve .md \
    --file-postfixes-to-retrieve BUILD
```
