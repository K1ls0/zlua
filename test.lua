--print("Here we go!")
--print("What have we got here?")

function Mul(a, b)
    return a * b
end

--A = {
--    {"this"}:{"This"},
--}

function Main()
    print("Mul:", Mul(10, 2))
    print("Mul2:", Mul2(10, 2))
end


function Concat(s, b)
    return s .. tostring(b)
end
