-- lazy
vim.opt.runtimepath:prepend("~/.local/share/nvim/lazy/lazy.nvim")

-- --------
-- settings
-- --------

-- interface
vim.o.number = true
vim.o.relativenumber = true
vim.o.termguicolors = true
vim.o.background = "dark"

-- tab
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4

-- menu
vim.o.completeopt = "menu,menuone,noselect"

-- font
vim.o.guifont = "FiraCode Nerd Font:h14"

-- -------
-- plugins
-- -------

require("lazy").setup({
    -- custom start screen
    { 
    	"goolord/alpha-nvim", 
    	config = function()
    		local alpha = require("alpha")
    		local dashboard = require("alpha.themes.dashboard")

    		-- ascii art
    		local ascii_art = {
        		"                                              						",
        		"       ███████████           █████      ██					    ",
        		"      ███████████             █████ 							",
        		"      ████████████████ ███████████ ███   ███████	    ",
        		"     ████████████████ ████████████ █████ ██████████████	",
        		"    █████████████████████████████ █████ █████ ████ █████	",
        		"  ██████████████████████████████████ █████ █████ ████ █████	",
        		" ██████  ███ █████████████████ ████ █████ █████ ████ ██████ "
    		}

    		-- yellow color
    		vim.api.nvim_set_hl(0, "StartLogoYellow", { fg = "#ffd866" })

    		-- centering and uploading color
    		dashboard.section.header.val = ascii_art
    		dashboard.section.header.opts = { hl = "StartLogoYellow", position = "center" }

    		-- startup alpha-nvim
    		alpha.setup(dashboard.opts)
    	end
    },
    
    -- color scheme monokai pro
    { 
    	"loctvl842/monokai-pro.nvim", 
    	config = function()
        	require("monokai-pro").setup()
        	vim.cmd("colorscheme monokai-pro")
    	end
    },

    -- file explorer
    {
  		"nvim-tree/nvim-tree.lua",
  		config = function()
    		require("nvim-tree").setup({
      			git = {
        			enable = true,
        			ignore = true,
        			show_on_dirs = true,
      			},
      			renderer = {
        			highlight_git = true,
        			icons = {
          				show = {
            				file = true,
            				folder = true,
            				folder_arrow = true,
            				git = false,
          				},
        			},
      			},
    		})
  		end
	},

    -- status bar
    { 
    	"nvim-lualine/lualine.nvim", 
    	config = function()
        	require("lualine").setup({ options = { theme = "auto" } })
    	end
    },

    -- code structure
    { 
    	"simrat39/symbols-outline.nvim", 
    	config = function()
        	require("symbols-outline").setup({
    			symbols = {
        			File = { icon = "" },
        			Module = { icon = "" },
        			Namespace = { icon = "" },
        			Package = { icon = "󰏖" },
        			Class = { icon = "" },
        			Method = { icon = "󰊕" },
        			Property = { icon = "" },
       				Field = { icon = "" },
        			Constructor = { icon = "󱌢" },
        			Enum = { icon = "" },
        			Interface = { icon = "" },
        			Function = { icon = "ƒ" },
        			Variable = { icon = "" },
        			Constant = { icon = "const" },
        			String = { icon = "" },
        			Number = { icon = "" },
        			Boolean = { icon = "⊨" },
        			Array = { icon = "" },
        			Object = { icon = "⦿" },
        			Key = { icon = "" },
        			Null = { icon = "NULL" },
        			EnumMember = { icon = "" },
        			Struct = { icon = "󱒐" },
        			Event = { icon = "" },
        			Operator = { icon = "" },
        			TypeParameter = { icon = "" },
    			}
			})
    	end
    },

    -- lsp
    { 
    	"neovim/nvim-lspconfig", 
    	config = function()
        	require("lspconfig").clangd.setup({
  				cmd = { "clangd", "--header-insertion=never", "--offset-encoding=utf-16" }, 
  				init_options = {
    				inlayHints = {
      					parameterNames = true,
      					parameterTypes = true,
    				},
  				},
  				on_attach = function(client, bufnr)
    				if client.server_capabilities.inlayHintProvider then
      					vim.lsp.inlay_hint(bufnr, true)
    				end
  				end,
			})
    	end
    },
    
    -- ai auto complete
    { 
    	"tzachar/cmp-tabnine",
        build = "./install.sh",
        config = function()
            require("cmp_tabnine.config"):setup({
                max_lines = 1000,
                show_prediction_strength = false,
            })
        end
    },

    -- auto complete
    { 
    	"hrsh7th/nvim-cmp",
    	dependencies = {
    		"hrsh7th/cmp-nvim-lsp",
    		"hrsh7th/cmp-buffer",
    		"hrsh7th/cmp-path", 
    		"tzachar/cmp-tabnine",
    	},
    	config = function()
    		local cmp = require("cmp")
    		local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
    		
    		local function confirm_or_fallback(fallback)
                if cmp.visible() then
                    cmp.confirm({ select = true })
                else
                    fallback()
                end
            end

    	cmp.setup({
  			experimental = {
            	ghost_text = {
                    hl_group = "Comment",
                },
            },
  			mapping = cmp.mapping.preset.insert({
  				["<Tab>"]   = cmp.mapping(confirm_or_fallback, { "i", "s" }),
    			["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
  				["<Up>"]   = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    			["<CR>"] = cmp.mapping.confirm({ select = true }),
    			["<C-Space>"] = cmp.mapping.complete(),
  			}),
  			sources = cmp.config.sources({
  				{ name = "cmp_tabnine" },
    			{ name = "nvim_lsp", max_item_count = 5, keyword_length = 2 },
    			{ name = "buffer", max_item_count = 3, keyword_length = 3 },
    			{ name = "path", max_item_count = 3, keyword_length = 3 },
  			}),
		})

    		require("lspconfig").clangd.setup({
      			capabilities = lsp_capabilities,
    		})
    	end
    },

    -- syntax highlighting
    { 
    	"nvim-treesitter/nvim-treesitter", 
    	run = ":TSUpdate", 
    	config = function()
        	require("nvim-treesitter.configs").setup({
            	highlight = { enable = true },
            	indent = { enable = true }
        	})
    	end
    },

    -- terminal
    { 
    	"akinsho/toggleterm.nvim", 
    	config = function()
        	require("toggleterm").setup()
    	end
    },
    
    -- code formatting
    { 
    	"jose-elias-alvarez/null-ls.nvim",	-- '.clang-format' in root directory
  		dependencies = { "nvim-lua/plenary.nvim" },
  		config = function()
    		local null_ls = require("null-ls")

    	null_ls.setup({
      		sources = {
        		null_ls.builtins.formatting.clang_format.with({
  					filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto", "cs", "java", "arduino" },
				}),
      		},
    	})
  		end
	},

    -- cmake support
    { 
    	"Civitasv/cmake-tools.nvim", 
    	config = function()
    		require("cmake-tools").setup({})
    	end
    },

    -- better search
    {
  		"nvim-telescope/telescope.nvim",
  		dependencies = {
    		"nvim-lua/plenary.nvim",
    		{
      			"nvim-telescope/telescope-fzf-native.nvim",
      			build = "make", 
    		},
  		},
  		config = function()
    		require("telescope").setup()
  		end
	},

    -- diagnostics panel
    { 
    	"folke/trouble.nvim", 
    	dependencies = { "nvim-tree/nvim-web-devicons" }, 
    	config = function()
        	require("trouble").setup()
    	end
	},
    
    -- git difference sidepanel
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end
    },
    
    -- git difference view
    { 
    	"sindrets/diffview.nvim", 
    	config = function()
        	require("diffview").setup()
    	end
    },

    -- autopairs
    {
        "windwp/nvim-autopairs",
        config = function()
            local npairs = require("nvim-autopairs")
            npairs.setup({})

            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local cmp = require("cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end
    },
    
    -- normal tab close
    {
  		"famiu/bufdelete.nvim",
	},
    
    -- tab buffer
    {
  		"akinsho/bufferline.nvim",
  		dependencies = "nvim-tree/nvim-web-devicons",
  		config = function()
    		require("bufferline").setup({
      			options = {
        			show_buffer_close_icons = true,
        			show_close_icon = false,
        			diagnostics = "nvim_lsp",
        			close_command = function(bufnum)
          				require("bufdelete").bufdelete(bufnum, true)
        			end,
        			right_mouse_command = function(bufnum)
          				require("bufdelete").bufdelete(bufnum, true)
        			end,

        			-- move tab buffer, if file explorer open
        			offsets = {
          				{
            			filetype = "NvimTree",
            			text = "File Explorer",
           				highlight = "Directory",
            			text_align = "left",
            			separator = true,
          				},
        			},
      			},
    		})
  		end
	},
	
	-- notifications
    {
        "rcarriga/nvim-notify",
        config = function()
            require("notify").setup({
                top_down = true,
                timeout = 300,
                level = "trace",
            })
            vim.notify = require("notify")
        end,
    },

    -- folding pairs
    {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
        config = function()
            vim.o.foldcolumn = '0'
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true
            require("ufo").setup()
        end,
    },

	-- shortcuts help
    {
    	"folke/which-key.nvim",
    	event = "VeryLazy",
    	config = function(_, opts)
      		local wk = require("which-key")
      		wk.setup(opts)
      		wk.add({
        		{ "<leader>e", group = "Explorer", icon = "" },
        		{ "<leader>f", group = "Find", icon = "" },
        		{ "<leader>r", group = "Refactor", icon = "" },
        		{ "<leader>d", group = "Diagnostics", icon = "" },
        		{ "<leader>c", group = "CMake", icon = "" },
        		{ "<leader>g", group = "Git", icon = "󰊢" },
        		{ "<leader>u", group = "Folding", icon = "󰕎" },
        		{ "<leader>t", group = "Terminal", icon = "" },
      		})
    	end,
  	},
})

-- ---------
-- functions
-- ---------

-- focus terminal
local function focus_terminal()
    local term_filetype = "toggleterm"
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.api.nvim_buf_get_option(buf, "filetype") == term_filetype then
            vim.api.nvim_set_current_win(win)
            return
        end
    end
    require("toggleterm").toggle(0)
end

-- open/close terminal
local function open_close_terminal()
    require("toggleterm").toggle()
end

-- open/close git diff
local function open_close_diff()
  local diffview_open = false
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.api.nvim_buf_get_option(buf, "filetype")
    if ft == "DiffviewFiles" or ft == "DiffviewFileHistory" then
      diffview_open = true
      break
    end
  end
  if diffview_open then
    vim.cmd("DiffviewClose")
  else
    vim.cmd("DiffviewOpen")
  end
end

-- focus tab
local function focus_tab()
  require("bufferline").pick_buffer()	-- require("bufferline").go_to_buffer(1, true)
end

-- ---------
-- shortcuts
-- ---------

-- terminal
vim.keymap.set({ "n", "t" }, "<C-t>", open_close_terminal, { desc = "Open/close terminal", noremap = true, silent = true })	-- open/close
vim.keymap.set("n", "<leader>tf", focus_terminal, { desc = "Focus terminal", noremap = true, silent = true })				-- focus

-- file explorer
vim.keymap.set("n", "<leader>ee", ":NvimTreeToggle<CR>", { desc = "Open/close explorer", noremap = true, silent = true })	-- open/close
vim.keymap.set("n", "<leader>ef", ":NvimTreeFocus<CR>", { desc = "Focus explorer", noremap = true, silent = true })			-- focus

-- search
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find file", noremap = true, silent = true })	-- file
vim.keymap.set("n", "<leader>ft", ":Telescope live_grep<CR>", { desc = "Find text", noremap = true, silent = true })	-- text

-- refactor
vim.keymap.set("n", "<leader>rd", "<cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Go to definition", noremap = true, silent = true })	-- definition
vim.keymap.set("n", "<leader>rr", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "Rename symbol", noremap = true, silent = true })     		-- rename
vim.keymap.set("n", "<leader>rf", "<cmd>lua vim.lsp.buf.format()<CR>", { desc = "Format document", noremap = true, silent = true })     	-- formatting
vim.keymap.set("n", "<leader>rh", "<cmd>lua vim.lsp.buf.hover()<CR>", { desc = "Hover documentation", noremap = true, silent = true })      -- documentation

