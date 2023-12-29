@enum HandType begin
    FiveKind=7
    FourKind=6
    FullHouse=5
    ThreeKind=4
    TwoPair=3
    OnePair=2
    HighCard=1
end

struct Hand
    handType::HandType
    hand::String
    handVal::Vector
    bid::Int
end

function handFreq(hand)
    d = Dict()
    for c in hand
        haskey(d,c) || (d[c] = 0)
        d[c] += 1
    end
    d
end

function handVal(hand)
    d = Dict([('A', 14), ('K', 13), ('Q', 12), ('J', 11), ('T', 10), ('9', 9),
        ('8', 8), ('7', 7), ('6', 6), ('5', 5), ('4', 4), ('3', 3), ('2', 2)])
    [d[c] for c in hand]
end

function jokerHandVal(hand)
    d = Dict([('A', 14), ('K', 13), ('Q', 12), ('J', 1), ('T', 10), ('9', 9),
        ('8', 8), ('7', 7), ('6', 6), ('5', 5), ('4', 4), ('3', 3), ('2', 2)])
    [d[c] for c in hand]
end

function handType(hand)
    d = handFreq(hand)
    hv = values(d)
    maximum(hv) == 5 && return FiveKind
    maximum(hv) == 4 && return FourKind
    (maximum(hv) == 3 && length(hv) == 2) && return FullHouse
    maximum(hv) == 3 && return ThreeKind
    (maximum(hv) == 2 && length(hv) == 3) && return TwoPair
    maximum(hv) == 2 && return OnePair
    HighCard
end

function jokerHandType(hand)
    d = handFreq(hand)
    hv = values(d)
    nJokers = haskey(d, 'J') ? d['J'] : 0
    ht = handType(hand)
    ht == FiveKind && return FiveKind
    ht == FourKind && return (nJokers == 1 || nJokers == 4) ? FiveKind : FourKind
    nJokers == 3 && return length(hv) == 2 ? FiveKind : FourKind
    ht == FullHouse && return nJokers == 2 ? FiveKind : (nJokers == 1 ? FourKind : FullHouse)
    ht == ThreeKind && return nJokers == 2 ? FiveKind : (nJokers == 1 ? FourKind : ThreeKind)
    ht == TwoPair && return nJokers == 2 ? FourKind : (nJokers == 1 ? FullHouse : TwoPair)
    ht == OnePair && return nJokers == 2 ? ThreeKind : (nJokers == 1 ? ThreeKind : OnePair)
    nJokers == 1 ? OnePair : HighCard
end

function readHands(f)
    hands = []
    for line in readlines(open(f))
        hand, bid = split(line, " ")
        push!(hands, Hand(handType(hand), hand, handVal(hand), parse(Int, bid)))
    end
    hands
end

function part1(f)
    hands = readHands(f)
    sortedHands = sort(hands, by = x -> (x.handType, x.handVal))
    total = 0
    for (i, hand) in enumerate(sortedHands)
        total += i*hand.bid
    end
    total
end

function part2(f)
    # update with the new rules
    hands = []
    for hand in readHands(f)
        push!(hands, Hand(jokerHandType(hand.hand), hand.hand, jokerHandVal(hand.hand), hand.bid))
    end
    sortedHands = sort(hands, by = x -> (x.handType, x.handVal))
    total = 0
    f = open("output/07_output_part2.txt", "w")
    for (i, hand) in enumerate(sortedHands)
        total += i*hand.bid
        write(f, string(hand)*"\n")
    end
    close(f)
    total
end

@time @show part1("data/07_input.txt")
@time @show part2("data/07_input.txt")