Plug 'easymotion/vim-easymotion'
Plug 'machakann/vim-highlightedyank'
Plug 'preservim/nerdtree'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-surround'
let mapleader="\<space>"
set easymotion

set clipboard+=unnamed  "共享剪切板
set easymotion
syntax on  "语法高亮
" set number relativenumber "显示行号(由于Idea中有行号显示，则vim中的显示行号就不配置了)
set ruler  "显示光标所在位置的行号和列号
set wrap   "自动折行
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab     "将tab替换为相应数量空格
set smartindent
set backspace=2
set co=5
set nobackup "设置取消备份 禁止临时文件生成
set noswapfile
set keep-english-in-normal " 为IdeaVim插件增加自动切换为英文输入法的功能,idea 需要安装 IdeaVimExtension plugin
set showmatch "设置匹配模式 类似当输入一个左括号时会匹配相应的那个右括号
set clipboard^=unnamed,unnamedplus
"set laststatus=2   "命令行为两行
"set fenc=utf-8     "文件编码
"set mouse=a        "启用鼠标
"set ignorecase     "忽略大小写
"set cursorline     "突出显示当前行
set cursorcolumn   "突出显示当前列
set fdm=marker
set sneak
set quickscope
set hls

nnoremap <F1> :sp<CR>
nnoremap <F2> :vsp<CR>
nnoremap <F3> :marks<CR>
" 将一行向上移动
inoremap <M-k> <Esc>kddpk
nnoremap <M-k> kddpk
" 将一行向下移动
nnoremap <M-j> ddp
inoremap <M-j> <Esc>ddp

" 按下 Alt + u 将光标所在单词转为小写
nnoremap <M-u> viwu

" 按下 Alt + Shift + u 将光标所在单词转为大写
nnoremap <M-U> viwU

nnoremap yu yi"
nnoremap yh yi(
nnoremap yg yiw


"nnoremap pl vi"p
"nnoremap po viwp

nnoremap <C-p> viwP

nnoremap <D-p> vi(P

nnoremap <C-D-p> vi"P


vnoremap <C-p> viwP

vnoremap <D-p> vi(P

vnoremap <C-D-p> vi"P

inoremap <C-p> <Esc>viwP

inoremap <D-p> <Esc>vi(P

inoremap <C-D-p> <Esc>vi"P


nnoremap <D-left> ^
nnoremap <D-right> $

vnoremap p "_dhp

nnoremap U viwU

nnoremap <M>o :normal! va(BV<CR>



Plug 'michaeljsmith/vim-indent-object'



map gs <Action>(GotoSuperMethod)
map gf <Action>(GotoImplementation)

map <leader>f <Action>(ReformatCode)
map <leader>ra <Action>(RunAnything)
map <leader>c <Action>(Git.Menu)
map <leader>d <Action>(Debug)
map <leader>a <Action>(Annotate)
map <leader>l <Action>(GitUpdateSelectedBranchAction)

