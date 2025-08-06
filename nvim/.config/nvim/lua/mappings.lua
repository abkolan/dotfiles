require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- DevOps specific mappings
map("n", "<leader>dk", "<cmd>Telescope kubernetes<cr>", { desc = "Kubernetes resources" })
map("n", "<leader>dt", "<cmd>Telescope terraform_doc<cr>", { desc = "Terraform documentation" })
map("n", "<leader>dh", "<cmd>YAMLTelescope<cr>", { desc = "Helm values" })
map("n", "<leader>dy", "<cmd>Telescope yaml_schema<cr>", { desc = "YAML schema" })

-- Git mappings
map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Git diff view" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory<cr>", { desc = "Git file history" })
map("n", "<leader>gc", "<cmd>DiffviewClose<cr>", { desc = "Close diff view" })

-- Testing mappings
map("n", "<leader>tt", "<cmd>lua require('neotest').run.run()<cr>", { desc = "Run nearest test" })
map("n", "<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", { desc = "Run current file tests" })
map("n", "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<cr>", { desc = "Toggle test summary" })
map("n", "<leader>to", "<cmd>lua require('neotest').output.open({ enter = true })<cr>", { desc = "Open test output" })

-- Go specific mappings
map("n", "<leader>gr", "<cmd>GoRun<cr>", { desc = "Go run" })
map("n", "<leader>gt", "<cmd>GoTest<cr>", { desc = "Go test" })
map("n", "<leader>gb", "<cmd>GoBuild<cr>", { desc = "Go build" })
map("n", "<leader>gi", "<cmd>GoInstallDeps<cr>", { desc = "Go install dependencies" })
map("n", "<leader>gf", "<cmd>GoFmt<cr>", { desc = "Go format" })

-- Terraform mappings
map("n", "<leader>ti", "<cmd>!terraform init<cr>", { desc = "Terraform init" })
map("n", "<leader>tp", "<cmd>!terraform plan<cr>", { desc = "Terraform plan" })
map("n", "<leader>ta", "<cmd>!terraform apply<cr>", { desc = "Terraform apply" })
map("n", "<leader>tv", "<cmd>!terraform validate<cr>", { desc = "Terraform validate" })

-- Kubernetes mappings  
map("n", "<leader>ka", "<cmd>!kubectl apply -f %<cr>", { desc = "Kubectl apply current file" })
map("n", "<leader>kd", "<cmd>!kubectl describe -f %<cr>", { desc = "Kubectl describe current file" })
map("n", "<leader>kg", "<cmd>!kubectl get -f %<cr>", { desc = "Kubectl get current file" })
map("n", "<leader>kv", "<cmd>!kubectl validate -f %<cr>", { desc = "Kubectl validate current file" })
map("n", "<leader>kD", "<cmd>!kubectl delete -f %<cr>", { desc = "Kubectl delete current file" })

-- Enhanced Kubernetes file operations
map("n", "<leader>ky", "<cmd>lua require('fzf-lua').files({ cmd = 'fd --extension yaml --extension yml . k8s kubernetes manifests' })<cr>", { desc = "Find Kubernetes YAML files" })
map("n", "<leader>kf", "<cmd>lua require('fzf-lua').live_grep({ cmd = 'rg --type yaml' })<cr>", { desc = "Grep in Kubernetes files" })
map("n", "<leader>ks", "<cmd>!kubectl get pods,svc,deploy,configmap,secret -o wide<cr>", { desc = "Kubectl status overview" })

-- Docker mappings
map("n", "<leader>db", "<cmd>!docker build -t $(basename $(pwd)) .<cr>", { desc = "Docker build" })
map("n", "<leader>dr", "<cmd>!docker run -it $(basename $(pwd))<cr>", { desc = "Docker run" })

-- Python mappings
map("n", "<leader>pr", "<cmd>!python %<cr>", { desc = "Run Python file" })
map("n", "<leader>pt", "<cmd>!python -m pytest<cr>", { desc = "Run pytest" })

