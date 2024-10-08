return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "debugloop/telescope-undo.nvim",
      "nvim-tree/nvim-web-devicons",
      "folke/todo-comments.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local builtin = require("telescope.builtin")
      local transform_mod = require("telescope.actions.mt").transform_mod

      local trouble = require("trouble")
      local trouble_telescope = require("trouble.sources.telescope")

      -- or create your custom action
      local custom_actions = transform_mod({
        open_trouble_qflist = function(prompt_bufnr)
          trouble.toggle("quickfix")
        end,
      })

      telescope.setup({
        extensions = {
          undo = {},
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
        defaults = {
          path_display = { "smart" },
          mappings = {
            i = {
              ["<C-k>"] = actions.move_selection_previous, -- move to prev result
              ["<C-j>"] = actions.move_selection_next, -- move to next result
              ["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
              ["<C-t>"] = trouble_telescope.open,
            },
          },
        },
      })
      telescope.load_extension("ui-select")
      telescope.load_extension("file_browser")
      telescope.load_extension("neoclip")
      telescope.load_extension("undo")

      -- set keymaps
      local keymap = vim.keymap -- for conciseness

      -- Find files
      keymap.set("n", "<leader>ff", function()
        builtin.find_files()
      end, { desc = "Fuzzy find files in cwd" })

      -- TODO: current location
      -- keymap.set("n", "<leader>fr", function()
      --   builtin.loclist()
      -- end, { desc = "Telescope: find files in current location" })

      -- Find string
      keymap.set("n", "<leader>fg", function()
        builtin.live_grep()
      end, { desc = "Find string in cwd" })

      -- Find buffers
      keymap.set("n", "<leader><space>", function()
        builtin.buffers()
      end, { desc = "Find buffers" })

      -- File Browser
      keymap.set("n", "<space>fb", "<cmd>Telescope file_browser<CR>", { noremap = true, desc = "Open File Browser" })

      -- Undo History
      keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>", { desc = "Open Undo History" })

      -- Find Key Maps
      keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Show Keymaps" })

      -- Fuzzily Search in current buffer
      keymap.set("n", "<leader>/", function()
        require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
          layout_config = { width = 0.7 },
        }))
      end, { desc = "[/] Fuzzily search in current buffer" })

      -- Find Harpoon Marks
      -- keymap.set("n", "<C-e>", ":Telescope harpoon marks<CR>", { desc = "Show Harpoon marks" })

      -- Find Help Tags
      keymap.set("n", "<leader>fh", function()
        builtin.help_tags()
      end, { desc = "Find Help Tags" })

      -- Find TODOs
      keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })

      -- Find hidden files
      keymap.set("n", "<leader>fe", function()
        builtin.find_files({ hidden = true, find_command = { "rg", "--files", "--glob", ".env*" } })
      end, { desc = "Find hidden files" })
    end,
  },
}
