# installation

unix-like:
```
git submodule update --init --recursive
stow <folder name>
```

windows:
```
new-item `
    -itemtype symboliclink `
    -path C:\FULL\PATH\TO\THE\TARGET\TARGET_NAME.EXT `
    -value C:\FULL\PATH\TO\THE\FILE\FROM\DOTFILES\TARGET_NAME.EXT
```
