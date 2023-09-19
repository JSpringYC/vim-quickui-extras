
fu! quickui#extras#menus#edit#init()
    if !exists('g:menubar')
        return
    endif

    " menu
    MenuAdd {'id': 'menu_edit', 'text': '&Edit', 'order': 200}

    " items
    MenuItemAdd {'id': 'item_edit_undo', 'menu_id': 'menu_edit', 'text': '&Undo', 'command': 'undo', 'order': 100}
    MenuItemAdd {'id': 'item_edit_redo', 'menu_id': 'menu_edit', 'text': '&Redo', 'command': 'redo', 'order': 200}
    MenuItemAdd {'id': 'item_edit_sep1', 'menu_id': 'menu_edit', 'text': '--', 'command': '', 'order': 300}
    MenuItemAdd {'id': 'item_edit_wrap', 'menu_id': 'menu_edit', 'text': '&Wrap %{&wrap ? "on" : "off"}', 'command': 'set wrap!', 'order': 400}
endfu
