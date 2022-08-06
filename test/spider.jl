struct A end
struct B end
struct C end
struct D
    b::B
    c::C
end
struct E end
struct F end
struct G end
struct H end
struct I end
struct J end
struct K end
struct L end
struct M end
struct N end
struct O end
struct P end
struct Q end
struct R end
struct S end
struct T end
struct U end
struct V end
struct W end
struct X end
struct Y end
struct Z end

A >> "hello"
"hello" >> B
A >> "hello" >> B
A >> ("hello" >> B)
[A, B] >> "hello"
[A, B] >> "hello" >> [C, D]

A >> B
[A, B] >> C
A >> [B, C]
[A, B] >> [C, D]
A >> B >> C
A >> (B >> C)
[A, B] >> C >> D
A >> [B, C] >> D
A >> B >> [C, D]
A >> [B, C] >> [D, E]

A >> B
A >> C

[A, B] >> C
[A, B] >> D
