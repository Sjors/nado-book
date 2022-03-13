local center_for = {
  latex = {
    pre = pandoc.RawBlock('latex', '\\begin{center}'),
    post = pandoc.RawBlock('latex', '\\end{center}'),
  }
}

function Div (div)
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
