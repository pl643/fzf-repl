# fzf-repl
A bash Read, Evaulate, Print, Loop using fzf to select file, directories, history at the shell level.

Motivation: sometime a tool is so useful that it should be part the primary interface. This my attempt to combine fzf as part of the command line.

The following bindings are implemented:
  - execute fzf query string - by pressing \<Enter\>, whatever is typed will get evaluted
  - edit selected fzf item - mapped to (C-e)
  - fc (fix command)  - edit and execute selected fzf item (C-f)
  - start lazygit in folder of selected fzf item (C-g)
  - execute selected fzf item (C-x)
  - history of repl commands and selections
  
The above mapping allows this workflow:
  - select file using fzf
  - C-e to edit
  - C-x to execute file
  - C-g to startup lazygit
  - all with minimum typing
