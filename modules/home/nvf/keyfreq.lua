local M = {}

local counts = {}
local dirty = false
local path = vim.fn.stdpath("state") .. "/keyfreq.json"

-- Modes we care about. `vim.fn.mode()` returns e.g. "n", "v", "V", "\22", "no".
local function counted_mode()
  local m = vim.fn.mode()
  local first = m:sub(1, 1)
  return first == "n" or first == "v" or first == "V" or first == "\22"
end

local function read_disk()
  local fd = io.open(path, "r")
  if not fd then
    return {}
  end
  local body = fd:read("*a")
  fd:close()
  local ok, decoded = pcall(vim.json.decode, body)
  if not ok or type(decoded) ~= "table" then
    return {}
  end
  return decoded
end

function M.flush()
  if not dirty then
    return
  end
  local merged = read_disk()
  for key, n in pairs(counts) do
    merged[key] = (merged[key] or 0) + n
  end
  local fd = io.open(path, "w")
  if not fd then
    return
  end
  fd:write(vim.json.encode(merged))
  fd:close()
  counts = {}
  dirty = false
end

function M.report()
  M.flush()
  local merged = read_disk()
  local rows = {}
  local total = 0
  for key, n in pairs(merged) do
    rows[#rows + 1] = { key = key, n = n }
    total = total + n
  end
  table.sort(rows, function(a, b)
    return a.n > b.n
  end)

  local lines = {
    "# keyfreq — normal/visual keypresses",
    "",
    ("total: %d   file: %s"):format(total, path),
    "",
    "| count |    % | key |",
    "| ----- | ---- | --- |",
  }
  for _, row in ipairs(rows) do
    lines[#lines + 1] =
      ("| %5d | %4.1f | %s |"):format(row.n, total > 0 and row.n / total * 100 or 0, row.key)
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].filetype = "markdown"
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"
  vim.cmd.tabnew()
  vim.api.nvim_win_set_buf(0, buf)
end

function M.reset()
  counts = {}
  dirty = false
  os.remove(path)
  vim.notify("keyfreq: counters reset", vim.log.levels.INFO)
end

function M.setup()
  vim.on_key(function(_, typed)
    -- `typed` is the pre-mapping keystroke; nil when the key came from a
    -- mapping expansion, which we do not want to double count.
    if not typed or typed == "" then
      return
    end
    if not counted_mode() then
      return
    end
    local name = vim.fn.keytrans(typed)
    counts[name] = (counts[name] or 0) + 1
    dirty = true
  end, vim.api.nvim_create_namespace("keyfreq"))

  vim.api.nvim_create_autocmd({ "VimLeavePre", "FocusLost" }, {
    group = vim.api.nvim_create_augroup("keyfreq", { clear = true }),
    callback = function()
      M.flush()
    end,
  })

  vim.api.nvim_create_user_command("KeyFreq", M.report, { desc = "Show keypress frequency" })
  vim.api.nvim_create_user_command("KeyFreqReset", M.reset, { desc = "Reset keypress counters" })
end

M.setup()

-- Exposed for ad-hoc inspection: `:lua print(vim.inspect(KeyFreq))`.
_G.KeyFreq = M

return M
