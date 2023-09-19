
fu! quickui#extras#menus#menubar#has_menu(menu_id)
    return exists('g:menubar') ? has_key(g:menubar['menu_item_ids'], a:menu_id) : 0
endfu

fu! quickui#extras#menus#menubar#has_item(menu_id, item_id)
    if !exists('g:menubar')
        return 0
    endif

    let menubar_menu_item_ids = g:menubar["menu_item_ids"]
    return has_key(menubar_menu_item_ids, a:menu_id) ? index(menubar_menu_item_ids[a:menu_id], a:item_id) != -1 : 0
endfu

fu! quickui#extras#menus#menubar#add_menu(menu_info)
    if !exists('g:menubar')
        return
    endif
    if !has_key(a:menu_info, "id") || type(a:menu_info["id"]) != 1 || empty(a:menu_info["id"])
        echoerr "The menu ID cannot be omitted"
        return
    endif

    if len(g:menubar["menus"]) == 0 || len(g:menubar["menu_items"]) == 0 || len(g:menubar["menu_item_ids"]) == 0
        let g:menubar = {"menus": [], "menu_item_ids": {}, "menu_items": {}}
    endif

    let menu_id = a:menu_info["id"]
    let menu_order = has_key(a:menu_info, "order") && type(a:menu_info["order"]) == 0 ? a:menu_info['order'] : 9999
    let menu_text = has_key(a:menu_info, "text") && !empty(a:menu_info["text"]) ? a:menu_info['text'] : menu_id
    
    if !quickui#extras#menus#menubar#has_menu(menu_id)
        let temp_menu_info = {"id": menu_id, "text": menu_text, "order": menu_order}

        call add(g:menubar["menus"], temp_menu_info)
        let g:menubar["menu_item_ids"][menu_id] = []
        let g:menubar["menu_items"][menu_id] = []
    endif
endfu

fu! quickui#extras#menus#menubar#add_item(item_info)
    if !exists('g:menubar')
        return
    endif
    if !has_key(a:item_info, "id") || type(a:item_info["id"]) != 1 || empty(a:item_info["id"])
        echoerr "The menu item ID cannot be omitted"
        return
    endif
    if !has_key(a:item_info, "menu_id") || type(a:item_info["menu_id"]) != 1 || empty(a:item_info["menu_id"])
        echoerr "The menu ID cannot be omitted"
        return
    endif
    if !has_key(g:menubar["menu_item_ids"], a:item_info["menu_id"])
        echoerr "Invalid menu ID"
        return
    endif

    let menubar_menu_item_ids = g:menubar["menu_item_ids"]
    let menu_id = a:item_info["menu_id"]
    let menu_item_id = a:item_info["id"]
    if index(menubar_menu_item_ids[menu_id], menu_item_id) != -1
        return
    endif
    
    let menu_item_text = menu_item_id
    let menu_item_order = 9999
    let menu_item_command = ''
    let menu_item_tips = ''
    if has_key(a:item_info, "text") && !empty(a:item_info["text"])
        let menu_item_text = a:item_info["text"]
    endif
    if has_key(a:item_info, "order") && type(a:item_info["order"]) == 0
        let menu_item_order = a:item_info["order"]
    endif
    if has_key(a:item_info, "command") && !empty(a:item_info["command"])
        let menu_item_command = a:item_info["command"]
    endif
    if has_key(a:item_info, "tips") && !empty(a:item_info["tips"])
        let menu_item_tips = a:item_info["tips"]
    endif

    let temp_item_info = {"id": menu_item_id, "menu_id": menu_id, "text": menu_item_text, "command": menu_item_command, "tips": menu_item_tips, "order": menu_item_order}
    let menubar_menu_items = g:menubar["menu_items"]
    call add(menubar_menu_items[menu_id], temp_item_info)
    call add(menubar_menu_item_ids[menu_id], menu_item_id)
endf

