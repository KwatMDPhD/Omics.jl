struct Artist end
struct Art end
Artist >> Art

struct Camo end
struct Hunter

    camo::Camo

end
struct Bow end
struct ElkHunting end
[Hunter, Bow] >> ElkHunting

struct Entrepreneur end
struct Problem end
struct Solution end
[Entrepreneur, Problem] >> Solution

struct Chocolate end
struct Marshmallow end
struct Smore end
[Chocolate, Marshmallow] >> Smore

struct Parent end
struct Happy end

struct Christmas end
struct NewToy end
[Parent, Happy, Christmas] >> NewToy

struct Summer end
struct Fishing end
[Parent, Happy, Summer] >> Fishing

struct BullMarket end
struct PrivateJet end
[Parent, BullMarket, Happy] >> PrivateJet