-- Quick file navigation for DevOps
map("n", "<leader>fd", "<cmd>Telescope find_files search_dirs={'./docker','./k8s','./kubernetes','./helm','./terraform'}<cr>", { desc = "Find DevOps files" })

-- YAML validation
map("n", "<leader>yv", function()
  local yamllint = vim.fn.expand("~/.local/share/nvim/mason/bin/yamllint")
  if vim.fn.executable(yamllint) == 1 then
    vim.cmd("!" .. yamllint .. " %")
  else
    vim.notify("yamllint not found. Please install it via Mason.", vim.log.levels.ERROR)
  end
end, { desc = "YAML lint current file" })

-- Advanced Search and Navigation (Monorepo Optimized)
-- Telescope mappings
map("n", "<leader>ff", "<cmd>lua require('configs.telescope').smart_find_files()<cr>", { desc = "Smart find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "Old files" })
map("n", "<leader>fc", "<cmd>Telescope commands<cr>", { desc = "Commands" })
map("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Keymaps" })
map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Document symbols" })
map("n", "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<cr>", { desc = "Workspace symbols" })
map("n", "<leader>fr", "<cmd>Telescope lsp_references<cr>", { desc = "LSP references" })
map("n", "<leader>fi", "<cmd>Telescope lsp_implementations<cr>", { desc = "LSP implementations" })
map("n", "<leader>fd", "<cmd>Telescope lsp_definitions<cr>", { desc = "LSP definitions" })
map("n", "<leader>fD", "<cmd>Telescope diagnostics<cr>", { desc = "Diagnostics" })

-- Advanced grep with args
map("n", "<leader>fG", "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>", { desc = "Live grep with args" })
map("n", "<leader>ft", "<cmd>lua require('configs.telescope').find_todos()<cr>", { desc = "Find TODOs" })

-- Monorepo specific searches
map("n", "<leader>fms", "<cmd>lua require('configs.telescope').find_files_in_services()<cr>", { desc = "Find in services" })
map("n", "<leader>fmp", "<cmd>lua require('configs.telescope').find_files_in_packages()<cr>", { desc = "Find in packages" })
map("n", "<leader>fma", "<cmd>lua require('configs.telescope').find_files_in_apps()<cr>", { desc = "Find in apps" })

-- File extension searches (using FZF-Lua for speed)
map("n", "<leader>fey", "<cmd>lua require('fzf-lua').files({ cmd = 'fd --extension yaml --type f' })<cr>", { desc = "Find YAML files" })
map("n", "<leader>fej", "<cmd>lua require('fzf-lua').files({ cmd = 'fd --extension json --type f' })<cr>", { desc = "Find JSON files" })
map("n", "<leader>fet", "<cmd>lua require('fzf-lua').files({ cmd = 'fd --extension tf --type f' })<cr>", { desc = "Find Terraform files" })
map("n", "<leader>fep", "<cmd>lua require('fzf-lua').files({ cmd = 'fd --extension py --type f' })<cr>", { desc = "Find Python files" })
map("n", "<leader>feg", "<cmd>lua require('fzf-lua').files({ cmd = 'fd --extension go --type f' })<cr>", { desc = "Find Go files" })

-- FZF-Lua alternative mappings (faster for huge repos)
map("n", "<leader>Ff", "<cmd>lua require('fzf-lua').files()<cr>", { desc = "FZF files" })
map("n", "<leader>Fg", "<cmd>lua require('fzf-lua').live_grep()<cr>", { desc = "FZF live grep" })
map("n", "<leader>Fb", "<cmd>lua require('fzf-lua').buffers()<cr>", { desc = "FZF buffers" })
map("n", "<leader>Fo", "<cmd>lua require('fzf-lua').oldfiles()<cr>", { desc = "FZF old files" })
map("n", "<leader>Fh", "<cmd>lua require('fzf-lua').help_tags()<cr>", { desc = "FZF help" })
map("n", "<leader>Fc", "<cmd>lua require('fzf-lua').commands()<cr>", { desc = "FZF commands" })
map("n", "<leader>Fk", "<cmd>lua require('fzf-lua').keymaps()<cr>", { desc = "FZF keymaps" })
map("n", "<leader>Fs", "<cmd>lua require('fzf-lua').lsp_document_symbols()<cr>", { desc = "FZF document symbols" })
map("n", "<leader>FS", "<cmd>lua require('fzf-lua').lsp_workspace_symbols()<cr>", { desc = "FZF workspace symbols" })
map("n", "<leader>Fr", "<cmd>lua require('fzf-lua').lsp_references()<cr>", { desc = "FZF references" })
map("n", "<leader>Fi", "<cmd>lua require('fzf-lua').lsp_implementations()<cr>", { desc = "FZF implementations" })
map("n", "<leader>Fd", "<cmd>lua require('fzf-lua').lsp_definitions()<cr>", { desc = "FZF definitions" })
map("n", "<leader>FD", "<cmd>lua require('fzf-lua').diagnostics_workspace()<cr>", { desc = "FZF diagnostics" })

-- Git integration
map("n", "<leader>gf", "<cmd>lua require('fzf-lua').git_files()<cr>", { desc = "Git files" })
map("n", "<leader>gs", "<cmd>lua require('fzf-lua').git_status()<cr>", { desc = "Git status" })
map("n", "<leader>gl", "<cmd>lua require('fzf-lua').git_commits()<cr>", { desc = "Git log" })
map("n", "<leader>gL", "<cmd>lua require('fzf-lua').git_bcommits()<cr>", { desc = "Git buffer commits" })
map("n", "<leader>gb", "<cmd>lua require('fzf-lua').git_branches()<cr>", { desc = "Git branches" })

-- Neo-tree mappings
map("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle Neo-tree" })
map("n", "<leader>E", "<cmd>Neotree focus<cr>", { desc = "Focus Neo-tree" })
map("n", "<leader>ge", "<cmd>Neotree git_status<cr>", { desc = "Neo-tree git status" })
map("n", "<leader>be", "<cmd>Neotree buffers<cr>", { desc = "Neo-tree buffers" })

