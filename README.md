## *Setup dotfiles*

https://www.atlassian.com/git/tutorials/dotfiles

```bash
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
echo ".dotfiles" >> .gitignore
git clone --bare https://github.com/cngu/dotfiles.git $HOME/.dotfiles
dotfiles checkout
dotfiles config --local status.showUntrackedFiles no
```

## *Tooling*

**Fonts**
Nerd Fonts: https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts
- Hack

**zsh**
- zinit

**Homebrew**
- git
  ```
  cd /usr/local/bin
  ln -s ~/scripts/custom-git-commands/git-*
  ```
- git-lfs
- powerlevel10k
  - `p10k configure`
  - Stick prompt to bottom: https://www.reddit.com/r/zsh/comments/dsh1g3/new_powerlevel10k_feature_transient_prompt/f6rmpgc/
- nvim
- ripgrep
- jq
- tidy-html5
- bat
  ```
  bat cache --clear
  bat cache --build
  ```
- thefuck
- fasd

**Vim**
- vim-plug: https://github.com/junegunn/vim-plug
  - Install to `~/.config/nvim/autoload/plug.vim

**cngu iTerm colorscheme**
- Ephemeral base
- Black darkened by 5%: #33404F
- Bright Black lightened by 3%: #5C7087
- Background taken from onedark.vim so terminal and vim match: #282c34
- 'Cursor text' matches 'Background' (from onedark.vim)
- 'Cursor' matches 'Foreground'
- Until iTerm allows preserving selected color text (see TODO below)
  - 'Selection' set to onedark.vim background: #3E4452
  - 'Selected text' matches 'Foreground'

## macOS setup

**Apps**
- iTerm2
- Karabiner Elements
- Clipy
- Dropbox
- Rectangle

**Terminal.app**
- Terminal > Preferences > Profiles > Keyboard > "Use Option as Meta key" (fzf Option-a select-all)
- defaults write -g ApplePressAndHoldEnabled -bool false

## TODO

- iTerm text color should stay the same even while selected: https://gitlab.com/gnachman/iterm2/-/issues/8761
