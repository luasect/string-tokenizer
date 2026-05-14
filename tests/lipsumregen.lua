-- 512 bytes of Lorum Ipsum
-- Will regenerate it with the tokenizer
-- but will add newlines after commas and dots.

local ffi = require("ffi")

local StringTokenizer = require("stringtokenizer")

local lipsum =
[[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam vel sagittis ex. Quisque non imperdiet sapien. Pellentesque eu ligula a nisi tincidunt gravida. Curabitur faucibus ante nisl, ut pretium turpis fermentum sed. Sed fermentum condimentum est, sit amet consectetur nunc mollis in. Interdum et malesuada fames ac ante ipsum primis in faucibus. Aliquam tempor quam sit amet justo cursus tincidunt. Morbi quis quam accumsan, varius ex vitae, fermentum mauris. Cras quis diam libero. Nam posuere massa et.]]

local tokenizer = StringTokenizer.new(lipsum)
tokenizer.captures = {
    "[A-Za-z]+", -- words
    "[%,%.]+",   -- comma, dot
    "[\32]+",    -- space
}

local lipsumFile, err = io.open("lipsum.txt", "wb")

if not lipsumFile then
    error(err)
end


local i = 0
while tokenizer:next() do
    i = i + 1
    local tk = tokenizer.lastToken
    local lastTk = tokenizer.tokens[i - 1] -- confusing naming i know
    if tk then
        if lastTk and lastTk.captureIndex == 2 and tk.captureIndex == 3 then
            -- skip because there will be a
            -- trailing new line after dots and commas
            goto continue
        else
            local str = ffi.string(tk.string) ..
                (tk.captureIndex == 2 and "\10" or "")

            lipsumFile:write(str)
        end
    end
    ::continue::
end
