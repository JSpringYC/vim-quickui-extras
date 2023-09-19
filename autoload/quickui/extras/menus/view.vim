
fu! quickui#extras#menus#view#init()
    if !exists('g:menubar')
        return
    endif

    " menu
    MenuAdd {'id': 'menu_view', 'text': '&View', 'order': 400}

    " items
    if exists('g:explorer_command')
        MenuItemAdd {'id': 'item_view_explorer', 'menu_id': 'menu_view', 'text': '&Explorer', 'command': g:explorer_command, 'tips': 'Open explorer', 'order': 100}
    endif
endfu
