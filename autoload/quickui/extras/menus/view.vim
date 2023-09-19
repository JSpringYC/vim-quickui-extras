
fu! quickui#extras#menus#view#init()
    if !exists('g:menubar')
        return
    endif

    " menu
    MenuAdd {'id': 'menu_view', 'text': '&View', 'order': 400}
endfu
