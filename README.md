# Sokoban

## Development

```
bundle
ruby game.rb
```

## Packaging for Windows

```
gem install ocra
ocra --output Sokoban.exe --windows --chdir-first game.rb assets/**/* levels/**/*
```
