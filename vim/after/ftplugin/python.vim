setlocal shiftwidth=4 softtabstop=4 tabstop=4 expandtab 
setlocal syntax=python
let b:ale_linters = ['pylint']
map ,d oimport pdb;pdb.set_trace()<CR>print(":(")

