
# TangleMD - Code first tangling

Warning: The current implimentation is a couple of bash scripts, and not well written ones.
This project is at the proof of concept stage.
Don't use this tool on code you value, especially if it's not backed up.

TangleMD is a literate programming/documentation tool designed to integrate well with existing projects.
It was primarily born out of frustrations with existing tools which appeared to have a very different focus to mine. See problems with Literate Programming for more details of why I wrote a new tool.

The code first approach means that the source code is considered the master copy and that the tangler is syntax aware.
TangleMD files will pull relevent code chunks together with markdown to produce an editable document. This document can then be untangled and the code will be merged back to it's source.
This approach means TangleMD can be used with minimal/no impact on other developers on the project and works in a complimentary way with tools like source control. TangleMD files themselves are source control friendly because they do not contain code by default.

# How it Works

Let's say theres an existing C project that neds to be documented, here is the calculator.c:

```c
int multiply(int,int);

void main(int argc, char** argv) {
	multiply(7, 9);
}

int multiply(int x, int y) {
	return x * y;
}
```

Then we need some documentation on the intracies of the multiply function, so that goes in multiply.tmd:

```md 
Some paragraph explaing the limits of multiplication, here is the code

-```c calculator.c:multiply(int,int)
-```
```

The only difference from standard markdown is the "calculator.c:multiply(int,int)" in the code section declaration.
This lets tanglemd know where the actual code is.

Running "tanglemd multiply.tmd > result.tmd" will find the multiply function and weave it into the document. The result will look like this:

```md 
Some paragraph explaing the limits of multiplication, here is the code

-```c calculator.c:multiply(int,int)
int multiply(int x, int y) {
	return x * y;
}
-```
```

This function can now be edited in result.tmd.
If the result.tmd is edited so the multiple function to return 0 if either input is < 0:

```md 
Some paragraph explaing the limits of multiplication, here is the code

-```c calculator.c:multiply(int,int)
int multiply(int x, int y) {
	if (x < 0 || y < 0)
		return 0;
	return x * y;
}
-```
```

This can be untangled by running "\<result.tmd untangle multiply.tmd".
multiply.tmd will now be exactly as it was, this keeps the documetation scm friendly.
calculator.c will now have the updated version of the function.

See the vim integration for how to make this happen automatically.

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
function ReadTMD()
	sil exe 'r!tanglemd' shellescape(expand("<afile>"))
	set syntax=markdown
endfunction

function WriteTMD()
	sil exe 'w !tee | untanglemd' shellescape(expand("<afile>"))
	set nomodified
endfunction

augroup tmd
	au!
	au BufReadCmd *.tmd call ReadTMD()
	au BufWriteCmd *.tmd call WriteTMD()
augroup end
```

