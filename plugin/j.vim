command! -nargs=1 -complete=customlist,j#complete -bar -bang J call j#j(<bang>0, <q-args>)
