-- The last type is the return type.
-- A single type means it takes 0 arguments
thing : Int
thing = 0

-- You can alias a type
type alias Model = Int

-- This allows us to make more readable types.
model : Model
model = 0

-- This is a sum type (specifially a boolean type).
-- You may also see: tagged or disjoint unions or variant types
type Msg = Increment | Decrement

-- Why boolean and sum?
-- Because there are 2 possible options
type Bool = False | True

-- Sum Types can have as many options as you'd like
type Cars = Mustang | Camero | Taurus | Fit | Focus

-- Why called Sum Type?
-- You can find the total number of possible values by adding them
-- Bool has 2 possible options (False + True)
-- Cars has 5 possible options (Mustang + Camero + Taurus + Fit + Focus)
-- Note this is not the "space". To get that you need to use the max possible space of Int


-- FUNCTION TYPES AND ARROWS

-- PARTIALLY APPLIED FUNCTIONS AND CURRYING

-- This takes 2 integers and returns and Int
add1 : Int -> Int -> Int
add1 x y = x + y

-- But it doesn't have to. You can pass only one argument
add1 1
-- What happens. Well you can read that like
add1 : Int -> (Int -> Int)
-- This means when you don't pass all of the arguments in you will get back a function.
-- So:
add1 1
-- Returns a function
-- Let's set that to a variable
let add2 = add1
-- Now add2 is a function that takes a single argument. It looks like
add2 : Int -> Int
add2 x = add1 1
-- or
add2 x = 1 + x
-- So if we call it
add2 2 -- 3


-- Btw this can be done in Javascript, Python, etc
-- Javascript:
> var myCurriableFunction = function (x, y, z){
    return function (y, z){
      x + y + z;
    }
  }

> myCurriableFunction(2);

function (y, z){  
  x + y + z;
}


-- Back to our code


-- This takes 2 arguments, a Msg and a Model and returns a Model
update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      model + 1

    Decrement ->
      model - 1

-- This takes a single type of Model and returns a single type of Html Msg
view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (toString model) ]
    , button [ onClick Increment ] [ text "+" ]
    ]


-- TYPE ALIASES

-- Html is another type alias for:
type alias Html msg = VirtualDom.Node msg
-- This type as a "generic" type.

-- The msg could be anything:
type alias Html a = VirtualDom.Node a


-- RECORDS

-- What if we want to store multiple values?
-- Record Types!
type alias Record =
    { value : Int
    , count : Int
    }

-- Records are often called Product Types or Tuples
-- Why?
-- It's a compound type that is formed by a sequence of types and is commonly denoted:
-- (T1, T2, ..., Tn) or T1 x T2 x ... x Tn
-- They correspond to cartesian products thus products types
-- By allowing you to be named they become records
-- Or potentially in other languages ... structs, classes, etc
-- So you find the total number of options by multiplying the maximum value of each option.
-- https://www.stephanboyer.com/post/18/algebraic-data-types

record : Record
record =
    { value = 0
    , count = 0
    }

-- Accessing properties
getValue : Record -> Int
getValue record = record.value

-- Updating Properties
updateValue : Int -> Record -> Record
updateValue newValue existingRecord = { existingRecord | value = newValue }

-- Shorthand accessors
getValueShort : Record -> Int
getValueShort record = .value record

-- We can do neat stuff

type alias Record2 =
    { value : Int
    , count : Int
    , foo : String
    }

type alias Record3 =
    { value : Int
    , count : Int
    , bar : String
    }

type alias Record4 =
    { value : Int
    , foobar : String
    }

type alias ValueRecord a =
    { a | value : Int }


getValue2 : ValueRecord a -> Int
getValue2 valRec = valRec.value
-- COMPILES: getValue2 record2
-- COMPILES: getValue2 record3
-- COMPILES: getValue2 record4

updateRecord : Int -> { a | value : Int, count : Int } -> { a | value : Int, count : Int }
updateRecord rec newValue =
    { rec
    | value = newValue
    , count = count + 1
    }
-- COMPILES: updateRecord 1 record2
-- COMPILES: updateRecord 1 record3
-- DOESN'T COMPILE: updateRecord 1 record4


-- NULLS
-- DON'T EXIST!!!!

-- If we can't have a null we need something to help us
-- What does a NULL mean?
-- It meas we either have something or we don'to

-- So what about something called either
type Either a b
    = Left a
    | Right b

-- But really it's not THAT generic. How about?
type Result error value
    = Ok value
    | Err error

-- Well this makes a ton of since for an error but this isn't an error. 
-- It's expected and it means Nothing, so what about maybe ...
type Maybe a
    = Just a
    | Nothing

-- Now we have something. Maybe we Just have a value (of type a) or we have Nothing

giveMeIfGreatherThan0 : Int -> Maybe Int
giveMeIfGreatherThan0 val =
    if val > 0 then
        Just val
    else
        Nothing

-- But now there is this structure that w ehave to deal with.
-- Thankfully there are many functions in the maybe package to help us out
withDefault : a -> Maybe a -> a
withDefault default maybe =
    case maybe of
      Just value -> value
      Nothing -> default

withDefault 10 (Just 15) -- 15
withDefault "foo" (Just "bar") -- "bar"
withDefault 10 (Nothing) -- Nothing
withDefault "foo" (Nothing) -- Nothing

-- Map
map : (a -> b) -> Maybe a -> Maybe b
map f maybe =
    case maybe of
      Just value -> Just (f value)
      Nothing -> Nothing

-- Hmm so we take in a function a maybe and return a slightly modified maybe
-- Let's create a function from (a -> b)
-- This could be:
add1 : Int -> Int
add1 val = val + 1
-- In this case we use the same type. It doesn't have to be 2 different types