fu! quickui#extras#menus#menubar#del_menu(menu_id)
    if quickui#extras#menus#menubar#has_menu(a:menu_id)
        let menubar_menus = g:menubar["menus"]
        for i in reverse(range(len(menubar_menus)))
            if menubar_menus[i]['id'] == a:menu_id
                call remove(menubar_menus, i)
            endif
        endfor

        let menubar_menu_item_ids = g:menubar["menu_item_ids"]
        call remove(menubar_menu_item_ids, a:menu_id)

        let menubar_menu_items = g:menubar["menu_items"]
        call remove(menubar_menu_items, a:menu_id)
    endif
endf

" 删除菜单项
fu! quickui#extras#menus#menubar#del_item(menu_id, item_id)
    let menubar_menu_item_ids = g:menubar["menu_item_ids"]
    let menubar_menu_items = g:menubar["menu_items"]
    if has_key(menubar_menu_item_ids, a:menu_id)
        let temp_item_ids = menubar_menu_item_ids[a:menu_id]
        if index(temp_item_ids, a:item_id) == -1
            return
        endif
        let temp_item_ids = filter(temp_item_ids, {_, val -> val != a:item_id})
        let menubar_menu_item_ids[a:menu_id] = temp_item_ids


        let temp_items = menubar_menu_items[a:menu_id]
        for i in reverse(range(len(temp_items)))
            if temp_items[i]['id'] == a:item_id
                call remove(temp_items, i)
            endif
        endfor
    endif
endf

function! MenuCompare(var_a, var_b)
    let order_a = has_key(a:var_a, 'order') ? a:var_a.order : 9999
    let order_b = has_key(a:var_b, 'order') ? a:var_b.order : 9999
    return order_a > order_b ? 1 : order_a < order_b ? -1 : 0
endfunction

fu! quickui#extras#menus#menubar#reload()
    " 重置菜单
    call quickui#menu#reset()

    " 安装菜单
    let menubar_menus = g:menubar["menus"]
    call sort(menubar_menus, 'MenuCompare')
    for menu_info in menubar_menus
        let menu_id = menu_info["id"]
        let menu_text = has_key(menu_info, "text") ? menu_info["text"] : menu_id

        let menubar_menu_items = g:menubar["menu_items"][menu_id]
        call sort(menubar_menu_items, 'MenuCompare')
        let quickui_menus = []
        for menu_item_info in menubar_menu_items
            let menu_item_id = menu_item_info["id"]
            let menu_item_text = has_key(menu_item_info, "text") ? menu_item_info["text"] : menu_item_id
            let menu_item_command = has_key(menu_item_info, "command") ? menu_item_info["command"] : ""
            let menu_item_tips = has_key(menu_item_info, "tips") ? menu_item_info["tips"] : ""

            if menu_item_text == "--"
                call add(quickui_menus, ["--", ""])
            else
                let temp_item_info = [menu_item_text]

                if !empty(menu_item_command)
                    if stridx(menu_item_command, "#") == 0
                        call add(temp_item_info, substitute(menu_item_command, '^#', "call ", ''))
                    else
                        call add(temp_item_info, menu_item_command)
                    endif
                else
                    call add(temp_item_info, "")
                endif

                if !empty(menu_item_tips)
                    call add(temp_item_info, menu_item_tips)
                else
                    call add(temp_item_info, '')
                endif
                call add(quickui_menus, temp_item_info)
            endif
        endfor
        call quickui#menu#install(menu_text, quickui_menus)
    endfor
endf

fu! quickui#extras#menus#menubar#init()
    if !exists("g:menubar")
        let g:menubar = {"menus": [], "menu_item_ids": {}, "menu_items": {}}
    endif

    command! -nargs=1 MenuAdd call quickui#extras#menus#menubar#add_menu(<args>)
    command! -nargs=1 MenuItemAdd call quickui#extras#menus#menubar#add_item(<args>)

    " file
    call quickui#extras#menus#file#init()
    " edit
    call quickui#extras#menus#edit#init()
    " view
    call quickui#extras#menus#view#init()
endfu

