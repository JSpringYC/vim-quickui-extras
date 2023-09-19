
fu! quickui#extras#menus#file#init()
    if !exists('g:menubar')
        return
    endif

    " menu
    MenuAdd {'id': 'menu_file', 'text': '&File', 'order': 100}

    " items
    MenuItemAdd {'id': 'item_file_new', 'menu_id': 'menu_file', 'text': '&New', 'command': 'enew', 'order': 100}
    MenuItemAdd {'id': 'item_file_open', 'menu_id': 'menu_file', 'text': '&Open', 'command': '#Action_open()', 'order': 200}
    MenuItemAdd {'id': 'item_file_save', 'menu_id': 'menu_file', 'text': '&Save', 'command': '#Action_save()', 'order': 300}
    MenuItemAdd {'id': 'item_file_saveAs', 'menu_id': 'menu_file', 'text': 'Save &As', 'command': '#Action_saveAs()', 'order': 400}
    MenuItemAdd {'id': 'item_file_sep1', 'menu_id': 'menu_file', 'text': '--', 'command': '', 'order': 500}
    MenuItemAdd {'id': 'item_file_exit', 'menu_id': 'menu_file', 'text': 'E&xit', 'command': 'q', 'order': 600}
endfu

fu! Action_open()
    let select_file = quickui#extras#widgets#filechooser#open(getcwd(), {'title': 'Open'})
    if filereadable(select_file)
        execute('e ' . select_file)
    endif
endfu

fu! Action_save()
    if &mod
        let current_file = expand('%:p')
        if filereadable(current_file)
            execute('w')
        else
            let select_file = quickui#extras#widgets#filechooser#open(getcwd(), {'title': 'Save'})
            if filereadable(select_file)
                execute('w ' . select_file)
            endif
        endif
    endif
endfu

fu! Action_saveAs()
    let select_file = quickui#extras#widgets#filechooser#open(getcwd(), {'title': 'Save As'})
    if filereadable(select_file)
        execute('sav! ' . select_file)
    endif
endfu
