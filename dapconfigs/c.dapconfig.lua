require'dap'.configurations.c = {
    {
    name = 'Local c dap config',
    type = 'cppdbg',
    request = 'launch',
    program = '${workspaceFolder}/a.out',
    cwd = '${workspaceFolder}',
    args = {},
    runInTernminal = false,
}
}
