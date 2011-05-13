-- Adapted from ACK code, (http://github.com/petdance/ack , Copyright 2005-2010 Andy Lester).
local ignoreDirs = {} do
  local directories = {
    '.bzr', '.cdv', '.git', '.hg', '.pc', '.svn', 'CVS', 'RCS', 'SCCS', '_MTN',
    '_build', '_darcs', '_sgbak', 'autom4te.cache', 'blib', 'cover_db',
    '~.dep', '~.dot', '~.nib', '~.plst', "tmp", "public/system"
  }
  for _, v in ipairs(directories) do ignoreDirs[v] = true end
end

local knownExts = {} do
  local exts = {
    'ada', 'adb', 'ads', 'as', 'asm', 'bas', 'bash', 'bat', 'bdsgroup',
    'bdsproj', 'c', 'cc', 'cfc', 'cfm', 'cfml', 'clj', 'cls', 'cls', 'cmd',
    'cpp', 'cpt', 'cpy', 'cs', 'csh', 'css', 'ctl', 'ctl', 'cxx', 'dfm', 'dof',
    'dpk', 'dproj', 'dtd', 'el', 'ent', 'erb', 'erl', 'f', 'f03', 'f77', 'f90',
    'f95', 'for', 'fpp', 'frm', 'ftn', 'go', 'groupproj', 'haml', 'h', 'hh',
    'hpp', 'hrl', 'hs', 'htm', 'html', 'hxx', 'int', 'itcl', 'itk', 'java',
    'jhtm', 'jhtml', 'js', 'jsp', 'jspx', 'ksh', 'lhs', 'lisp', 'lsp', 'lua',
    'm', 'mak', 'mas', 'metadata', 'mhtml', 'mk', 'ml', 'mli', 'mm', 'mpl',
    'mtxt', 'mxml', 'nfm', 'ops', 'pas', 'pasm', 'pg', 'php', 'php3', 'php4',
    'php5', 'phpt', 'phtml', 'pir', 'pl', 'pm', 'pmc', 'pod', 'pod',
    'properties', 'pt', 'py', 'py', 'rake', 'rb', 'resx', 'rhtml', 'rjs', 'rxml',
    's', 'sass', 'scala', 'scss', 'scm', 'sh', 'shtml', 'spec', 'sql', 'ss',
    'st', 'sty', 'sv', 't', 'tcl', 'tcsh', 'tex', 'tg', 'tt', 'tt2', 'ttml', 'v',
    'vb', 'vh', 'vhd', 'vhdl', 'vim', 'xhtml', 'xml', 'xs', 'xsl', 'xslt',
    'yaml', 'yml', 'zsh',
  }
  for _, v in ipairs(exts) do knownExts[v] = true end
end

local function blacklist(path, name, ext)
  return ignoreDirs[path] or (ext and not knownExts[ext])
end

return blacklist
