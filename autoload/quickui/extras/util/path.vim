
fu! quickui#extras#util#path#separator()
    return has('win32') ? '\' : '/'
endfu

fu! quickui#extras#util#path#parent(file_path)
    if type(a:file_path) != 1 || empty(a:file_path)
        return ''
    endif

    let temp_path = expand(a:file_path)
    let temp_path = substitute(temp_path, '\', '/', 'g')
    let temp_path = substitute(temp_path, '//', '/', 'g')
    if temp_path =~ '/$'
        let temp_path = substitute(temp_path, '\$', '', '')
    endif
    let temp_parent_path = fnamemodify(temp_path, ':h')
    return temp_path != temp_parent_path ? temp_parent_path : ''
endfu

fu! quickui#extras#util#path#list(current_dir)
    if type(a:current_dir) != 1 || !isdirectory(a:current_dir)
        return []
    endif

    let sub_dirs = []
    let sub_files = []
    for file_name in readdir(a:current_dir)
        let file_path = a:current_dir . quickui#extras#util#path#separator() . file_name
        let file_type = isdirectory(file_path) ? 'folder' : filereadable(file_path) ? 'file' : ''
        let file_icon = 'WebDevIconsGetFileTypeSymbol'
        if exists('*WebDevIconsGetFileTypeSymbol')
            if file_type == 'folder'
                let file_icon = exists('g:WebDevIconsUnicodeDecorateFolderNodesDefaultSymbol') ? g:WebDevIconsUnicodeDecorateFolderNodesDefaultSymbol : ''
            elseif file_type == 'file'
                let file_icon = WebDevIconsGetFileTypeSymbol(file_path)
            endif
        endif
        
        if file_type == 'folder'
            call add(sub_dirs, {'path': file_path, 'name': file_name, 'type': file_type, 'icon': file_icon})
        elseif file_type == 'file'
            call add(sub_files, {'path': file_path, 'name': file_name, 'type': file_type, 'icon': file_icon})
        endif
    endfor

    return sub_dirs + sub_files
endfu
