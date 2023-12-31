customer("John Smith", 45, 2, 1, 3, 400, 300, 250, 5, 2).
customer("Nick Cave", 55, 2, 1, 3, 450, 350, 300, 7, 3).
customer("George Harris", 50, 3, 1, 1, 500, 350, 300, 7, 5).
customer("Harrison Ford", 50, 2, 0, 0, 370, 300, 350, 5, 0).
customer("Will Smith", 100, 5, 1, 0, 100, 50, 25, 2, 1).
customer(X) :-                             customer(X, _, _, _, _, _, _, _, _, _).
min_area(X, Value) :-                      customer(X, Value, _, _, _, _, _, _, _, _).
min_bedrooms(X, Value) :-                  customer(X, _, Value, _, _, _, _, _, _, _).
needs_pet(X, Value) :-                     customer(X, _, _, Value, _, _, _, _, _, _).
needs_elevator_above_floor(X, Value) :-    customer(X, _, _, _, Value, _, _, _, _, _).
max_rent_cutoff(X, Value) :-               customer(X, _, _, _, _, Value, _, _, _, _).
max_rent_for_city_center(X, Value) :-      customer(X, _, _, _, _, _, Value, _, _, _).
max_rent_for_suburbs(X, Value) :-          customer(X, _, _, _, _, _, _, Value, _, _).
max_rate_per_extra_area_unit(X, Value) :-  customer(X, _, _, _, _, _, _, _, Value, _).
max_rate_per_yard_area_unit(X, Value) :-   customer(X, _, _, _, _, _, _, _, _, Value).
customer_name(X, Value) :-                 customer(X, _, _, _, _, _, _, _, _, _), Value = X.