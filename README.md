
Setup dotfiles (atlassian.com/git/tutorials/dotfiles)

```
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
echo ".dotfiles" >> .gitignore
git clone --bare https://github.com/cngu/dotfiles.git $HOME/.dotfiles
dotfiles checkout
dotfiles config --local status.showUntrackedFiles no
```

zinit: https://github.com/zdharma/zinit 

Powerlevel10k
- Fonts: https://github.com/romkatv/powerlevel10k/blob/master/README.md#fonts
- `p10k configure`
- Stick prompt to bottom: https://www.reddit.com/r/zsh/comments/dsh1g3/new_powerlevel10k_feature_transient_prompt/f6rmpgc/

vim-plug: https://github.com/junegunn/vim-plug
- `:PlugInstall`

Homebrew: https://brew.sh/
- git
- vim
- ripgrep
- bat
- thefuck
- fasd

npm install -g
- tldr

MacOS Terminal Configuration:
- Terminal > Preferences > Profiles > Keyboard > "Use Option as Meta key" (fzf Option-a select-all)

git aliases:
```
git config --global alias.a add
git config --global alias.ci commit
git config --global alias.co checkout
git config --global alias.d diff
git config --global alias.ds "diff --staged"
git config --global alias.r restore
git config --global alias.rs "restore --staged"
git config --global alias.s status
```
