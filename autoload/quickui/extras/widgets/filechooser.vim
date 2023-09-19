
fu! quickui#extras#widgets#filechooser#open(...)
    " 打开目录，如未指定则取当前工作目录
    let current_dir = a:0 > 0 && isdirectory(expand(a:1)) ? expand(a:1) : getcwd()
    " 弹出框配置
    let opts = a:0 > 1 ? a:2 : {}
    if type(opts) != 4
        let opts = {}
    endif
    if !has_key(opts, 'w')
        let opts['w'] = 50
    endif
    if !has_key(opts, 'title')
        let opts['title'] = 'Open - ' . current_dir
    endif

    let parent_dir = quickui#extras#util#path#parent(current_dir)
    let sub_files  = quickui#extras#util#path#list(current_dir)
    " 插入上级及本级记录
    if !empty(parent_dir)
        call insert(sub_files, {'type': 'parent_folder', 'path': parent_dir, 'name': '..'}, 0)
        call insert(sub_files, {'type': 'current_folder', 'path': current_dir, 'name': '.'}, 1)
    else
        call insert(sub_files, {'type': 'current_folder', 'path': current_dir, 'name': '.'}, 0)
    endif

    " 显示弹窗
    let item_data = []
    for sub_file in sub_files
        let file_type = sub_file['type']
        let file_name = sub_file['name']

        if file_type == 'parent_folder' || file_type == 'current_folder'
            call add(item_data, file_name)
        else
            let file_icon = empty(sub_file['icon']) ? ' ' : sub_file['icon']
            let item_text = file_icon . ' ' . sub_file['name'] 
            call add(item_data, item_text)
        endif
    endfor

    let select_index = quickui#listbox#inputlist(item_data, opts)
    
    " 判断选择
    if select_index >= 0
        let select_file_info = sub_files[select_index]
        let select_file_type = select_file_info['type']
        let select_file_path = select_file_info['path']
        if has_key(opts, 'index')
            call remove(opts, 'index')
        endif
        " 如果是上级目录，则打开上级
        if select_file_type == 'parent_folder'
            return quickui#extras#widgets#filechooser#open(select_file_path, opts)
        endif
        " 如果是文件，则直接返回
        if select_file_info['type'] == 'file'
            return select_file_info['path']
        endif

        " 如果是目录，则要判断是否打开
        if select_file_type == 'folder' || select_file_type == 'current_folder'
            let action_opts = {'w': opts['w'], 'title': 'Action - ' . select_file_path}
            let action_menus = ["&1\tOpen", "&2\tNew &file", "&3\tNew fol&der"]
            let action_index = quickui#listbox#inputlist(action_menus, action_opts)

            if action_index == 0
                return quickui#extras#widgets#filechooser#open(select_file_path, opts)
            elseif action_index == 1 || action_index == 2
                " 目录或文件不能存在
                let input_file_name = quickui#input#open("File name: ", '')
                let temp_full_path = select_file_path . '/' . input_file_name
                if isdirectory(temp_full_path) || filereadable(temp_full_path)
                    let question = isdirectory(temp_full_path) ? "Folder" : 'File'
                    let question = question . ' [' . temp_full_path . '] already exists!'
                    call quickui#confirm#open(question, "&Ok")
                    return quickui#extras#widgets#filechooser#open(current_dir, opts)
                endif
                " 创建文件
                if action_index == 1
                    call writefile([''], temp_full_path, 'a')
                    return quickui#extras#widgets#filechooser#open(select_file_path, opts)
                elseif action_index == 2
                    call mkdir(temp_full_path, '')
                    return quickui#extras#widgets#filechooser#open(select_file_path, opts)
                endif
            else
                let opts['index'] = select_index
                return quickui#extras#widgets#filechooser#open(current_dir, opts)
            endif
        endif
    endif
    
    return ''
endfu
