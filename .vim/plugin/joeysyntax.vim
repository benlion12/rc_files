:command! Joeysyntax call s:Joeysyntax()

:function! s:Joeysyntax()

	" For slow computers:
	" :syn sync maxlines=50
	" :syn sync minlines=10

	" :colors pablo
	" :set guifont=-schumacher-clean-medium-r-normal-*-*-120-*-*-c-*-iso646.1991-irv
	" :set guifont=-schumacher-clean-medium-r-normal-*-*-150-*-*-c-*-iso646.1991-irv
	" :set guifont=-b&h-lucidatypewriter-medium-r-normal-*-*-100-*-*-m-*-iso8859-1
	" :set guifont=-b&h-lucidatypewriter-medium-r-normal-*-*-100-*-*-m-*-iso8859-1
	" :set guifont=-b&h-lucidatypewriter-medium-r-normal-*-*-80-*-*-m-*-iso8859-1
	" :set guifont=-schumacher-clean-medium-r-normal-*-*-120-*-*-c-*-iso646.1991-irv
	" :set guifont=-b&h-lucidatypewriter-medium-r-normal-*-14-*-*-*-m-*-iso10646-1
	:set guifont=-b&h-lucidatypewriter-medium-r-normal-*-*-80-*-*-m-*-iso10646-1
	:set background=dark

	:syntax on

	" :syntax region javaClassLine start=/class / end=/{/ contains=javaClassDecl

	" for jfc diffs
	:syntax keyword jDiff @@>>

	" for Mason
	:syntax region jComment start="/\*"  end="\*/"

	" for sh
	:syntax region jShComment start="[#]*## " end='$'
	:highlight link jShComment jComment

	:syntax match jEq /=/
	:highlight link jEq Statement

	" :syntax keyword jTodo TODO
	" :highlight link jTodo Todo
	" :syntax keyword jNote NOTE
	" :highlight link jNote Todo
	"" Marche pas:
	:syntax keyword jTodo TODO Todo NOTE Note
	:highlight link jTodo Todo

	"" Log4j:
	" :syntax match log4jDebug " DEBUG "
	" :syntax match log4jInfo  " INFO "
	" :syntax match log4jWarn  " WARN "
	" :syntax match log4jError " ERROR "
	:syntax match log4jDebug "^.* DEBUG .*$"
	:syntax match log4jInfo  "^.* INFO .*$"
	:syntax match log4jWarn  "^.* WARN .*$"
	:syntax match log4jError "^.* ERROR .*$"

:endfun

" :Joeysyntax
