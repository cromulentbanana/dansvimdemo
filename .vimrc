set nocompatible              " be iMproved, required
set hidden
filetype off                  " required

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

"Plugin 'pangloss/vim-javascript'
"Plugin 'neovim/nvim-lspconfig'
" https://github.com/neovim/nvim-lspconfig
Plugin 'Badacadabra/vim-archery'
Plugin 'Yggdroot/indentLine'
Plugin 'airblade/vim-gitgutter'
Plugin 'altercation/vim-colors-solarized'
Plugin 'bling/vim-airline'
Plugin 'dense-analysis/ale'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'gosukiwi/vim-atom-dark'
Plugin 'hashivim/vim-terraform'
Plugin 'hauleth/blame.vim'
Plugin 'jiangmiao/auto-pairs'
Plugin 'kien/ctrlp.vim'
Plugin 'majutsushi/tagbar'
Plugin 'maxmellon/vim-jsx-pretty'
Plugin 'mhinz/vim-crates'
Plugin 'mileszs/ack.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'sonph/onehalf', {'rtp': 'vim/'}
Plugin 'timonv/vim-cargo'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'vim-ctrlspace/vim-ctrlspace'
Plugin 'vim-test/vim-test'
Plugin 'ycm-core/YouCompleteMe'
Plugin 'yuezk/vim-js'
"https://github.com/neoclide/coc.nvim/wiki/Completion-with-sources#highlights-of-coc-completion
"https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions
"Plugin 'neoclide/coc.nvim', {'branch': 'release'}

"Plugin 'davidsomething/vim-enhanced-resolver', { 'do': 'npm install enhanced-resolve-cli' }

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set bg=dark
"colorscheme atom-dark
colorscheme onehalfdark

" disable Background Color Erase (BCE) so that color schemes
" render properly when inside 256-color tmux and GNU screen.
if &term =~ '256color'
  set t_ut=
endif


""""""""""""""""""""""""""""""""""""""""
" w0rp/ale
""""""""""""""""""""""""""""""""""""""""
let g:ale_linters_explicit = 1
let g:ale_list_vertical = 1
"let g:ale_linters = 'all'
let g:ale_set_quickfix = 1
let g:ale_linters = {
\   'css': ['prettier'],
\   'dockerfile': ['hadolint'],
\   'html': ['prettier'],
\   'javascript': ['prettier', 'eslint'],
\   'typescript': ['prettier', 'eslint'],
\   'python': ['flake8', 'black', 'mypy', 'pyls'],
\   'rust': ['rls'],
\   'sh': ['shellcheck'],
\}

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'css': ['prettier'],
\   'go': ['gofmt'],
\   'html': ['prettier'],
\   'javascript': ['prettier', 'eslint'],
\   'python': ['autopep8', 'black', 'isort'],
\   'rust': ['rustfmt'],
\   'sh': ['shfmt'],
\   'typescript': ['prettier', 'eslint'],
\   'yaml': ['prettier'],
\}


let g:ale_completion_enabled = 1
let g:ale_completion_autoimport = 1

" Set this variable to 1 to fix files when you save them.
let g:ale_fix_on_save = 1
let g:ale_hover_to_preview = 1

let g:ale_python_pylsp_executable = 'pyls'

""""""""""""""""""""""""""""""""""""""""
" bling/vim-airline
""""""""""""""""""""""""""""""""""""""""
" Set this. Airline will handle the rest.
let g:airline#extensions#ale#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='onehalfdark'
let g:airline#extensions#branch#displayed_head_limit = 10

" Airline tag extensions
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tagbar#flags = 'f'  " show full tag hierarchy

""""""""""""""""""""""""""""""""""""""""
" You Complete Me
""""""""""""""""""""""""""""""""""""""""
"let g:ycm_autoclose_preview_window_after_completion = 0
"let g:ycm_add_preview_to_completeopt = 1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration -vsplit<CR>


""""""""""""""""""""""""""""""""""""""""
" ack.vim
""""""""""""""""""""""""""""""""""""""""
" Use ripgrep for searching ⚡️
" Options include:
" --vimgrep -> Needed to parse the rg response properly for ack.vim
" --type-not sql -> Avoid huge sql file dumps as it slows down the search
" --smart-case -> Search case insensitive if all lowercase pattern, Search case sensitively otherwise
let g:ackprg = 'rg --vimgrep --type-not sql --smart-case'

" Auto close the Quickfix list after pressing '<enter>' on a list item
let g:ack_autoclose = 1

" Any empty ack search will search for the word the cursor is on
let g:ack_use_cword_for_empty_search = 1

" Don't jump to first match
cnoreabbrev Ack Ack!

" Maps <leader>/ so we're ready to type the search keyword
nnoremap <C-f> :Ack!<Space>
" }}}

" Navigate quickfix list with ease
nnoremap <silent> [q :cprevious<CR>
nnoremap <silent> ]q :cnext<CR>

""""""""""""""""""""""""""""""""""""""""
" NERDTree
""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""
" enhanced-resolver
""""""""""""""""""""""""""""""""""""""""
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:ctrlp_working_path_mode = 'r'
let g:ctrlp_custom_ignore = {
\  'dir':  '\v[\/](\.(git|hg|svn)|\_site)$',
\  'file': '\v\.(exe|so|dll|class|png|jpg|jpeg)$',
\}


""""""""""""""""""""""""""""""""""""""""
" Plugin 'scrooloose/nerdcommenter'
""""""""""""""""""""""""""""""""""""""""
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

""""""""""""""""""""""""""""""""""""""""
" Plugin 'mhinz/vim-crates'
""""""""""""""""""""""""""""""""""""""""

if has('nvim')
  autocmd BufRead Cargo.toml call crates#toggle()
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup myvimrc
    au!
    au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END

function! FormatJSON()
:%!python -c "import json, sys; print(json.dumps(json.load(sys.stdin), indent=2))"
endfunction

" Support a bash/zsh-like completion behavior, complete up to the last unique
" prefix.
set wildmode=longest:list,full

" Search and replace keybinding in visual mode using register r
vnoremap <C-r> "ry:%s/<C-r>r//gc<left><left><left>
map <leader>r  :ALERename<CR>
map <leader>f  :ALEFindReferences -vsplit<CR>
map <leader>gd :ALEGoToDefinition -vsplit<CR>

tnoremap <Esc> <C-\><C-n>

nnoremap tt :tabnew<cr>
nnoremap tn :tabnext<cr>
nnoremap ts :tab split<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" https://realdougwilson.com/writing/coding-with-character


"""""""""""""""""""""""""""""""""""""""""
" Plugin 'vim-test/vim-test'
""""""""""""""""""""""""""""""""""""""""
let test#strategy = "asyncrun_background_term"
let g:test#javascript#runner = 'jest'