-- diagnostics
vim.keymap.set("n", "<leader>de", ":Trouble diagnostics toggle<CR>", { desc = "Open/close errors", noremap = true, silent = true })	-- open/close errors

-- cmake
vim.keymap.set("n", "<leader>cm", ":CMakeBuild<CR>", { desc = "CMake build", noremap = true, silent = true })	-- build
vim.keymap.set("n", "<leader>cr", ":CMakeRun<CR>", { desc = "CMake run", noremap = true, silent = true })		-- run

-- git
vim.keymap.set("n", "<leader>gb", ":Gitsigns blame_line<CR>", { desc = "Git blame", noremap = true, silent = true })			-- blame
vim.keymap.set("n", "<leader>gn", ":Gitsigns next_hunk<CR>", { desc = "Next git hunk", noremap = true, silent = true })        	-- next hunk
vim.keymap.set("n", "<leader>gp", ":Gitsigns prev_hunk<CR>", { desc = "Previous git hunk", noremap = true, silent = true })     -- previous hunk
vim.keymap.set("n", "<leader>gr", ":Gitsigns reset_hunk<CR>", { desc = "Reset git hunk", noremap = true, silent = true })       -- reset hunk
vim.keymap.set("n", "<leader>gs", ":Gitsigns stage_hunk<CR>", { desc = "Stage git hunk", noremap = true, silent = true })       -- stage hunk
vim.keymap.set("n", "<leader>gu", ":Gitsigns undo_stage_hunk<CR>", { desc = "Undo stage hunk", noremap = true, silent = true })	-- reset stage
vim.keymap.set("n", "<leader>gd", open_close_diff, { desc = "Open/close git diff", noremap = true, silent = true })             -- open/close diff

