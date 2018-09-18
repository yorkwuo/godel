" Vim syntax file
" Language:     Unified Power Format (UPF) standard version 1.0
" Maintainer:   
" Last Update:  May 20 2008
" Filenames:    *.qrc *.mv
" URL:          
"
" UPF provides the ability for electronic systems to be designed with power as a key consideration early in the process 
" of chip design
"
" History:
"       Aditya Kher created version for UPF 1.0
"

syn clear

" A bunch of useful Vera keywords
syn keyword qrcCommand extraction_setup extract filter_coupling_cap input_db log_file output_db output_setup process_technology

syn keyword qrcParameter -preplace -technology_layer_map

syn keyword qrcStatement		both  

syn keyword qrcTodo include

"syn match qrcCommand "-" contains=qrcCommand
setlocal iskeyword+=-
syn keyword qrcCommand when-not


syn match   qrcOperator "[&|~><!)(*#%@+/=?:;}{,.\^\-\[\]]"

"syn region  qrcComment start="/\*" end="\*/" contains=qrcTodo
"syn match   qrcComment "#.*" contains=qrcTodo

"syn match   qrcGlobal "`[a-zA-Z0-9_]\+\>"
"syn match   qrcGlobal "$[a-zA-Z0-9_]\+\>"

"syn match   qrcConstant "\<[A-Z][A-Z0-9_]\+\>"

syn match   qrcNumber "\(\<[0-9]\+\|\)'[bdh][0-9a-fxzA-FXZ_]\+\>"
syn match   qrcNumber "\<[+-]\=[0-9]\+\>"

syn region  qrcString start=+"+  end=+"+


"copied these from the c.vim file and modified
syn region qrcPreCondit start="^\s*#\s*\(if\>\|ifdef\>\|ifndef\>\|elif\>\|else\>\|endif\>\)" skip="\\$" end="$" contains=qrcComment,qrcString,qrcCharacter,qrcNumber
syn region qrcIncluded contained start=+"+ skip=+\\\\\|\\"+ end=+"+
syn match qrcIncluded contained "<[^>]*>"
syn match qrcInclude           "^\s*#\s*include\>\s*["<]" contains=qrcIncluded
syn region qrcDefine           start="^\s*#\s*\(define\>\|undef\>\)" skip="\\$" end="$" contains=ALLBUT,qrcPreCondit,qrcIncluded,qrcInclude,qrcDefine,qrcOperator
syn region qrcPreProc start="^\s*#\s*\(pragma\>\|line\>\|warning\>\|warn\>\|error\>\)" skip="\\$" end="$" contains=ALLBUT,qrcPreCondit,qrcIncluded,qrcInclude,qrcDefine


""catch errors caused by wrong parenthesis and brackets
"" also accept <% for {, %> for }, <: for [ and :> for ] (C99)
"" But avoid matching <::.
syn cluster	qrcParenGroup	contains=qrcParenError
if exists("qrc_no_bracket_error")
  syn region	qrcParen		transparent start='(' end=')' contains=ALLBUT,@qrcParenGroup,qrcBracket,@Spell
  syn match	qrcParenError	display ")"
  syn match	qrcErrInParen	display contained "[{}]\|<%\|%>"
else
  syn region	qrcParen		transparent start='(' end=')' contains=ALLBUT,@qrcParenGroup,qrcErrInBracket,@Spell
  syn match	qrcParenError	display "[\])]"
  syn match	qrcErrInParen	display contained "[\]{}]\|<%\|%>"
  syn region	qrcBracket	transparent start='\[\|<::\@!' end=']\|:>' contains=ALLBUT,@qrcParenGroup,qrcErrInParen,@Spell
  syn match	qrcErrInBracket	display contained "[);{}]\|<%\|%>"
endif

:runtime! syntax/c.vim

"Modify the following as needed.  The trade-off is performance versus
"functionality.
syn sync lines=75

if !exists("did_qrc_syntax_inits")
  let did_qrc_syntax_inits = 1
 " The default methods for highlighting.  Can be overridden later

		hi link qrcCommand           Type 
		hi link qrcParameter         String
  hi link qrcStatement         String
		
  hi link qrcRepeat            Repeat
  hi link qrcString            String
  hi link qrcTodo              Todo
  hi link qrcCharacter         Character
  hi link qrcConditional       Conditional

  hi link qrcDefine            Macro
  hi link qrcInclude           Include
  hi link qrcConstant          Constant
  hi link qrcLabel             PreCondit
  hi link qrcPreCondit         PreCondit
  hi link qrcNumber            Special
"  hi link qrcComment           Comment
		
  hi link qrcParenError		      Error
  hi link qrcErrInParen		      Error
  hi link qrcErrInBracket     	Error
		
endif

let b:current_syntax = "qrc"


