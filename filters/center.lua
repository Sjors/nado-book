local center_for = {
  latex = {
    pre = pandoc.RawBlock('latex', '\\begin{center}'),
    post = pandoc.RawBlock('latex', '\\end{center}'),
  }
}

local function latex_width(attrs)
  local width = attrs.width
  if not width then
    return nil
  end

  local pct = width:match('^(%d+)%%$')
  if pct then
    return string.format('%.3f\\linewidth', tonumber(pct) / 100.0)
  end

  return width
end

function Div (div)
  if div.classes:includes('tightimg') and FORMAT == 'latex' then
    if #div.content == 1 and div.content[1].t == 'Para' and #div.content[1].content == 1 then
      local img = div.content[1].content[1]
      if img.t == 'Image' then
        local src = img.src
        local options = { 'height=\\textheight', 'keepaspectratio' }
        local width = latex_width(img.attributes)
        table.insert(options, 1, 'width=' .. (width or '\\maxwidth'))

        return {
          pandoc.RawBlock('latex', '\\begin{center}'),
          pandoc.RawBlock(
            'latex',
            '\\includegraphics[' .. table.concat(options, ',') .. ']{' .. src .. '}'
          ),
          pandoc.RawBlock('latex', '\\end{center}')
        }
      end
    end
  end

  if div.classes:includes('center') then
    if center_for[FORMAT] then
      local rv = {}
      if center_for[FORMAT].pre then
        rv[#rv+1] = center_for[FORMAT].pre
      end
      rv[#rv+1] = div
      if center_for[FORMAT].post then
        rv[#rv+1] = center_for[FORMAT].post
      end
      return rv
    end
  end
  return nil
end
