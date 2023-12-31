house("Βασιλέως Γεωργίου 35", 1, 50, 1, 1, 0, 1, 0, 300).
house("Αγγελάκη 7", 2, 45, 1, 0, 0, 1, 0, 335).
house("Κηφισίας 10", 2, 65, 0, 2, 0, 1, 0, 350).
house("Πλαστήρα 72", 2, 55, 0, 1, 1, 0, 15, 330).
house("Τσιμισκή 97", 3, 55, 1, 0, 0, 1, 15, 350).
house("Πολυτεχνείου 19", 2, 60, 1, 3, 0, 0, 0, 370).
house("Ερμού 22", 3, 65, 1, 1, 0, 1, 12, 375).
house("Τσικλητήρα 13", 3, 65, 0, 2, 1, 0, 0, 320).
house(X) :-                  house(X, _, _, _, _, _, _, _, _).
bedrooms(X, Value) :-        house(X, Value, _, _, _, _, _, _, _).
area(X, Value) :-            house(X, _, Value, _, _, _, _, _, _).
in_city_center(X, Value) :-  house(X, _, _, Value, _, _, _, _, _).
floor_number(X, Value) :-    house(X, _, _, _, Value, _, _, _, _).
has_elevator(X, Value) :-    house(X, _, _, _, _, Value, _, _, _).
allows_pets(X, Value) :-     house(X, _, _, _, _, _, Value, _, _).
yard_area(X, Value) :-       house(X, _, _, _, _, _, _, Value, _).
rent_amount(X, Value) :-     house(X, _, _, _, _, _, _, _, Value).
address(X, Value) :-         house(X, _, _, _, _, _, _, _, _), Value = X.