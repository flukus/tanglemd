
# TangleMD - Code first tangling

Warning: The current implimentation is a couple of bash scripts, and not well written ones.
This project is at the proof of concept stage.
Don't use this tool on code you value, especially if it's not backed up.

TangleMD is a literate programming/documentation tool designed to integrate well with existing projects.
It was primarily born out of frustrations with existing tools which appeared to have a very different focus to mine. See problems with Literate Programming for more details of why I wrote a new tool.

The code first approach means that the source code is considered the master copy and that the tangler is syntax aware.
TangleMD files will pull relevent code chunks together with markdown to produce an editable document. This document can then be untangled and the code will be merged back to it's source.
This approach means TangleMD can be used with minimal/no impact on other developers on the project and works in a complimentary way with tools like source control. TangleMD files themselves are source control friendly because they do not contain code by default.

# Example

# Problems with Literate Programming

* Focus on publishing, particularly dead tree publishing
* Treats documentation as source of truth
* Doesn't integrate with existing programs (will overwrite fresh checkouts)
* Leave artifacts in code (source of tangling)
* poor integration with editors for syntax highlighting

# How to address

* Syntax aware tangling
** comment artifact tangling as backup
* user editing virtual file
* treat code as master
* use mostly standard markdown

# Vim Integration

```vim
function ReadLit()
	sil exe 'r!../../tangle.sh' shellescape(expand("<afile>"))
	set syntax=markdown
endfunction

function WriteLit()
	sil exe 'w !tee | ../../untangle.sh' shellescape(expand("<afile>"))
	set nomodified
endfunction

augroup lit
	au!
	au BufReadCmd *.tmd call ReadLit()
	au BufWriteCmd *.tmd call WriteLit()
augroup end
```

