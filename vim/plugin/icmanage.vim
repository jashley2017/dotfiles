" Functions for performing ICManage operations on current buffer

" TODO: Add appropriate header and vi doc format documentation
" TODO: See if there are classes, modules, or namespaces in vi
" TODO: figure out a cleaner way to do optional argument parsing
" TODO: Write a message reporting delivery module

" Run icmp4 command (action) on current file
"   The ... argument says that any number of optional arguments can be specified
"   A specific number of optional arguments cannot be specified nor can optargs be named
function! Icmp4ThisFile(action, ...)
    " Optional argument initialization
    "let backup       = 0
    let presync      = 0
    let quiet        = 0
    let verbose_mode = 0

    let retval       = 0

    if verbose_mode
        echo a:action
    end

    "" Option to create a backup of the buffer (%.orig) before performing the action
    "if backup
    "    if a:0 > 0
    "        let backup   = a:1
    "        let origfile = expand("%") . ".orig"
    "        "echo "DEBUG: backup = " . backup
    "    end
    "end

    " Option to sync file first
    if a:0 > 1
        if a:action == "sync"
            throw "ERROR: Doing a sync with presync set to 1 would cause an infinite loop. Refusing."
        else
            let presync = a:2
        end
        "echo "DEBUG: presync = " . a:2
    end

    " Option to echo the action output (0) or return it (1).
    if a:0 > 2
        let quiet = a:3
        "echo "DEBUG: quiet = " . quiet
    end

    " Make sure to raise an error if too many arguments are specified
    if a:0 > 3
        " TODO: Use try, catch, and endtry as well in this function
        throw "ERROR: Too many arguments specified for Icmp4ThisFile function"
    end

    " Copy unmodified buffer to filename.orig before modifying the buffer
    "if backup
    "    " TODO: Check if .orig exists first and prompt for overwrite or cancel
    "    "       Write a function prompt_for_overwrite. It would probably make
    "    "       sense to have the prompting as an option.  Depends on how often
    "    "       it occurs in practice.
    "    if filereadable(origfile)
    "        call delete(origfile)
    "    end
    "    " TODO: figure out how to pass a variable to write instead of reling
    "    "       on percent.
    "    echo "INFO: Creating a backup: ".%.".orig"
    "    write! %.orig
    "end

    " Check if file is already opened so as to not accidentally hide that a file needs resolved.
    if presync
        " Perhaps it would be good to check icmp4 resolve before doing a sync as well.
        let openedout = Icmp4ThisFile("opened", 0, 0, 1)
        if matchstr(openedout, "edit default change")
            echo "WARNING: Skipping sync.  File is already opened"
        else
            call Icmp4ThisFile("sync")
        end
    end

    let output = RunCommand( "cd " . expand("%:p:h") . "; icmp4 " . a:action . " " . expand("%:t"), quiet, verbose_mode )

    " Are these actually necessary
    if a:action == "edit"
        edit
        set  modifiable
    end

    if quiet
        let retval = output
    end

    return retval
endfunction

" Run icmp4 command (action) on current file and store output to file.action
" TODO: make storing action output being stored another optional argument to Icmp4ThisFile
function! Icmp4ThisFileStoreOutput(action, opts)
    call RunCommand( "cd " . expand("%:p:h") . "; icmp4 " . a:action . " " . a:opts . " " . expand("%:t") . " > " . expand("%:t") . "." . a:action )

    " TODO: Is this necessary?
    edit
endfunction

" Run icmp4 command (action) on current directory
function! Icmp4ThisDir(action)
    call RunCommand( "cd " . expand("%:p:h") . "; icmp4 " . a:action . " ..." )

    " TODO: Is this necessary?
    edit
endfunction

function! RunCommand(cmd, ...)
    let quiet        = 0
    " Setting to 1 until fully tested
    let verbose = 0

    let retval = 0

    " Parse Options
    " TODO: Write an option parser module
    " Option for quiet mode (return result of command instead of echo
    if a:0 > 0
        let quiet    = a:1
    end
    " Option for quiet mode (return result of command instead of echo
    if a:0 > 1
        let verbose = a:2
    end
    if a:0 > 2
        throw "ERROR: Too many arguments specified for RunCommand function"
    end

    " Run command
    if verbose
        echo "Running: " . a:cmd
    end
    let output = system(a:cmd)

    if quiet
        let retval = output
    else
        echo output
    end

    return retval
endfunction

