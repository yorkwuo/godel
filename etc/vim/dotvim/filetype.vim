" my filetype file
if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
  au! BufRead,BufNewFile *.f    setfiletype verilog
  au! BufRead,BufNewFile *.vg    setfiletype verilog
  au! BufRead,BufNewFile *.log    setfiletype tcl
  au! BufRead,BufNewFile *.spi    setfiletype spice
  au! BufRead,BufNewFile *.l    setfiletype spice
  au! BufRead,BufNewFile *.scs    setfiletype spice
  au! BufRead,BufNewFile *.sp    setfiletype spice
  au! BufRead,BufNewFile *.dspf    setfiletype spice
  au! BufRead,BufNewFile *.cpf    setfiletype cpf
  au! BufRead,BufNewFile *.ver    setfiletype vpx
  au! BufRead,BufNewFile *.ruc    setfiletype xml
  au! BufRead,BufNewFile *.tdef    setfiletype tcl
  au! BufRead,BufNewFile *.i    setfiletype lip
  au! BufRead,BufNewFile *.do    setfiletype vpx
  au! BufRead,BufNewFile *.lib    setfiletype c
  au! BufRead,BufNewFile *.upf    setfiletype upf
augroup END