-- Enhanced Directory Navigation
map("n", "<leader>dd", "<cmd>lua require('fzf-lua').files({ cwd = vim.fn.input('Directory: ', vim.fn.getcwd(), 'dir') })<cr>", { desc = "Navigate to directory" })
map("n", "<leader>dc", "<cmd>lua require('fzf-lua').files({ cwd = vim.fn.getcwd() })<cr>", { desc = "Files in current dir" })
map("n", "<leader>dp", "<cmd>lua require('fzf-lua').files({ cwd = vim.fn.expand('%:p:h') })<cr>", { desc = "Files in parent dir" })
map("n", "<leader>dh", "<cmd>lua require('fzf-lua').files({ cwd = vim.fn.expand('~') })<cr>", { desc = "Files in home dir" })
map("n", "<leader>dr", "<cmd>lua require('fzf-lua').files({ cwd = vim.fn.systemlist('git rev-parse --show-toplevel')[1] or vim.fn.getcwd() })<cr>", { desc = "Files in git root" })

-- Quick directory jumps (common paths)
map("n", "<leader>d.", "<cmd>lua require('fzf-lua').files({ cwd = vim.fn.getcwd() .. '/.config' })<cr>", { desc = "Config directory" })
map("n", "<leader>dt", "<cmd>lua require('fzf-lua').files({ cwd = '/tmp' })<cr>", { desc = "Temp directory" })
map("n", "<leader>dl", "<cmd>lua require('fzf-lua').files({ cwd = '/var/log' })<cr>", { desc = "Log directory" })

