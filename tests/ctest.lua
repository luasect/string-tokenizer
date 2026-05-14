local ffi = require("ffi")

local StringTokenizer = require("stringtokenizer")

local tokenizer = StringTokenizer.new([[int main(int argc, char** argv) {
    printf("Hello World!");
};]])
tokenizer.captures = {
    "[A-Za-z]+", -- identifiers
    "[%p]",
    "\32+",
    "\10+"
}

-- works as an iterator, too
for token in StringTokenizer.next, tokenizer do
    print(ffi.string(token.string))
end