-- Reads resume.yaml and prints its content into resume_v2.tex using the
-- layout macros defined there (\nameline, \ulink, \job, \skill, rbullets).
-- Uses tinyyaml.lua from this folder to parse the YAML.

local yaml = require("tinyyaml")

resume = {}

local data

function resume.load(path)
  local f = assert(io.open(path, "r"), "cannot open " .. path)
  data = yaml.parse(f:read("*a"))
  f:close()
end

-- Turn a YAML value into LaTeX: escape special characters, then turn
-- **text** into \metric{text}
local specials = {
  ["\\"] = "\\textbackslash{}", ["&"] = "\\&", ["%"] = "\\%", ["$"] = "\\$",
  ["#"] = "\\#", ["_"] = "\\_", ["{"] = "\\{", ["}"] = "\\}",
  ["~"] = "\\textasciitilde{}", ["^"] = "\\textasciicircum{}",
}

local function esc(value)
  if value == nil then return "" end
  local s = tostring(value):gsub("%s+$", "")
  s = s:gsub("[\\&%%$#_{}~^]", specials)
  s = s:gsub("%*%*(.-)%*%*", "\\metric{%1}")
  return s
end

local function out(s)
  for line in (s .. "\n"):gmatch("(.-)\n") do tex.print(line) end
end

-- Join the non-empty parts with the header separator
local function joinparts(parts)
  return table.concat(parts, " \\;|\\; ")
end

local function link(prefix, value)
  return "\\ulink{" .. prefix .. esc(value) .. "}{" .. esc(value) .. "}"
end

function resume.header()
  local c = data.contact or {}
  local logos = {}
  for _, path in ipairs(data.logos or {}) do
    logos[#logos + 1] = "\\includegraphics[height=2.2cm]{" .. path .. "}"
  end

  local line1, line2 = {}, {}
  if c.email then line1[#line1 + 1] = link("mailto:", c.email) end
  if c.phone then line1[#line1 + 1] = esc(c.phone) end
  if c.website then line1[#line1 + 1] = link("https://", c.website) end
  if c.location then line2[#line2 + 1] = esc(c.location) end
  if c.linkedin then line2[#line2 + 1] = link("https://", c.linkedin) end
  if c.github then line2[#line2 + 1] = link("https://", c.github) end

  out("\\begin{center}")
  out("\\nameline{\\fontsize{26}{30}\\selectfont\\bfseries " .. esc(data.name) .. "}"
      .. "{" .. table.concat(logos, "\\hspace{4pt}") .. "}\\par")
  out("\\vspace{5pt}")
  if #line1 > 0 then out(joinparts(line1) .. "\\par") end
  if #line2 > 0 then out(joinparts(line2) .. "\\par") end
  if data.headline then
    out("\\vspace{9pt}")
    out("{\\Large\\bfseries " .. esc(data.headline) .. "}\\par")
  end
  out("\\end{center}")
end

function resume.summary()
  out(esc(data.summary))
end

local function bullets(items)
  if not items or #items == 0 then return end
  out("\\begin{rbullets}")
  for _, item in ipairs(items) do out("\\item " .. esc(item)) end
  out("\\end{rbullets}")
end

function resume.experience()
  for _, job in ipairs(data.experience or {}) do
    local dates = esc(job.start)
    if job["end"] then dates = dates .. " -- " .. esc(job["end"]) end
    out("\\job{" .. esc(job.company) .. "}{" .. esc(job.location) .. "}{"
        .. esc(job.title) .. "}{" .. dates .. "}")
    bullets(job.highlights)
  end
end

function resume.skills()
  out("\\begin{rbullets}[1.4em]")
  for _, skill in ipairs(data.skills or {}) do
    out("\\skill{" .. esc(skill.category) .. "}{" .. esc(skill.items) .. "}")
  end
  out("\\end{rbullets}")
end

function resume.education()
  for _, edu in ipairs(data.education or {}) do
    out("\\job{" .. esc(edu.institution) .. "}{" .. esc(edu.location) .. "}{"
        .. esc(edu.degree) .. "}{" .. esc(edu.year) .. "}")
    bullets(edu.highlights)
  end
end
