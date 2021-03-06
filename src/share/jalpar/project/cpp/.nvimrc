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

function! s:insert_license_slashslash()
  set formatoptions-=cro
  execute "normal! i//------------------------------------------------------------------------------"
  execute "normal! o// SPDX-License-Identifier: \"Apache-2.0 OR MIT\""
  execute "normal! o// Copyright (C) 2020, Jayesh Badwaik <jayesh@badwaik.in>"
  execute "normal! o//------------------------------------------------------------------------------"
  set formatoptions+=cro
endfunction

function! s:insert_license_hash()
  set formatoptions-=cro
  execute "normal! i#------------------------------------------------------------------------------"
  execute "normal! o# SPDX-License-Identifier: \"Apache-2.0 OR MIT\""
  execute "normal! o# Copyright (C) 2020, Jayesh Badwaik <jayesh@badwaik.in>"
  execute "normal! o#------------------------------------------------------------------------------"
  set formatoptions+=cro
endfunction

function! s:prepare_hpp()
  call s:insert_license_slashslash()
  call s:insert_gates()
endfunction

autocmd BufNewFile *.{h} call <SID>prepare_hpp()
autocmd BufNewFile *.{c} call <SID>insert_license_slashslash()
autocmd BufNewFile *.{hpp} call <SID>prepare_hpp()
autocmd BufNewFile *.{cpp} call <SID>insert_license_slashslash()
autocmd BufNewFile *.{ipp} call <SID>insert_license_slashslash()
autocmd BufNewFile CMakeLists.txt call <SID>insert_license_hash()
autocmd BufNewFile *.cmake call <SID>insert_license_hash()
autocmd BufNewFile *.{bash} call <SID>insert_license_hash()
autocmd BufNewFile *.{sh} call <SID>insert_license_hash()


" Remove Trailing Whitespace on Save
autocmd BufWritePre * %s/\s\+$//e

" Show trailing whitespace:
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

augroup filetypedetect
    au BufRead,BufNewFile *.jnum set filetype=json
augroup END
