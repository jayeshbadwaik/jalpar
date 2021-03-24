" Indentations among other things
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" Do not Confirm YCM Extra Configuration File
let g:ycm_confirm_extra_conf = 0

" Tagbar Plugin
let g:tagbar_left = 1
let g:tagbar_vertical = 20
let g:tagbar_previewwin_pos = "botright"
let g:ycm_autoclose_preview_window_after_insertion = 1
nmap <F10> :TagbarOpenAutoClose<CR>

" Do not Confirm YCM Extra Configuration File
let g:ycm_confirm_extra_conf = 0

nnoremap <F7> :YcmForceCompileAndDiagnostics <CR>
map <F9> :YcmCompleter FixIt<CR>


" Automatic C / C++ header guards
function! s:insert_gates()
  set formatoptions-=cro
  let gatename_0 = substitute(substitute(toupper(@%), "\\.", "_", "g"), "/", "_", "g")
  let gatename_1 = substitute(gatename_0, "SRC_INCLUDE_", "", "g")
  let gatename_2 = substitute(gatename_1, "TEST_INCLUDE_", "", "g")
  let gatename_3 = substitute(gatename_2, "BENCH_INCLUDE_", "", "g")
  let gatename_4 = substitute(gatename_3, "SRC_LIB_INCLUDE_", "", "g")
  let gatename = gatename_4
  execute "normal! o#ifndef " . gatename
  execute "normal! o#define " . gatename
  normal! o
  execute "normal! Go#endif // " . gatename
  set formatoptions-=cro
  normal! k
endfunction


function! s:insert_license_cpp()
  set formatoptions-=cro
  execute "normal! i//-------------------------------------------------------------------------------"
  execute "normal! o// SPDX-License-Identifier: \"GPL-2.0-only WITH GCC-exception-2.0\""
  execute "normal! o// Copyright (C) 2021-2021, Jayesh Badwaik <j.badwaik@fz-juelich.de>"
  execute "normal! o//-------------------------------------------------------------------------------"
  normal! o
  set formatoptions+=cro
endfunction

function! s:insert_license_cmake()
  set formatoptions-=cro
  execute "normal! i#------------------------------------------------------------------------------"
  execute "normal! o# SPDX-License-Identifier: \"Unlicense\""
  execute "normal! o# Copyright (C) 2021-2021, Jayesh Badwaik <j.badwaik@fz-juelich.de>"
  execute "normal! o#------------------------------------------------------------------------------"
  set formatoptions+=cro
endfunction

function! s:insert_license_bash()
  set formatoptions-=cro
  execute "normal! i#------------------------------------------------------------------------------"
  execute "normal! o# SPDX-License-Identifier: \"Unlicense\""
  execute "normal! o# Copyright (C) 2021-2021, Jayesh Badwaik <j.badwaik@fz-juelich.de>"
  execute "normal! o#------------------------------------------------------------------------------"
  set formatoptions+=cro
endfunction

function! s:insert_license_html()
  set formatoptions-=cro
  execute "normal! i<!--"
  execute "normal! oSPDX-License-Identifier: \"CC-BY-SA-4.0\""
  execute "normal! oCopyright (C) 2021-2021, Jayesh Badwaik <j.badwaik@fz-juelich.de>"
  execute "normal! o-->"
  set formatoptions+=cro
endfunction

function! Insert_license_cpp()
  execute "normal! O"
  call s:insert_license_cpp()
endfunction

function! Insert_license_cmake()
  execute "normal! O"
  call s:insert_license_cmake()
endfunction

function! Insert_license_html()
  execute "normal! O"
  call s:insert_license_html()
endfunction

function! s:prepare_hpp()
  call s:insert_license_cpp()
  call s:insert_gates()
endfunction

autocmd BufNewFile *.{h} call <SID>prepare_hpp()
autocmd BufNewFile *.{c} call <SID>insert_license_cpp()
autocmd BufNewFile *.{hpp} call <SID>prepare_hpp()
autocmd BufNewFile *.{cpp} call <SID>insert_license_cpp()
autocmd BufNewFile *.{ipp} call <SID>insert_license_cpp()
autocmd BufNewFile CMakeLists.txt call <SID>insert_license_cmake()
autocmd BufNewFile *.cmake call <SID>insert_license_cmake()
autocmd BufNewFile *.{bash} call <SID>insert_license_bash()
autocmd BufNewFile *.{sh} call <SID>insert_license_bash()
autocmd BufNewFile *.{md} call <SID>insert_license_html()


" Remove Trailing Whitespace on Save
autocmd BufWritePre * %s/\s\+$//e

" Show trailing whitespace:
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

augroup filetypedetect
    au BufRead,BufNewFile *.jnum set filetype=json
augroup END
