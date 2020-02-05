# Josh's Vim Configuration 

* Configuration to replace most of your daily programs with Vim. The concept is simple: get really good at using Vim and use it for everything. 
* Programs I am trying to replace:
  1. Microsoft Word/Excel -> Vim Table Mode, Vim Markdown Preview 
  2. XCODE/VSCODE -> Syntastic (Syntax Check), Polyglot (Better coloring), NERDTree (Navigation), SuperTab (Tab autocomplete)
  3. Difftool -> DirDiff (Diff entire directories from one another)

## Setup 
This configuration should be fairly OS agnostic, although does require some prerequisite programs to get working properly. This config also does require Vim8.1 or higher.


1. Getting syntastic working
  - Syntastic will look for the default CLI executable for whatever type of file you are working on. (For example *.py files will look for python, python3.6, etc.) 
  - It will then try to determine how to lint your file based off of its type and known lint checkers (Python has pylint, Ruby has MRI, etc.) 
  - You can specify where syntastic looks and what syntax checkers to use by changing its plugin variables on lines starting with "let g:syntastic_" . I have my python to use pylint3.6 with a custom pylintrc file. 

2. Getting markdown_preview working
  - Markdown Preview is very nice for live editing markdown files for notes and docs. Markdown can be converted into a crazy amount of files using Pandoc. 
  - Node and yarn is recommended since it hosts a server. But is not required if you install with pathogen, like my config is doing. You can see more here: https://github.com/iamcco/markdown-preview.nvim .
  - BE WARNED: A lot of older browsers will not work since the backend uses ES5 Javascript which will crash old stuff. 

3. Point your vimrc at my vimrc 
  - In order to get all of these changes you need to tell your default vimrc location to source from my vimrc. My vimrc is in conf/main.vim. Then you need to tell your vimrc that my repo is a place to look for plugins by adding it to the runtimepath. 
  - Here is an example of how to do this from my MACOS. 
    * ~/.vimrc
    ```vim
      ".myvim dir holds my vim plugins
      set runtimepath+= $HOME/.myvim
      source $HOME/.myvim/conf/main.vim
    ```
4. Hopefully ready to go! 
  - I am still fairly new to vim and will be adding this repo frequently. Hopefully not breaking it. 