-- Directory-specific searches
map("n", "<leader>ds", "<cmd>lua require('fzf-lua').live_grep({ cwd = vim.fn.input('Search in directory: ', vim.fn.getcwd(), 'dir') })<cr>", { desc = "Grep in directory" })
map("n", "<leader>dg", "<cmd>lua require('fzf-lua').live_grep({ cwd = vim.fn.systemlist('git rev-parse --show-toplevel')[1] or vim.fn.getcwd() })<cr>", { desc = "Grep in git root" })

-- Neo-tree directory operations
map("n", "<leader>ef", "<cmd>Neotree reveal<cr>", { desc = "Reveal current file in tree" })
map("n", "<leader>ec", "<cmd>Neotree close<cr>", { desc = "Close Neo-tree" })
map("n", "<leader>er", "<cmd>Neotree source=filesystem position=current<cr>", { desc = "Neo-tree as file manager" })

-- Vim built-in directory navigation
map("n", "<leader>cd", "<cmd>cd %:p:h<cr><cmd>pwd<cr>", { desc = "Change to file directory" })
map("n", "<leader>cD", "<cmd>cd ..<cr><cmd>pwd<cr>", { desc = "Change to parent directory" })
map("n", "<leader>cw", "<cmd>pwd<cr>", { desc = "Show working directory" })
map("n", "<leader>ch", "<cmd>cd ~<cr><cmd>pwd<cr>", { desc = "Change to home directory" })

-- Fast directory bookmarks (you can customize these paths)
map("n", "<leader>bh", "<cmd>lua require('fzf-lua').files({ cwd = vim.fn.expand('~/lab/helm3') })<cr>", { desc = "Helm3 project" })
map("n", "<leader>bc", "<cmd>lua require('fzf-lua').files({ cwd = vim.fn.expand('~/.config') })<cr>", { desc = "Config directory" })
map("n", "<leader>bn", "<cmd>lua require('fzf-lua').files({ cwd = vim.fn.expand('~/.config/nvim') })<cr>", { desc = "Neovim config" })

-- Directory tree operations
map("n", "-", "<cmd>lua require('fzf-lua').files({ cwd = vim.fn.expand('%:p:h') })<cr>", { desc = "Browse parent directory" })
map("n", "_", "<cmd>lua require('fzf-lua').files({ cwd = vim.fn.getcwd() })<cr>", { desc = "Browse current directory" })

-- Window Splitting and Multi-File Management
-- Basic splits
map("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Split window vertically" })
map("n", "<leader>sh", "<cmd>split<cr>", { desc = "Split window horizontally" })
map("n", "<leader>se", "<C-w>=", { desc = "Equalize window sizes" })
map("n", "<leader>sc", "<cmd>close<cr>", { desc = "Close current window" })
map("n", "<leader>so", "<cmd>only<cr>", { desc = "Close all other windows" })

