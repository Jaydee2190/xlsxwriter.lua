----
-- Tests for the xlsxwriter.lua worksheet class.
--
-- Copyright 2014-2015, John McNamara, jmcnamara@cpan.org
--

require "Test.More"
require "Test.LongString"

plan(1)

----
-- Tests setup.
--
local expected
local got
local caption
local Worksheet = require "xlsxwriter.worksheet"
local Format    = require "xlsxwriter.format"
local SST       = require "xlsxwriter.sharedstrings"
local worksheet

-- Remove extra whitespace in the formatted XML strings.
function _clean_xml_string(s)
  return (string.gsub(s, ">%s+<", "><"))
end

----
-- Test the _write_worksheet() method.
--
caption = " \tWorksheet: Worksheet: _assemble_xml_file()"
expected = _clean_xml_string([[
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <dimension ref="A2:D3"/>
  <sheetViews>
    <sheetView tabSelected="1" workbookViewId="0"/>
  </sheetViews>
  <sheetFormatPr defaultRowHeight="15"/>
  <sheetData>
    <row r="2" spans="1:4">
      <c r="A2" s="2"/>
      <c r="B2" s="2"/>
      <c r="C2" s="2"/>
      <c r="D2" s="2"/>
    </row>
    <row r="3" spans="1:4">
      <c r="B3" s="1" t="s">
        <v>0</v>
      </c>
      <c r="C3" s="1"/>
    </row>
  </sheetData>
  <mergeCells count="2">
    <mergeCell ref="B3:C3"/>
    <mergeCell ref="A2:D2"/>
  </mergeCells>
  <pageMargins left="0.7" right="0.7" top="0.75" bottom="0.75" header="0.3" footer="0.3"/>
</worksheet>]])

local format1 = Format:new{xf_index = 1}
local format2 = Format:new{xf_index = 2}

worksheet = Worksheet:new()
worksheet:_set_filehandle(io.tmpfile())
worksheet.str_table = SST:new()

worksheet:merge_range("B3:C3", "Foo", format1)
worksheet:merge_range("A2:D2", "",    format2)

worksheet:select()
worksheet:_assemble_xml_file()

got = _clean_xml_string(worksheet:_get_data())

is_string(got, expected, caption)
