local ffi = require("ffi")

---@class StringTokenizer
local StringTokenizer = {}
---@protected
StringTokenizer.__index = StringTokenizer

ffi.cdef [[
typedef struct {
    unsigned short pBegin, pEnd;
    unsigned char captureIndex;
} StringTokenizerToken;
]]

-- StringTokenizer Constants

---@type "StringTokenizer"
StringTokenizer.class = "StringTokenizer"

---@type string[]
StringTokenizer.captures = {
    "[%a]+", "[%c]+", "[%d]+",
    "[%l]+", "[%p]+", "[%s]+",
    "[%u]+", "[%w]+", "[%x]+",
    "[%z]+"
}

-- ^ rather basic captures, probably also has overlap.
-- I recommend you overwrite this with your own capture group in practice.
-- Can be done simply by setting the captures field with your own table
-- in the class instance.

-- StringTokenizer Functions

---@type fun(str: string): StringTokenizer
function StringTokenizer.new(str)
    if type(str) ~= "string" then
        error("bad argument #1 to 'new' (string expected, got" .. type(str) .. ")", 2)
    end

    ---@class StringTokenizer
    local tokenizer = setmetatable({}, StringTokenizer)

    ---@type (ffi.cdata* | table)[]
    tokenizer.tokens = {}

    ---@type ffi.cdata* | table?
    tokenizer.lastToken = nil

    ---@type integer
    tokenizer.initPosition = 1

    ---@type string
    tokenizer.string = str

    return tokenizer
end

---@type fun(self: StringTokenizer): ffi.cdata* | table?
function StringTokenizer.next(self)
    local newPosition
    local token

    for captureIndex, capt in next, self.captures do
        local pBegin, pEnd = self.string:find(capt, self.initPosition)

        if pBegin and pBegin == self.initPosition then
            token = ffi.new("StringTokenizerToken", {
                pBegin = pBegin,
                pEnd = pEnd,
                captureIndex = captureIndex
            })

            table.insert(self.tokens, token)

            newPosition = pEnd + 1
            break
        end
    end

    self.initPosition = newPosition
    self.lastToken = token

    return token
end

return StringTokenizer