" Run icmp4 command (action) on current file
function! Icmp4Revert(action)
    " Copy current revision to new to get a cheap icmp4 diff for later
    " TODO: reintegrate this function into Icmp4ThisFile with an option to delete the backup

    diffoff

    " Save the current buffer if modified so that the action does not fail
    if &modified
        write
    end

    call RunCommand( "cd " . expand("%:p:h") . "; icmp4 " . a:action . " " . expand("%:t") )

    " TODO: Check if a buffer for this file is open first
    "let origfile = expand("%:p") . ".orig"
    "if filereadable(origfile)
    "    call delete(origfile)
    "end

    " TODO: Is this necessary?
    view
endfunction

function! Icmp4Diff()
    " Save file
    " TEST: only save if necessary
    "" if &modified
    ""     write
    "" end

    " Split the window and open the orig file (nomodifiable)
    "" let origfile = expand("%") . ".orig"
    "" if filereadable(origfile)
    ""     wincmd v
    ""     view   %.orig
    ""     set    nomodifiable
    ""     diffthis

    ""     " Switch to the editted file and diff
    ""     wincmd l
    ""     diffthis
    ""     set foldlevel=0
    "" else
    ""     throw "ERROR: Cannot read " . origfile
    "" end
    let current_filetype = &filetype
    vnew
    " Here the # refers to the previous buffer, which is our original file
    " The \#head is an escaped #head and in icmanage refers to the latest version of the file
    execute 'read !icmp4 print -q #\#head'
    " A deleterious line shows up at the top of the file due to the creation of the buffer
    norm ggdd
    execute 'set filetype='.current_filetype
    set buftype=nowrite
    windo diffthis
endfunction

" Forks a graphical icmp4 diff with vault
" Combine this and Icmp4Diff, make fork a optional argument
function! Icmp4DiffFork()
    " Save file
    write

    " Get rid of the swapfile
    set updatecount=0
    view

    " Run icm command
    call RunCommand( "cd " . expand("%:p:h") . "; env P4DIFF='gvimdiff -f -n' icmp4 diff " . expand("%:t") )

    " Re-open file for possible changes and create new swapfile
    set updatecount=200
    edit
endfunction

" Get an old revision of this file
function! Icmp4Print(revision, ...)
    " Get the revision of the specified file
    if a:0 > 0
        let filepassed = a:1
    end
    " Make sure to raise an error if too many arguments are specified
    if a:0 > 1
        " TODO: Use try, catch, and endtry as well in this function
        throw "ERROR: Too many arguments specified for Icmp4ThisFile function"
    end

    if exists('filepassed')
       let icmfile = filepassed
    else
       let icmfile = expand("%")
    endif

    let localFile = icmfile . "."   . a:revision
    let filerev   = fnamemodify( icmfile, ':t' ) . "\\#" . a:revision
    let filedir   = fnamemodify( icmfile, ':p:h' )
    echo "Info: Creating ".localFile

    " Run icm command
    call RunCommand( "csh -c \"cd " . filedir . "; icmp4 print -q -o " . localFile . " " . filerev . "\"" )

    " Open the new file in a vertical split
    wincmd v
    wincmd l
    exec 'view' localFile
endfunction

function! PrintRevisionUnderCursor()
   let revision = expand("<cword>")

   " Strip off extension because this is expected to be used from within a
   " filename.ext.annotate or filename.ext.filelog file
   call Icmp4Print(revision, expand("%:p:r"))
endfunction

command! Ice call Icmp4ThisFile("edit", 1, 1)
cabbrev ice Ice

"command! Icr call Icmp4ThisFile("revert")
command! Icr call Icmp4Revert("revert")
cabbrev icr Icr

"command! Icp call PrintRevisionUnderCursor()
"cabbrev icp Icp
nmap <script> <Leader>ip :call PrintRevisionUnderCursor()<CR>

" TODO: figure out how to _soft_ map something 
nmap <script> <Leader>ia :call Icmp4ThisFileStoreOutput("annotate", "-dwq")<CR><C-w>v<C-w><C-w>:e %.annotate<CR>

nmap <script> <Leader>if :call Icmp4ThisFileStoreOutput("filelog", "-L")<CR><C-w>v<C-w><C-w>:e %.filelog<CR>

command! Ics call Icmp4ThisFile("sync")
cabbrev ics Ics

command! Ico call Icmp4ThisDir("opened")
cabbrev ico Ico

command! Icd call Icmp4Diff()
cabbrev icd Icd

command! IcdFork call Icmp4DiffFork()
cabbrev icdfork IcdFork