-- Advanced splits with file selection
map("n", "<leader>sfv", "<cmd>lua require('fzf-lua').files({ actions = { ['default'] = require('fzf-lua').actions.file_vsplit } })<cr>", { desc = "Find file in vertical split" })
map("n", "<leader>sfh", "<cmd>lua require('fzf-lua').files({ actions = { ['default'] = require('fzf-lua').actions.file_split } })<cr>", { desc = "Find file in horizontal split" })
map("n", "<leader>sft", "<cmd>lua require('fzf-lua').files({ actions = { ['default'] = require('fzf-lua').actions.file_tabedit } })<cr>", { desc = "Find file in new tab" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Window resizing
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Tab management
map("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Close tab" })
map("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "Close other tabs" })
map("n", "<leader>tp", "<cmd>tabprevious<cr>", { desc = "Previous tab" })
map("n", "<leader>tN", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<leader>tm", "<cmd>tabmove<cr>", { desc = "Move tab" })

-- Tab navigation with numbers
map("n", "<leader>1", "1gt", { desc = "Go to tab 1" })
map("n", "<leader>2", "2gt", { desc = "Go to tab 2" })
map("n", "<leader>3", "3gt", { desc = "Go to tab 3" })
map("n", "<leader>4", "4gt", { desc = "Go to tab 4" })
map("n", "<leader>5", "5gt", { desc = "Go to tab 5" })

-- Buffer management for multi-file editing  
map("n", "<leader>x", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<leader>X", "<cmd>bdelete!<cr>", { desc = "Force delete buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<leader>bl", "<cmd>buffers<cr>", { desc = "List buffers" })

-- Quick buffer switching
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })

-- Preset window layouts
map("n", "<leader>w2", "<cmd>vsplit<cr>", { desc = "2-column layout" })
map("n", "<leader>w3", "<cmd>vsplit<cr><cmd>vsplit<cr><C-w>=", { desc = "3-column layout" })
map("n", "<leader>w4", "<cmd>vsplit<cr><cmd>split<cr><C-w>l<cmd>split<cr><C-w>=", { desc = "4-window grid" })
map("n", "<leader>wt", "<cmd>split<cr><cmd>resize 10<cr>", { desc = "Terminal split (horizontal)" })
map("n", "<leader>wT", "<cmd>vsplit<cr><cmd>vertical resize 80<cr>", { desc = "Terminal split (vertical)" })

-- Multi-file comparison
map("n", "<leader>vd", "<cmd>vert diffsplit ", { desc = "Vertical diff split (specify file)" })
map("n", "<leader>vD", "<cmd>diffsplit ", { desc = "Horizontal diff split (specify file)" })
map("n", "<leader>vf", "<cmd>diffoff<cr>", { desc = "Turn off diff mode" })

-- TODO comments
map("n", "<leader>td", "<cmd>TodoTelescope<cr>", { desc = "Todo Telescope" })
map("n", "<leader>tq", "<cmd>TodoQuickFix<cr>", { desc = "Todo QuickFix" })
map("n", "<leader>tl", "<cmd>TodoLocList<cr>", { desc = "Todo LocList" })
map("n", "]t", "<cmd>lua require('todo-comments').jump_next()<cr>", { desc = "Next todo" })
map("n", "[t", "<cmd>lua require('todo-comments').jump_prev()<cr>", { desc = "Previous todo" })

-- LSP and Mason management
map("n", "<leader>lm", "<cmd>Mason<cr>", { desc = "Open Mason" }) 
map("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "LSP Info" })
map("n", "<leader>lr", "<cmd>LspRestart<cr>", { desc = "LSP Restart" })
map("n", "<leader>ll", "<cmd>MasonLog<cr>", { desc = "Mason Log" })
map("n", "<leader>lu", "<cmd>MasonUpdate<cr>", { desc = "Mason Update" })

-- Fast navigation enhancements
map("n", "<C-p>", "<cmd>lua require('fzf-lua').files()<cr>", { desc = "Quick file finder" })
map("n", "<C-f>", "<cmd>lua require('fzf-lua').live_grep()<cr>", { desc = "Quick grep" })
map("n", "<leader><leader>", "<cmd>lua require('fzf-lua').buffers()<cr>", { desc = "Quick buffer switch" })

-- Smart project navigation
map("n", "<leader>pf", "<cmd>lua require('configs.telescope').smart_find_files()<cr>", { desc = "Project files" })
map("n", "<leader>pg", "<cmd>lua require('fzf-lua').git_files()<cr>", { desc = "Git tracked files" })
map("n", "<leader>pr", "<cmd>lua require('fzf-lua').oldfiles({ cwd_only = true })<cr>", { desc = "Recent project files" })

-- Quick jumps
map("n", "<C-o>", "<C-o>zz", { desc = "Jump back (centered)" })
map("n", "<C-i>", "<C-i>zz", { desc = "Jump forward (centered)" })
map("n", "n", "nzz", { desc = "Next search (centered)" })
map("n", "N", "Nzz", { desc = "Prev search (centered)" })

-- LSP keybindings (these work when LSP is attached)
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Go to definition" })
map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { desc = "Go to declaration" })
map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", { desc = "Go to implementation" })
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", { desc = "Show references" })
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", { desc = "Hover documentation" })
map("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { desc = "Signature help" })
map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "Rename symbol" })
map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Code actions" })
map("n", "<leader>f", "<cmd>lua vim.lsp.buf.format({ async = true })<cr>", { desc = "Format document" })

-- Diagnostics navigation
map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", { desc = "Previous diagnostic" })
map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", { desc = "Next diagnostic" })
map("n", "<leader>d", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "Show diagnostic" })

