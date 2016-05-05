# lydell’s dotfiles

## Setup

```sh
$ cd location/of/choice
$ git clone --no-checkout https://github.com/lydell/dotfiles.git
$ cd dotfiles
$ git config core.worktree "$HOME"
$ git checkout master # --force if you know what you’re doing.
```

## Workflow

Edit files as usual.

`cd location/of/choice/dotfiles` before using `git` commands.
(Tip: Use `git add ~` instead of `git add .`.)

_Everything_ is ignored in `.gitignore`. When adding new files, add an exception
in `.gitignore`. When removing files, also remove the exception.

## License

All files are in the public domain.
