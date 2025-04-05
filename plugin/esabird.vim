" esabird.vim - Plugin entry point

if exists('g:loaded_esabird')
  finish
endif
let g:loaded_esabird = 1

" Define user command to send selected text
" Usage: Select text in visual mode, then type :EsabirdSend
command! -range EsabirdSend <line1>,<line2>call esabird#send_to_esa(visualmode())

" Define visual mode mapping
" Usage: Select text in visual mode, then press <Leader>e (default)
nnoremap <Plug>(esabird-send) :<C-u>set opfunc=esabird#send_to_esa_op<CR>g@
vnoremap <Plug>(esabird-send) :<C-u>call esabird#send_to_esa(visualmode())<CR>

if !hasmapto('<Plug>(esabird-send)', 'v')
  if !exists('g:esabird_no_default_key_mappings') || g:esabird_no_default_key_mappings == 0
    if !exists('g:esabird_mapping_key')
      let g:esabird_mapping_key = '<Leader>e'
    endif
    execute 'vmap <silent>' g:esabird_mapping_key '<Plug>(esabird-send)'
    " Optional: Map for normal mode operator pending
    " execute 'nmap <silent>' g:esabird_mapping_key '<Plug>(esabird-send)'
  endif
endif

" Operator function for normal mode mapping (optional)
function! esabird#send_to_esa_op(type) abort
  let saved_visual_mode = visualmode()
  try
    if a:type ==# 'char'
      normal! `[v`]
    elseif a:type ==# 'line'
      normal! `[V`]
    elseif a:type == 'block'
      normal! `[<C-v>`]
    else
      return
    endif
    call esabird#send_to_esa(visualmode(1))
  finally
    call visualmode(saved_visual_mode)
  endtry
endfunction

" TODO: Add configuration variables (API token, team name, etc.)