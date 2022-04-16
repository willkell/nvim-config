require'dap'.configurations.cpp = {
    {
    name = 'default cpp dap config',
    type = 'cppdbg',
    request = 'launch',
    program = '${workspaceFolder}/a.out',
    cwd = '${workspaceFolder}',
    args = {},
    runInTernminal = false,
}
}