-- changes
vim.keymap.set("n", "<C-z>", "u", { desc = "Undo", noremap = true, silent = true })				-- undo
vim.keymap.set("i", "<C-z>", "<Esc>ui", { desc = "Undo", noremap = true, silent = true })
vim.keymap.set("n", "<C-y>", "<C-r>", { desc = "Redo", noremap = true, silent = true })			-- redo
vim.keymap.set("i", "<C-y>", "<Esc><C-r>i", { desc = "Redo", noremap = true, silent = true })

-- tabs 
vim.keymap.set("n", "tl", ":BufferLineCycleNext<CR>", { desc = "Next tab", noremap = true, silent = true })		-- right
vim.keymap.set("n", "th", ":BufferLineCyclePrev<CR>", { desc = "Previous tab", noremap = true, silent = true })	-- left
vim.keymap.set("n", "tc", ":Bdelete<CR>", { desc = "Close tab", noremap = true, silent = true })              	-- close
vim.keymap.set("n", "tf", focus_tab, { desc = "Focus tab", noremap = true, silent = true })						-- focus

-- code structure
vim.keymap.set("n", "<F12>", ":SymbolsOutline<CR>", { desc = "Open/close code structure", noremap = true, silent = true })	-- open/close

-- folding
vim.keymap.set("n", "<leader>uf", "za", { desc = "Fold/unfold code block", noremap = true, silent = true })	-- fold/unfold 
