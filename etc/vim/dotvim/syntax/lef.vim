" Vim filetype plugin file
" Language:	    LEF (Library Exchange Format)
" Maintainer:	Levon Ohanyan <lvnohanyan@gmail.com>
" Last Change:	Mon Nov 18 15:31:24 AMT 2013
" Version: 1.0

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

set nofoldenable
" LEF global const
syn keyword global_const VERSION DIVIDERCHAR BUSBITCHARS MANUFACTURINGGRID NAMESCASESENSITIVE

" LEF keywords
syn keyword basic_keywords MACRO CLASS FOREIGN ORIGIN SIZE SYMMETRY UNITS EEQ SITE
syn keyword basic_keywords USEMINSPACING CLEARANCEMEASURE CLEARANCEMEASURE MAXVIASTACK VIA VIARULE VIARULE
syn keyword basic_keywords GENERATE NONDEFAULTRULE SITE LIBRARY

" LEF Extension Statement
syn keyword lef_extension BEGINEXT CREATOR DATE REVISION ENDEXT

syn keyword basic_keywords TYPE CUT
syn keyword basic_keywords SPACING
syn keyword basic_keywords CENTERTOCENTER
syn keyword basic_keywords SAMENET
syn keyword basic_keywords STACK
syn keyword basic_keywords ADJACENTCUTS
syn keyword basic_keywords WITHIN
syn keyword basic_keywords EXCEPTSAMEPGNET
syn keyword basic_keywords PARALLELOVERLAP
syn keyword basic_keywords PROPERTY
syn keyword basic_keywords SPACINGTABLE ORTHOGONAL
syn keyword basic_keywords ARRAYSPACING LONGARRAY WIDTH CUTSPACING
syn keyword basic_keywords ARRAYCUTS SPACING
syn keyword basic_keywords WIDTH
syn keyword basic_keywords ENCLOSURE ABOVE BELOW
syn keyword basic_keywords WIDTH EXCEPTEXTRACUT
syn keyword basic_keywords LENGTH
syn keyword basic_keywords PREFERENCLOSURE
syn keyword basic_keywords RESISTANCE
syn keyword basic_keywords ACCURRENTDENSITY PEAK AVERAGE RMS
syn keyword basic_keywords FREQUENCY
syn keyword basic_keywords CUTAREA
syn keyword basic_keywords TABLEENTRIES

" LEF types
syn keyword lef_types ANTENNAMODEL ANTENNAAREARATIO ANTENNADIFFAREARATIO ANTENNACUMAREARATIO
syn keyword lef_types ANTENNACUMDIFFAREARATIO ANTENNAAREAFACTOR ANTENNACUMROUTINGPLUSCUT
syn keyword lef_types ANTENNAGATEPLUSDIFF ANTENNAAREAMINUSDIFF ANTENNAAREADIFFREDUCEPWL
syn keyword lef_types DCCURRENTDENSITY ACCURRENTDENSITY ANTENNAGATEAREA

" LEF types
syn keyword lef_vals OXIDE1 OXIDE2 OXIDE3 OXIDE4 PWL DIFFUSEONLY AVERAGE PEAK AVERAGE RMS

" Clearance Measure
syn keyword clearance_measure CLEARANCEMEASURE MAXXY EUCLIDEAN

" LEF CLASS types
syn keyword class_type COVER BUMP RING BLOCK BLACKBOX SOFT PAD INPUT OUTPUT INOUT POWER
syn keyword class_type SPACER AREAIO CORE FEEDTHRU TIEHIGH TIELOW SPACER ANTENNACELL WELLTAP
syn keyword class_type ENDCAP PRE POST TOPLEFT TOPRIGHT BOTTOMLEFT BOTTOMRIGHT

" LEF MACRO statements
syn keyword macro_statement PIN OBS

syn keyword local_var POLYGON RECT

