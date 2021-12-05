"--------------------------------------------------------------------------
" General settings
"--------------------------------------------------------------------------

set expandtab
set shiftwidth=4
set tabstop=4
set hidden
set signcolumn=yes:2
set relativenumber
set number
set termguicolors
set undofile
set spell
set title
set ignorecase
set smartcase
set wildmode=longest:full,full
set nowrap
set list
set listchars=tab:▸\ ,trail:·
set mouse=a
set scrolloff=8
set sidescrolloff=8
set nojoinspaces
set splitright
set clipboard=unnamedplus
set confirm
set exrc
set backup
set backupdir=~/.local/share/nvim/backup//
set updatetime=300 " Reduce time for highlighting other references
set redrawtime=10000 " Allow more time for loading syntax on large files

"--------------------------------------------------------------------------
" Key maps
"--------------------------------------------------------------------------

let mapleader = "\<space>"

nmap <leader>ve :edit ~/.config/nvim/init.vim<cr>
nmap <leader>vr :source ~/.config/nvim/init.vim<cr>

nmap <leader>k :nohlsearch<CR>
nmap <leader>Q :bufdo bdelete<cr>

" Allow gf to open non-existent files
map gf :edit <cfile><cr>

" Reselect visual selection after indenting
vnoremap < <gv
vnoremap > >gv

"--------------------------------------------------------------------------
" Plugins
"--------------------------------------------------------------------------

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(data_dir . '/plugins')

source ~/.config/nvim/plugins/dracula.vim
source ~/.config/nvim/plugins/fzf.vim
source ~/.config/nvim/plugins/nerdtree.vim
source ~/.config/nvim/plugins/which-key.vim

call plug#end()
doautocmd User PlugLoaded