-- Symbol occurrence navigation
map("n", "*", "*zz", { desc = "Search word forward (centered)" })
map("n", "#", "#zz", { desc = "Search word backward (centered)" })
map("n", "n", "nzz", { desc = "Next search result (centered)" })
map("n", "N", "Nzz", { desc = "Previous search result (centered)" })

-- Reference navigation (for quickfix list)
map("n", "]r", "<cmd>cnext<cr>zz", { desc = "Next reference" })
map("n", "[r", "<cmd>cprev<cr>zz", { desc = "Previous reference" })
map("n", "]R", "<cmd>clast<cr>zz", { desc = "Last reference" })
map("n", "[R", "<cmd>cfirst<cr>zz", { desc = "First reference" })

-- Enhanced symbol search
map("n", "<leader>*", "<cmd>lua require('fzf-lua').grep_cword()<cr>", { desc = "Grep word under cursor" })
map("n", "<leader>#", "<cmd>lua require('fzf-lua').grep_cWORD()<cr>", { desc = "Grep WORD under cursor" })

-- Quickfix list management
map("n", "<leader>qo", "<cmd>copen<cr>", { desc = "Open quickfix list" })
map("n", "<leader>qc", "<cmd>cclose<cr>", { desc = "Close quickfix list" })
map("n", "<leader>qq", "<cmd>cclose<cr>", { desc = "Close quickfix list (quick)" })
map("n", "<C-q>", "<cmd>cclose<cr>", { desc = "Close quickfix list (super quick)" })

-- File outline and structure
map("n", "<leader>o", "<cmd>lua require('fzf-lua').lsp_document_symbols()<cr>", { desc = "File outline (symbols)" })
map("n", "<leader>O", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "File outline (detailed)" })
map("n", "<leader>wo", "<cmd>lua require('fzf-lua').lsp_workspace_symbols()<cr>", { desc = "Workspace symbols" })

-- SQL and Database workflows
map("n", "<leader>sq", "<cmd>lua require('fzf-lua').files({ cmd = 'fd --extension sql --type f' })<cr>", { desc = "Find SQL files" })
map("n", "<leader>sr", "<cmd>!mysql -u root -p < %<cr>", { desc = "Run SQL file (MySQL)" })
map("n", "<leader>sp", "<cmd>!psql -f %<cr>", { desc = "Run SQL file (PostgreSQL)" })

-- Docker workflows
map("n", "<leader>df", "<cmd>lua require('fzf-lua').files({ cmd = 'fd Dockerfile --type f' })<cr>", { desc = "Find Dockerfiles" })
map("n", "<leader>dc", "<cmd>lua require('fzf-lua').files({ cmd = 'fd docker-compose --type f' })<cr>", { desc = "Find Docker Compose files" })
map("n", "<leader>di", "<cmd>!docker build -t $(basename $(pwd)) .<cr>", { desc = "Docker build image" })
map("n", "<leader>du", "<cmd>!docker-compose up -d<cr>", { desc = "Docker compose up" })
map("n", "<leader>dd", "<cmd>!docker-compose down<cr>", { desc = "Docker compose down" })

-- Markdown preview
map("n", "<leader>mp", "<cmd>MarkdownPreview<cr>", { desc = "Markdown preview" })
map("n", "<leader>ms", "<cmd>MarkdownPreviewStop<cr>", { desc = "Stop markdown preview" })
map("n", "<leader>mt", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Toggle markdown preview" })
