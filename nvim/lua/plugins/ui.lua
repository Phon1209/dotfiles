return {
	{
		"nvimdev/dashboard-nvim",
		enabled = false,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" }, -- Optional, but recommended for icons
		opts = {
			options = {
				--[[
      General options for lualine.
      For a full list of options, see :help lualine-options
      --]]
				icons_enabled = true, -- Do you want to use icons?
				theme = "catppuccin", -- Or a specific theme like 'tokyonight', 'onedark', 'gruvbox', 'catppuccin', etc.
				-- 'auto' will try to match your colorscheme
				component_separators = { left = "", right = "" }, -- Separators between components
				section_separators = { left = "", right = "" }, -- Separators between sections (A,B,C and X,Y,Z)
				disabled_filetypes = { -- Filetypes for which lualine will be disabled
					statusline = {},
					winbar = {},
				},
				ignore_focus = {}, -- List of buffer types to ignore when checking focus
				always_divide_middle = true, -- If true, separates middle sections with section_separators
				globalstatus = false, -- If true, Components on statuslines of inactive windows are hidden
				-- and statusline for the last active window is used.
				refresh = { -- How often to refresh the statusline and tabline
					statusline = 1000, -- (in ms)
					tabline = 1000,
					winbar = 1000,
				},
			},
			sections = {
				--[[
      These are the main sections, 'lualine_a' through 'lualine_c' on the left,
      and 'lualine_x' through 'lualine_z' on the right.
      Each section is a table of components.
      A component can be a string (a built-in component name) or a table for more control.
      For a full list of built-in components, see :help lualine-components
      --]]
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = {
					{ "filename", path = 1 }, -- path = 1 shows filename relative to CWD
					-- You could also add things like:
					-- 'filesize',
					-- {
					--   'lsp_progress', -- Shows LSP progress messages
					--   display_components = {'lsp_client_name', 'progress'},
					--   colors = { MaterialDark = { progress_done =โซ '#a6e3a1' } },
					-- },
					-- {
					--  'searchcount',
					--  max_searches = 999, -- Maximum number of search results to display
					--  timeout = 500,      -- Timeout in milliseconds for search results
					-- },
				},
				lualine_x = { "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				--[[
      Sections for inactive windows. Same structure as `sections`.
      Often simplified.
      --]]
				lualine_a = {},
				lualine_b = {},
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {
				--[[
      Lualine can also act as a tabline.
      --]]
				-- lualine_a = {'tabs'},
				-- lualine_b = {},
				-- lualine_c = {},
				-- lualine_x = {},
				-- lualine_y = {},
				-- lualine_z = {},
			},
			winbar = {
				--[[
      Lualine can also act as a winbar (a bar at the top of each window).
      --]]
				-- lualine_a = {},
				-- lualine_b = {},
				-- lualine_c = {{'filename', path = 1}},
				-- lualine_x = {},
				-- lualine_y = {},
				-- lualine_z = {}
			},
			inactive_winbar = {
				-- lualine_c = {{'filename', path = 1}},
			},
			extensions = {
				--[[
      Lualine has extensions for integration with other plugins.
      --]]
				-- 'nvim-tree',
				-- 'toggleterm',
				-- 'quickfix',
				-- 'mason',
				-- 'fugitive', -- Example for git blame
				-- {
				--   'nvim-dap-ui',
				--   sections = {lualine_c = {'dap-state', 'dap-session'}}
				-- }
			},
		},
	},
	-- messages, cmdline and the popupmenu
	{
		"folke/noice.nvim",
		opts = function(_, opts)
			table.insert(opts.routes, {
				filter = {
					event = "notify",
					find = "No information available",
				},
				opts = { skip = true },
			})
			local focused = true
			vim.api.nvim_create_autocmd("FocusGained", {
				callback = function()
					focused = true
				end,
			})
			vim.api.nvim_create_autocmd("FocusLost", {
				callback = function()
					focused = false
				end,
			})
			table.insert(opts.routes, 1, {
				filter = {
					cond = function()
						return not focused
					end,
				},
				view = "notify_send",
				opts = { stop = false },
			})

			opts.commands = {
				all = {
					-- options for the message history that you get with `:Noice`
					view = "split",
					opts = { enter = true, format = "details" },
					filter = {},
				},
			}

			opts.presets.lsp_doc_border = true
		end,
	},

	{
		"rcarriga/nvim-notify",
		opts = {
			timeout = 5000,
			background_colour = "#000000",
			render = "wrapped-compact",
		},
	},

	-- buffer line
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		keys = {
			{ "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
			{ "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
		},
		opts = {
			options = {
				mode = "tabs",
				show_buffer_close_icons = false,
				show_close_icon = false,
			},
		},
	},

	-- filename
	{
		"b0o/incline.nvim",
		dependencies = {},
		event = "BufReadPre",
		priority = 1200,
		config = function()
			local helpers = require("incline.helpers")
			require("incline").setup({
				window = {
					padding = 0,
					margin = { horizontal = 0 },
				},
				render = function(props)
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
					local ft_icon, ft_color = require("nvim-web-devicons").get_icon_color(filename)
					local modified = vim.bo[props.buf].modified
					local buffer = {
						ft_icon and { " ", ft_icon, " ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) }
							or "",
						" ",
						{ filename, gui = modified and "bold,italic" or "bold" },
						" ",
						guibg = "#363944",
					}
					return buffer
				end,
			})
		end,
	},
	-- LazyGit integration with Telescope
	{
		"kdheepak/lazygit.nvim",
		keys = {
			{
				";c",
				":LazyGit<Return>",
				silent = true,
				noremap = true,
			},
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		init = function()
			-- Your DBUI configuration
			vim.g.db_ui_use_nerd_fonts = 1
		end,
		keys = {
			{

				"<leader>d",
				"<cmd>NvimTreeClose<cr><cmd>tabnew<cr><bar><bar><cmd>DBUI<cr>",
			},
		},
	},
	{
		"nvim-tree/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup({
				on_attach = function(bufnr)
					local api = require("nvim-tree.api")

					local function opts(desc)
						return {
							desc = "nvim-tree: " .. desc,
							buffer = bufnr,
							noremap = true,
							silent = true,
							nowait = true,
						}
					end

					-- default mappings
					api.config.mappings.default_on_attach(bufnr)

					-- custom mappings
					vim.keymap.set("n", "t", api.node.open.tab, opts("Tab"))
				end,
				actions = {
					open_file = {
						quit_on_open = true,
					},
				},
				sort = {
					sorter = "case_sensitive",
				},
				view = {
					width = 30,
					relativenumber = true,
				},
				renderer = {
					group_empty = true,
				},
				filters = {
					dotfiles = true,
					custom = {
						"node_modules/.*",
					},
				},
				log = {
					enable = true,
					truncate = true,
					types = {
						diagnostics = true,
						git = true,
						profile = true,
						watcher = true,
					},
				},
			})

			if vim.fn.argc(-1) == 0 then
				vim.cmd("NvimTreeFocus")
			end
		end,
	},
}