" LEF PIN properties
syn keyword pin_props DIRECTION PORT PATH SHAPE ABUTMENT RING FEEDTHRU USE MUSTJOIN
syn keyword pin_props ANTENNAPARTIALMETALAREA ANTENNAPARTIALMETALSIDEAREA ANTENNAPARTIALCUTAREA
syn keyword pin_props ANTENNADIFFAREA ANTENNAGATEAREA ANTENNAMAXAREACAR
syn keyword pin_props ANTENNAMAXSIDEAREACAR ANTENNAMAXCUTCAR

" LAYERS
syn keyword layer LAYER
syn keyword layer_types  METAL1 METAL2 METAL3 METAL4 METAL5 METAL6 METAL7 
syn keyword layer_types  METAL8 METAL9 METAL10 METAL11 METAL12 METAL13 METAL14 
syn keyword layer_types  METAL15 METAL16 METAL17 METAL18 METAL19 METAL20
syn keyword layer_types  M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11 M12 M13 M14 M15 M16 M17 M18 M19 M20
syn keyword layer_types  m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 m13 m14 m15 m16 m17 m18 m19 m20
syn keyword layer_types  VIA01 VIA12 VIA23 VIA34 VIA45
syn keyword layer_types  VIA56 VIA67 VIA78 VIA89 VIA910
syn keyword layer_types  VIA1011 VIA1112 VIA1213 VIA1314 VIA1415
syn keyword layer_types  VIA1516 VIA1617 VIA1718 VIA1819 VIA1920
syn keyword layer_types  VIA1 VIA2 VIA3 VIA4 VIA5 VIA6 VIA7 VIA8 VIA9 VIA10 VIA11 VIA12
syn keyword layer_types  VIA13 VIA14 VIA15 VIA16 VIA17 VIA18 VIA19 VIA20
syn keyword layer_types  TEXT1  TEXT2  TEXT3  TEXT4  TEXT5 
syn keyword layer_types  TEXT6  TEXT7  TEXT8  TEXT9  TEXT10
syn keyword layer_types  TEXT11 TEXT12 TEXT13 TEXT14 TEXT15
syn keyword layer_types  TEXT16 TEXT17 TEXT18 TEXT19 TEXT20

syn keyword todo contained TODO FIXME XXX NOTE FIXME: XXX: TODO:
syn match comment "#.*$" contains=todo

" Regular int like number can contain -/+ in front
syn match nums '[ -]\d\+\ \d*'
syn match nums '[ +]\d\+\ \d*'
syn match nums '[ .]\d\+\ \d*'

" Floating point numbers (+/-)
syn match nums '\d\+\.\d*'
syn match nums '[-+]\d\+\.\d*'

" Floating point like numbers can contain e/E (+,-)
syn match nums '[-+]\=\d[[:digit:]]*[eE][\-+]\=\d\+'
syn match nums '\d[[:digit:]]*[eE][\-+]\=\d\+'
syn match nums '[-+]\=\d[[:digit:]]*\.\d*[eE][\-+]\=\d\+'
syn match nums '\d[[:digit:]]*\.\d*[eE][\-+]\=\d\+'

syn match ErrorNumber  ' -\0\ '

syn match db_macrons "\<DATABASE\s\+MICRONS\>"
syn match end "^\(.*END\)"
"syn match end "\v^(.*END)&(*LIBRARY)@!"

syn region str start='"' end='"'
hi link str String

hi link lef_def_region Todo

set showmatch

hi def link basic_keywords  Keyword
hi def link todo            Todo
hi def link comment         Comment
hi def link class_type      Type
hi def link nums            Number
hi def link ErrorNumber     Error
hi def link layer           EnumerationName
hi def link layer_types     Typedef
hi def link lef_types       EnumerationName
hi def link lef_vals        EnumerationValue
hi def link global_const    Define
hi def link macro_statement Statement
hi def link lef_extension   Statement
hi def link local_var       Label
hi def link end             Fragment
hi def link pin_props       Property
hi def link db_macrons      GlobalConstant

let b:current_syntax = "lef"

