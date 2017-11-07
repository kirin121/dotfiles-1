" ============================================================================
" DKO
" A dark truecolor Vim colorscheme
" ============================================================================

if !has('termguicolors') || !&termguicolors | finish | endif

hi! clear
set background=dark
syntax reset

let g:colors_name = 'dko'

" ============================================================================
" My colors
" ============================================================================

hi default dkoBgAlt         guibg=#242424
hi default dkoLight         guibg=#333333  guifg=#bbbbbb

hi default dkoComment                      guifg=#666677  gui=italic
hi default dkoDiffAdded     guibg=#2a332a  guifg=#668844
hi default dkoDiffRemoved   guibg=#4a2a2a  guifg=#aa6666
hi default dkoEmComment     guibg=#323232  guifg=#ddaa66  gui=bold
hi default dkoFunctionName                 guifg=#99aa99
hi default dkoImportant                    guifg=#cc6622
hi default dkoOperator                     guifg=#eeeeee
hi default dkoStatement                    guifg=#aaaacc
hi default dkoStatus        guibg=#333333                 gui=NONE
hi default dkoString                       guifg=#eedd99
hi default link dkoUnimportant dkoComment

" JavaDoc
hi default link dkoJavaDocTag            dkoStatement
hi default link dkoJavaDocType           dkoStatement
hi default link dkoJavaDocKey            dkoStatement

" Statusline Symbols
hi default dkoLineImportant   guibg=#ddaa66      guifg=#323232
hi default link dkoLineModeReplace       dkoLineImportant
hi default link dkoLineNeomakeRunning    dkoLineImportant

" Signs
hi default       dkoSignError            guibg=#5a2a2a     guifg=#cc4444
hi default link  dkoSignAdded            dkoDiffAdded
hi default link  dkoSignRemoved          dkoDiffRemoved
hi default       dkoSignChanged          guibg=#2c2b2a     guifg=#ffddaa

" ============================================================================
" Vim base
" ============================================================================

hi! normal          guibg=#222222   guifg=#bbbbbb

" ~ markers before and after buffer and some other ui
hi! NonText                         guifg=#334455
hi! Visual          guibg=#afa08f   guifg=#1f1f1f
" e.g. <C-v> symbols
hi! SpecialKey                      guifg=#772222
" e.g. 'search hit BOTTOM' messages
hi! WarningMsg                      guifg=#ccaa88
hi! Whitespace      guibg=#221f1f   guifg=#552222
hi! Number                          guifg=#ee7777

hi! link Comment      dkoComment
hi! link Conditional  normal
hi! link Constant     normal
hi! link Delimiter    dkoImportant
hi! link Folded       dkoLight
hi! link Function     dkoFunctionName
hi! link Identifier   dkoStatement
hi! link Include      normal
hi! link Keyword      normal
hi! link Label        dkoStatement
hi! link Noise        dkoUnimportant
hi! link Operator     dkoOperator
hi! link PreProc      dkoString
hi! link Special      Delimiter
hi! link Statement    dkoStatement
hi! link String       dkoString
hi! link Title        dkoString
hi! link Todo         dkoEmComment
hi! link Type         dkoStatement

" ============================================================================
" Line backgrounds
" ============================================================================

" fg is thin line
hi! VertSplit           guibg=#242424   guifg=#242424
hi! LineNr              guibg=#242424   guifg=#444444
hi! CursorLineNr        guibg=#2c2c2c   guifg=#4a4a4a
hi! link SignColumn     LineNr

hi! link ColorColumn    dkoBgAlt
hi! link CursorColumn   dkoBgAlt
hi! link CursorLine     dkoBgAlt

" ============================================================================
" Status and tab line
" ============================================================================

" Statusline uses fg as bg
hi! StatusLineNC        guibg=#2c2c2c gui=NONE
hi! link StatusLine     dkoStatus
hi! link TabLine        dkoStatus
hi! link TabLineFill    dkoStatus
hi! link TabLineSel     dkoStatus

" ============================================================================
" Command mode
" ============================================================================

hi! link Directory dkoStatement

" ============================================================================
" Popup menu
" ============================================================================

hi! link Pmenu dkoLight
hi! PmenuSel       guibg=#444444
" popup menu scrollbar
hi! link PmenuSbar PmenuSel
hi! PmenuThumb     guibg=#555555

" ============================================================================
" Search
" ============================================================================

hi! Search         guibg=#aa8866   guifg=#222222

" ============================================================================
" Plugin provided signs
" ============================================================================

hi! link ALEErrorSign             dkoSignError
hi! link QuickFixSignsDiffAdd     dkoSignAdded
hi! link QuickFixSignsDiffChange  dkoSignChanged
hi! link QuickFixSignsDiffDelete  dkoSignRemoved
hi! link GitGutterAdd             dkoSignAdded
hi! link GitGutterChange          dkoSignChanged
hi! link GitGutterChangeDelete    dkoSignChanged
hi! link GitGutterDelete          dkoSignRemoved

