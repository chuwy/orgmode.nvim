local config = require('orgmode.config')
local Date = require('orgmode.objects.date')
local Files = require('orgmode.parser.files')

---@class Journal
---@field span string|number
Journal = {}


---@param opts table
function Journal:new()
  local data = { }
  setmetatable(data, self)
  self.__index = self return data
end

function Journal:new_entry()
  local time = Date.now()
  local filename = _zero_pad(time.year).."-".._zero_pad(time.month).."-".._zero_pad(time.day)..".org"
  local full_path = _append_slash(config.org_journal_dir)..filename

  if _file_exists(full_path) then
    self:add(full_path)
  else
    self:create(full_path)
  end
end

function Journal:create(full_path)
  local time = Date.now()
  local content = {"#+TITLE: "..time.day, "* "}
  buf = vim.api.nvim_create_buf(false, true) -- create new emtpy buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, content)
  local opts = {
    relative = "editor",
    width = vim.api.nvim_get_option("columns") - 10,
    height = vim.api.nvim_get_option("lines") - 10,
    style = "minimal",
    row = 2,
    col = 4
  }
  win = vim.api.nvim_open_win(buf, true, opts)
end

function Journal:add(full_path)
  local content = {"#+TITLE: "..time.day, "* "}
  buf = api.nvim_create_buf(false, true) -- create new emtpy buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, content)
end


function _zero_pad(num)
  str = tostring(num)
  if (#str == 1) then
    return "0" .. str
  else 
    return str
  end
end

function _append_slash(path)
  if #path == 0 then
    return ''
  elseif path:sub(-1) == '/' then
    return path
  else
    return path .. '/'
  end
end

function _file_exists(fname)
  local stat = vim.loop.fs_stat(fname)
  return (stat and stat.type) or false
end

instance = Journal:new()
return instance