-- but we can do that
positiveMessage : Int -> String
positiveMessage val =
    if val > 0 then
        "I'm a positive message!"
    else
        "I'm not so postivie :("

-- Now we can "map" that function over our Maybe ... wut!

map add1 (Just 10) -- Just 11
map add1 Nothing -- Nothing
map positiveMessage (Just 10) -- Just "I'm a positive message!"
map positiveMessage (Just -23) -- Just "I'm not so positive :("
map positiveMessage Nothing -- Nothing



-- LISTS

simpleList : List Int
simpleList = [1, 2, 3, 4]

insertIntoSimpleList : Int -> List Int
insertIntoSimpleList num = num :: [1, 2, 3, 4]

-- LOOPS?
-- Elm doesn't have them
-- We use functions. It is functional programming after all

-- FOLDS
-- We start with a fold

-- This is a fold left of Ints
-- The left means we reduce (or traverse) from the left
foldlInt : (Int -> Int -> Int) -> Int -> List Int -> Int
foldlInt func aggVal list =
    case list of
        [] ->
            aggVal

        x :: xs ->
            foldl func (func x aggVal) xs

-- It takes a function of two values that returns one
-- It then takes some value to accumulate into. Something that can accumulate like a list, a string, a number
-- It also takes a starting value
-- So this takes a function of prepend (insert into the 0 index of a list)
-- as well as an empty list to accumlate into
-- and of course our starting list
-- Thus starting from the left we prepend 1 we have [1]
-- And the inserting 2 into the 0 index we have [2, 1]
-- And then we finish by prepending the 3: [3,2,1]
foldlInt (::) [] [1,2,3] == [3,2,1]

-- We also can fold from the right
foldrInt : (Int -> Int -> Int) -> Int -> List Int -> Int

-- Using the same arugments as before we end up with the same list we started 
-- Since we started from the right we prepend 3 we have [3]
-- And the inserting 2 into the 0 index we have [2, 3]
-- And then we finish by prepending the 1: [1,2,3]
foldrInt (::) [] [1,2,3] == [1,2,3]

-- We of course can pass in different types of functions
-- What if we use the max function
foldlInt max 0 [1,2,3] == 3
-- We give it the builtin max function that is a more generic version of:
max : Int -> Int
max x y = if x > y then x else y


-- We can then make this a nice function.
maximumInt : List Int -> Int
maximumInt list =
  case list of
    x :: xs ->
        Just (foldl max x xs)

    [x] ->
        x

    [] ->
        0

-- But this kinda sucks. If we give an empty list we get back a 0.
-- Which might be ok but isn't obvious.
maximumInt [1,2] == 2
maximumInt [1] == 1
maximumInt [] == 0 -- Blech!

-- How about using a Maybe?
-- Why Maybe?
maximumInt : List Int -> Maybe Int
maximumInt list =
  case list of
    x :: xs ->
      Just (foldl max x xs)

    _ ->
      Nothing

maximumInt [1,2] == Just 2
maximumInt [1] == Just 1
maximumInt [] == Nothing

-- Now if we want to get a 0 value when the list is empty we just use what we already have:
withDefault 0 (maximumInt [1,2]) == 2
withDefault 0 (maximumInt [1]) == 1
withDefault 0 (maximumInt []) == 0

-- While we're here, we do this function chaining quite a bit.
-- And we're not a lisp so we'd like to avoid all of the parentheses.
-- Thankfully elm gives us some nice symbols to use
withDefault 0 <| maximumInt [1,2] == 2
withDefault 0 <| maximumInt [1] == 1
withDefault 0 <| maximumInt [] == 0

-- This allows us to do nice chaining when we have many functions

withDefault 0
    <| maximumInt
    <| range 0 10
== 10

-- or
[1,2,3]
    |> maximumInt
    |> withDefault 0
== 3


-- Also while we're here let's make the fold more generic:
foldl : (a -> b -> b) -> b -> List a -> b
foldl func acc list =
    case list of
        [] ->
            acc

        x :: xs ->
            foldl func (func x acc) xs

-- Now our fold function can work on many different data types.

-- With generic fold functions what can we do?
-- It turns out, quite a lot.
map : (a -> b) -> List a -> List b
map f xs =
  foldr (\x acc -> f x :: acc) [] xs

map (\x -> x + 1) [1,2,3] == [2,3,4]

add1 : Int -> Int
add1 x = x + 1

map add1 [1,2,3] == [2,3,4]

-- There are all kinds of functions for working with lists in the List.elm module in the standard library
-- Just like Python, Javascript and Ruby
-- isEmpty, length, reverse, member, head, tail, filter, take, drop, sum, all, etc

-- Elm has documentation to help you transition
-- http://elm-lang.org/docs/from-javascript



-- IMMUTABILITY

-- One last thing before we get to the real fun
-- Purescript is functional and immutable ... so can we store state?
-- Yes
-- It's no different than const in js but you must do it within a let expression.

forty : Int
forty =
    let
        twentyFour =
            3 * 8

        sixteen =
            4 ^ 2
    in
        twentyFour + sixteen

-- You just can't reassign the same variable
bad : Int
bad =
    let
        twentyFour =
            3 * 8

        twentyFour =
            20 + 4
    in
        twentyFour
-- This will not compile.

good : Int
good =
    let
        twentyFour =
            3 * 8

        newTwentyFour =
            20 + 4
    in
        newTwentyFour
-- This will compile.


-- 2 other notes
-- You can assign functions
-- And you can provide type annotations

letFunctions : Int
letFunctions =
    let
        hypotenuse a b = 
            sqrt (a^2 + b^2)

        name : String
        name =
            "Hermann"

        increment : Int -> Int
        increment n =
            n + 1
    in
        increment 10
