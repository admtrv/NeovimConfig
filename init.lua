-- include lazy.nvim
vim.opt.runtimepath:prepend("~/.local/share/nvim/lazy/lazy.nvim")

-- interface settings
vim.o.number = true
vim.o.relativenumber = true
vim.o.termguicolors = true
vim.o.background = "dark"

-- tab settings
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4

-- menu settings
vim.o.completeopt = "menu,menuone,noselect"

-- plugins setup using lazy.nvim
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
        		"       ███████████           █████      ██						",
        		"      ███████████             █████ 							",
        		"      ████████████████ ███████████ ███   ███████		",
        		"     ████████████████ ████████████ █████ ██████████████	",
        		"    █████████████████████████████ █████ █████ ████ █████	",
        		"  ██████████████████████████████████ █████ █████ ████ █████	",
        		" ██████  ███ █████████████████ ████ █████ █████ ████ ██████	"
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
        			ignore = false,
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
        	require("symbols-outline").setup()
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
    
    -- ai complete
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
})

-- hot keys
vim.api.nvim_set_keymap("n", "<leader>t", ":ToggleTerm<CR>", { noremap = true, silent = true }) -- terminal (t, terminal)
vim.api.nvim_set_keymap("t", "<C-t>", "<C-\\><C-n>:ToggleTerm<CR>", { noremap = true, silent = true }) -- exit terminal (Ctrl+T)

vim.api.nvim_set_keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true }) -- file explorer (e, explorer)
vim.api.nvim_set_keymap("n", "<leader>fe", ":NvimTreeFocus<CR>", { noremap = true, silent = true }) -- focus file explorer (fe, focus explorer)

vim.api.nvim_set_keymap("n", "<leader>ff", ":Telescope find_files<CR>", { noremap = true, silent = true }) -- file search (ff, find file)
vim.api.nvim_set_keymap("n", "<leader>ft", ":Telescope live_grep<CR>", { noremap = true, silent = true }) -- text search (ft, find text)

vim.api.nvim_set_keymap("n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true }) -- go definition (gd, go definition)
vim.api.nvim_set_keymap("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true, silent = true }) -- rename variable (r, rename)
vim.api.nvim_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.format()<CR>", { noremap = true, silent = true }) -- file formatting (f, format)

vim.api.nvim_set_keymap("n", "<leader>x", ":Trouble diagnostics toggle<CR>", { noremap = true, silent = true }) -- diagnostics panel (x, errors)

vim.api.nvim_set_keymap("n", "<leader>cm", ":CMakeBuild<CR>", { noremap = true, silent = true }) -- cmake project build (cm, cmake build)
vim.api.nvim_set_keymap("n", "<leader>cr", ":CMakeRun<CR>", { noremap = true, silent = true }) -- cmake project run (cr, cmake run)

vim.api.nvim_set_keymap("n", "<leader>od", "<cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true, silent = true }) -- open documentation (od, open documentation)

vim.api.nvim_set_keymap("n", "<leader>gb", ":Gitsigns blame_line<CR>", { noremap = true, silent = true }) -- git blame (gb, git blame)
vim.api.nvim_set_keymap("n", "<leader>gn", ":Gitsigns next_hunk<CR>", { noremap = true, silent = true }) -- next git hunk (gn, git next)
vim.api.nvim_set_keymap("n", "<leader>gp", ":Gitsigns prev_hunk<CR>", { noremap = true, silent = true }) -- previous git hunk (gp, git previous)
vim.api.nvim_set_keymap("n", "<leader>gr", ":Gitsigns reset_hunk<CR>", { noremap = true, silent = true }) -- reset git hunk (gr, git reset)
vim.api.nvim_set_keymap("n", "<leader>gs", ":Gitsigns stage_hunk<CR>", { noremap = true, silent = true }) -- stage git hunk (gs, git stage)
vim.api.nvim_set_keymap("n", "<leader>gu", ":Gitsigns undo_stage_hunk<CR>", { noremap = true, silent = true }) -- undo git stage (gu, git undo)
vim.api.nvim_set_keymap("n", "<leader>gd", ":DiffviewOpen<CR>", { noremap = true, silent = true }) -- open git diff view (gd, git diff)
vim.api.nvim_set_keymap("n", "<leader>gq", ":DiffviewClose<CR>", { noremap = true, silent = true }) -- close git diff view (gq, git quit)

vim.api.nvim_set_keymap("n", "<C-z>", "u", { noremap = true, silent = true }) -- undo (Ctrl+Z)
vim.api.nvim_set_keymap("n", "<C-y>", "<C-r>", { noremap = true, silent = true }) -- redo (Ctrl+Y)
vim.api.nvim_set_keymap("i", "<C-z>", "<Esc>ui", { noremap = true, silent = true }) -- undo insert mode (Ctrl+Z in insert mode)
vim.api.nvim_set_keymap("i", "<C-y>", "<Esc><C-r>i", { noremap = true, silent = true }) -- redo insert mode (Ctrl+Y in insert mode)

vim.api.nvim_set_keymap("n", "<S-l>", ":BufferLineCycleNext<CR>", { noremap = true, silent = true }) -- right tab (Shift+L)
vim.api.nvim_set_keymap("n", "<S-h>", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true }) -- left tab (Shift+R)
vim.api.nvim_set_keymap("n", "<leader>tc", ":Bdelete<CR>", { noremap = true, silent = true }) -- close tab (tb, tab close)

vim.api.nvim_set_keymap("n", "<F12>", ":SymbolsOutline<CR>", { noremap = true, silent = true }) -- open code structure