" ============================================================================
" Diff
" ============================================================================

hi! link diffFile       dkoUnimportant
hi! link diffIndexLine  dkoUnimportant
hi! link diffLine       dkoUnimportant
hi! link diffNewFile    dkoUnimportant

hi! link diffAdded      dkoDiffAdded
hi! link diffRemoved    dkoDiffRemoved

" ============================================================================
" Git (committia)
" ============================================================================

hi! link gitKeyword         dkoStatement
hi! link gitDate            dkoString
hi! link gitHash            dkoUnimportant

" ============================================================================
" JavaScript
" ============================================================================

hi! link jsModuleKeyword    dkoString
hi! link jsStorageClass     normal
hi! link jsReturn           dkoImportant
hi! link jsNull             dkoImportant
hi! link jsThis             dkoStatement

" group {Event} e
" token Event
hi! link jsDocType          dkoJavaDocType
hi! link jsDocTypeNoParam   dkoJavaDocType
" token { }
hi! link jsDocTypeBrackets  dkoUnimportant

hi! link jsDocTags          dkoJavaDocTag
hi! link jsDocParam         dkoJavaDocKey

hi! link jsVariableDef      dkoStatement

" group 'class InlineEditors extends Component'
hi! link jsClassDefinition    dkoStatement
hi! link jsClassKeyword       dkoStatement
hi! link jsExtendsKeyword     dkoStatement

" group 'editorInstances = {};'
hi! link jsClassProperty      normal

" token 'componentWillMount'
hi! link jsClassFuncName      normal

hi! link jsFuncCall           dkoFunctionName
hi! link jsFuncArgs           dkoStatement
hi! link jsParen              dkoStatement

hi! link jsBracket            dkoStatement
hi! link jsSpreadExpression   dkoStatement
hi! link jsDestructuringBlock dkoStatement

hi! link jsObject             dkoStatement
hi! link jsObjectKey          dkoStatement
hi! link jsObjectKeyComputed  dkoString
hi! link jsObjectProp         dkoStatement

" ============================================================================
" JSON
" ============================================================================

hi! link jsonEscape           dkoOperator

" ============================================================================
" PHP
" ============================================================================

hi! link phpType            Delimiter
hi! link phpDocTags         dkoJavaDocTag
hi! link phpDocParam        dkoJavaDocType
hi! link phpDocIdentifier   dkoJavaDocKey

" ============================================================================
" Sh
" ============================================================================

hi! link shCommandSub       dkoFunctionName
" token: '-f' and '--flag'
hi! link shOption           normal

" ============================================================================
" vim-plug
" ============================================================================

hi! link plugName           dkoStatement
hi! link plugSha            dkoUnimportant

" ============================================================================
" VimL
" ============================================================================

" ----------------------------------------------------------------------------
" Highlighting
" ----------------------------------------------------------------------------

" the word 'highlight' or 'hi'
hi! link vimHighlight   normal
" the word 'clear'
" First thing after 'hi'
hi! link vimGroup       normal
hi! link vimHiLink      dkoString
hi! link vimHiGroup     normal
" Don't highlight this one or it will override vim-css-colors
"hi! link vimHiGuiFgBg  normal

" ----------------------------------------------------------------------------
" Lang
" ----------------------------------------------------------------------------

" group 'function! dko#files#RefreshMru()' excluding abort
" vimFunction

" token
"hi vimCommand
"hi vimIsCommand guifg=#cc8888

hi! link vimNotFunc     normal

" group for 'set encoding=utf-8'
hi! link vimSet         normal
" token 'encoding'
hi! link vimOption      normal
" token '=utf-8' but broken on things like '=dark'
"hi! link vimSetEqual    dkoString

" group
" e.g. has()
hi! default link vimFunc        normal
hi!         link vimFuncName    normal
" token 'ThisFunction' in 'dko#ThisFunction()'
"hi          link vimUserFunc    dkoString

" the word 'let'
hi! link vimLet         normal
" '=' in let x = y
hi! link vimOper        normal
" parens
hi! link vimParenSep    dkoUnimportant
hi! link vimString      dkoString
" the word 'syntax'
hi! link vimSyntax      normal
hi! link vimSynType     normal
"hi  vimVar                          guifg=#ccccaa

" ============================================================================
" vim help
" ============================================================================

hi! link helpExample          dkoString
hi! link helpHeader           dkoUnimportant
hi! link helpHeadline         dkoString
hi! link helpHyperTextEntry   dkoUnimportant
hi! link helpHyperTextJump    dkoStatement
hi! link helpNote             dkoUnimportant
hi! link helpOption           dkoStatement
hi! link helpSectionDelim     dkoUnimportant
hi! link helpSpecial          helpOption
hi! link helpURL              dkoString
hi! link helpVim              dkoString
hi! link helpWarning          dkoUnimportant

" ============================================================================
" zsh
" ============================================================================

hi! link zshCommands          dkoStatement
hi! link zshOperator          dkoOperator
hi! link zshOptStart          dkoStatement
hi! link zshOption            normal
