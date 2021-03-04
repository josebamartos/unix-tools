#!/usr/bin/env python

list_one = ["1.0.0.0/8", "128.0.0.0/16"]
list_two = ["1.0.0.0/8", "128.0.0.0/16", "192.0.0.0/24", "192.168.1.15/32"]
list_two = list(set(list_two))

if len(list_one) > len(list_two):
    difference = list(set(list_one) - set(list_two))
else:
    difference = list(set(list_two) - set(list_one))
difference.sort()
difference = ", ".join(difference)

print("List 1 length: ", len(list_one))
print("List 2 length: ", len(list_two))
print("Difference: ", difference)
