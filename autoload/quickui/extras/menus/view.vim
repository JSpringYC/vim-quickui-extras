
fu! quickui#extras#menus#view#init()
    if !exists('g:menubar')
        return
    endif

    " menu
    MenuAdd {'id': 'menu_view', 'text': '&View', 'order': 400}

    " items
    if has(':NERDTreeToggle')
        MenuItemAdd {'id': 'item_view_explorer', 'menu_id': 'menu_view', 'text': '&Explorer', 'command': 'NERDTreeToggle', 'tips': 'Open explorer using NERDTreeToggle', 'order': 100}
    endif
endfu
