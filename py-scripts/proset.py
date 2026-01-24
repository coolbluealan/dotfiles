str = input("STRING: ").lower().strip()
odd = False
pan = True
for vowel in ["a", "e", "i", "o", "u"]:
    count = str.count(vowel)
    if count % 2:
        odd = True
    if count != 1:
        pan = False
    print(vowel, ": ", count)

if not odd:
    print("PROSET")
if pan:
    print("PANVOWEl")
