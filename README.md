# Directory

A restricted path-based directory system for custom local file explorers. This
expects you to have a backend which can access the file system. The package
guides you towards a simple architecture:

1. load the root directory from your backend
2. try to switch directories; you receive a path to the new directory
3. load that new directory from your backend

# Context

I was working on a desktop app which used Elm for the UI. I needed the user to
select a file; Elm would then send it's <i>path</i> to the app's backend. For
security reasons, browser apps cannot read file paths—therefore, a custom
solution was the only option. After a lot of tinkering, I ultimately settled on
this directory design.
