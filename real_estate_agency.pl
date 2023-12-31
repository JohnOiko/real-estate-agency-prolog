/*-------------------------------------------------------------------------------
  Ονοματεπώνημο: Ιωάννης Οικονομίδης
  AEM: 3668

  I have made the following changes in the houses.pl and request.pl files:
	-I have added 10 predicates to the houses.pl file you provided us with
	in e-Learning. Out of those, house/1, house(X) succeeds if a house in
	the address X exists. The rest succeed when a house in the address X
	exists and return the value of their name's parameter of the house in
	the address X.
	-I have added 11 predicates to the requests.pl file you provided us with
	in e-Learning. Out of those, customer/1, customer(X) succeeds if a
	customer named X exists. The rest succeed when a customer named X exists
	and return the value of their name's parameter of the customer named X.
	-I changed the values yes to 1 and no to 0 in the houses.pl file for
	the attributes that say if the house is in the city center, has an
	elevator and allows or not pets. I also made the same changes in the
	requests.pl file for the attribute of whether the customer needs a
	pet or not. When printed, they are still shown as yes and no instead
	of 1 and 0, the changes are only in the input files houses.pl and
	requests.pl.
	-The additions and changes to those two files where made using the
	script downloaded from https://github.com/Abductcows/prolog-data-helper
	you provided us within e-Learning.
	
  File encoding:
	-All three files included in the .zip file I uploaded to
	e-Learning have their encoding set to 'UTF-16 BE BOM' because using
	'UTF-8' made greek characters not appear correctly, while 'UTF-16 BE BOM'
	works correctly with greek characters.

  How the program works:
	-For additional explanations on what each individual predicate does,
	every predicate has comments with what it takes as input and what it
	returns above its definition.
	-The predicate run/0 is used to start the program, write the
	main menu and read the user's choice. Then it calls one of the predicates
	do_on_choice/1 with the user's choice as parameter.
	-If the user's choice is 1, the program runs in interactive
	mode, if 2 it runs in batch mode, if 3 it runs in auction mode,
	if 0 the program stops running and if something else an error message is
	written.
	-Before the do_on_choice/1 predicates are finished, they call run again
	to continue the execution, unless the user's choice is 0 in which case
	run is not called again and the program's execution stops.
	-do_on_choice(1) first reads the user's requirements, then finds all
	the compatible houses based on the given requirements. If no
	compatible houses were found, it writes a message that informs the user.
	If at least one compatible house was found, first the compatible houses
	are written and then the best house is found and also written.
	-do_on_choice(2) first finds all the compatible and the best houses for
	each customer in the requests.pl file and then writes the compatible
	houses and the best house for each customer.
	-do_on_choice(3) first finds all the compatible and the best houses for
	each customer in the requests.pl file. Then it refines the houses and
	recalculates each customer's bid that has no house until all customers
	claim up to a max of one house. Then the house each customer has
	claimed is written.
--------------------------------------------------------------------------------*/

?- consult('houses.pl').
?- consult('requests.pl').

%%% run/0
%%% run.
%%% Starts running the program. Exits when the user gives 0 as their choice.
run :-
	nl,
	write('Μενού:'), nl,
	write('======'), nl, nl,
	write('1 - Προτιμήσεις ενός πελάτη'), nl,
	write('2 - Μαζικές προτιμήσεις πελατών'), nl,
	write('3 - Επιλογή πελατών μέσω δημοπρασίας'), nl,
	write('0 - Έξοδος'), nl, nl,
	write('Επιλογή: '),
	read(Choice), nl, nl,
	do_on_choice(Choice).

%%% do_on_choice/1
%%% do_on_choice(1).
%%% Runs the program in interactive mode and calls run again on completion.
do_on_choice(1) :- !,
	write('Δώσε τις παρακάτω πληροφορίες:'), nl,
	write('=============================='), nl,
	write('Ελάχιστο Εμβαδόν: '),
	read(Min_area),
	write('Ελάχιστος αριθμός υπνοδωματίων: '),
	read(Min_bedrooms),
	write('Να επιτρέπονται κατοικίδια; (yes/no) '),
	read(Needs_pet),
	write('Από ποιον όροφο και πάνω να υπάρχει ανελκυστήρας; '),
	read(Needs_elevator_above_floor),
	write('Ποιο είναι το μέγιστο ενοίκιο που μπορείς να πληρώσεις; '),
	read(Max_rent_cutoff),
	write('Πόσα θα έδινες για ένα διαμέρισμα στο κέντρο της πόλης (στα ελάχιστα τετραγωνικά); '),
	nl, read(Max_rent_for_city_center),
	write('Πόσα θα έδινες για ένα διαμέρισμα στα προάστια της πόλης (στα ελάχιστα τετραγωνικά); '),
	nl, read(Max_rent_for_suburbs),
	write('Πόσα θα έδινες για κάθε τετραγωνικό διαμερίσματος πάνω από το ελάχιστο; '),
	read(Max_rate_per_extra_area_unit),
	write('Πόσα θα έδινες για κάθε τετραγωνικό κήπου; '),
	read(Max_rate_per_yard_area_unit), nl,

	findall(Address, house(Address), Houses),
	compatible_houses(Min_area, Min_bedrooms, Needs_pet, Needs_elevator_above_floor, Max_rent_cutoff, Max_rent_for_city_center, Max_rent_for_suburbs, Max_rate_per_extra_area_unit, Max_rate_per_yard_area_unit, Houses, Compatible_houses),

	length(Compatible_houses, Compatible_houses_count),
	((Compatible_houses_count =:= 0, write('Δεν υπάρχει κατάλληλο σπίτι!'), nl);
	(write_houses(Compatible_houses),
	write('Προτείνεται η ενοικίαση του διαμερίσματος στην διεύθυνση: '),
	find_best_house(Compatible_houses, Best_house),
	write(Best_house), nl, nl)), !,
	run.

%%% do_on_choice/1
%%% do_on_choice(2).
%%% Runs the program in batch mode and calls run again on completion.
do_on_choice(2) :- !,
	findall(Customer_name, customer(Customer_name), Customers),
	findall(Address, house(Address), Houses),
	find_houses(Customers, Houses, Compatible_houses, Best_houses),
	write_batch_results(Customers, Compatible_houses, Best_houses), !,
	run.

%%% do_on_choice/1
%%% do_on_choice(3).
%%% Runs the program in auction mode and calls run again on completion.
do_on_choice(3) :- !,
	findall(Customer_name, customer(Customer_name), Customers),
	findall(Address, house(Address), Houses),
	find_houses(Customers, Houses, Compatible_houses, Best_houses),
	refine_houses(Customers, Houses, Compatible_houses, Best_houses, Final_best_houses),
	write_auction_final_houses(Customers, Final_best_houses), nl, !,
	run.

%%% do_on_choice/1
%%% do_on_choice(0).
%%% Predicate to exit the program when the user gives 0 as their choice.
do_on_choice(0) :- !.

%%% do_on_choice/1
%%% do_on_choice(Eof).
%%% Is activated when the given choice is not in the [0, 3] range.
%%% Succeeds if the given option is not EOF.
do_on_choice(Eof) :-
	write('Επίλεξε έναν αριθμό μεταξύ 0 έως 3!'), nl, nl,
	Eof \= end_of_file,
	run.

/*-------------------------------------------------------------------------------
  This is the start of the predicates you recommended us to use, minus
  find__cheaper, find_biggest_garden and find_biggest_house, since I
  didn't end up needing those predicates.
--------------------------------------------------------------------------------*/

%%% compatible_house/18
%%% compatible_house(Min_area, Min_bedrooms, Needs_pet, Needs_elevator_above_floor, Max_rent_cutoff, Max_rent_for_city_center, Max_rent_for_suburbs, Max_rate_per_extra_area_unit, Max_rate_per_yard_area_unit, Bedrooms, Area, In_city_center, Floor_number, Has_elevator, Allows_pets, Yard_area, Rent_amount, Address).
%%% Takes a customer's requirements and a house's characteristics as input.
%%% Succeeds if the house meets the customer's requirements.
compatible_house(Min_area, Min_bedrooms, Needs_pet, Needs_elevator_above_floor, Max_rent_cutoff, Max_rent_for_city_center, Max_rent_for_suburbs, Max_rate_per_extra_area_unit, Max_rate_per_yard_area_unit, Bedrooms, Area, In_city_center, Floor_number, Has_elevator, Allows_pets, Yard_area, Rent_amount, Address) :-
	house(Address),
	Min_area =< Area,
	Min_bedrooms =< Bedrooms,
	(Needs_pet == no; (Needs_pet == yes, Allows_pets =:= 1)),
	(Needs_elevator_above_floor > Floor_number; (Has_elevator =:= 1)),
	(In_city_center =:= 1, Max_rent_for_city_center + Max_rate_per_extra_area_unit * (Area - Min_area) + Max_rate_per_yard_area_unit * Yard_area >= Rent_amount;
	In_city_center =:= 0, Max_rent_for_suburbs + Max_rate_per_extra_area_unit * (Area - Min_area) + Max_rate_per_yard_area_unit * Yard_area >= Rent_amount),
	Max_rent_cutoff >= Rent_amount.

%%% compatible_houses/11
%%% compatible_houses(Min_area, Min_bedrooms, Needs_pet, Needs_elevator_above_floor, Max_rent_cutoff, Max_rent_for_city_center, Max_rent_for_suburbs, Max_rate_per_extra_area_unit, Max_rate_per_yard_area_unit, Houses, Compatible_houses).
%%% Takes a customer's requirements as input and the list of houses
%%% and returns a list of houses that fulfill the requirements.
compatible_houses(Min_area, Min_bedrooms, Needs_pet, Needs_elevator_above_floor, Max_rent_cutoff, Max_rent_for_city_center, Max_rent_for_suburbs, Max_rate_per_extra_area_unit, Max_rate_per_yard_area_unit, Houses, Compatible_houses) :-
	include(is_compatible(Min_area, Min_bedrooms, Needs_pet, Needs_elevator_above_floor, Max_rent_cutoff, Max_rent_for_city_center, Max_rent_for_suburbs, Max_rate_per_extra_area_unit, Max_rate_per_yard_area_unit), Houses, Compatible_houses).

%%% find_best_house/2
%%% find_best_house([Next_house|Compatible_houses], Best_house).
%%% Takes a list of houses as input and returns the best house based on
%%% the global user preferences.
find_best_house([Next_house|Compatible_houses], Best_house) :-
	find_best_house_rec(Compatible_houses, Next_house, Best_house).

%%% find_houses/4
%%% find_houses([Next_customer|Customers], Houses, Compatible_houses,
%%% Best_houses).
%%% Recursively takes a list of customers and a list of houses as inputs
%%% and returns a list of compatible houses for each customer and a list
%%% of the best house for each customer.
find_houses([Next_customer|Customers], Houses, Compatible_houses, Best_houses) :-
	min_area(Next_customer, Min_area),
	min_bedrooms(Next_customer, Min_bedrooms),
	needs_pet(Next_customer, Needs_pet_num),
	needs_elevator_above_floor(Next_customer, Needs_elevator_above_floor),
	max_rent_cutoff(Next_customer, Max_rent_cutoff),
	max_rent_for_city_center(Next_customer, Max_rent_for_city_center),
	max_rent_for_suburbs(Next_customer, Max_rent_for_suburbs),
	max_rate_per_extra_area_unit(Next_customer, Max_rate_per_extra_area_unit),
	max_rate_per_yard_area_unit(Next_customer, Max_rate_per_yard_area_unit),
	(Needs_pet_num =:= 1, Needs_pet = yes; Needs_pet_num =:= 0, Needs_pet = no),

	compatible_houses(Min_area, Min_bedrooms, Needs_pet, Needs_elevator_above_floor, Max_rent_cutoff, Max_rent_for_city_center, Max_rent_for_suburbs, Max_rate_per_extra_area_unit, Max_rate_per_yard_area_unit, Houses, Next_compatible_houses),
	length(Next_compatible_houses, Next_compatible_houses_count),
	(Next_compatible_houses_count < 1, Next_best_house = ""; find_best_house(Next_compatible_houses, Next_best_house)),
	find_houses(Customers, Houses, Temp_compatible_houses, Temp_best_houses),

	add_to_list(Next_compatible_houses, Temp_compatible_houses, Compatible_houses),
	add_to_list(Next_best_house, Temp_best_houses, Best_houses).

%%% find_houses/4
%%% find_houses([Next_customer|[]], Houses, Compatible_houses,
%%% Best_houses).
%%% Base case for the previous predicate with the same name.
find_houses([Next_customer|[]], Houses, Compatible_houses, Best_houses) :-
	min_area(Next_customer, Min_area),
	min_bedrooms(Next_customer, Min_bedrooms),
	needs_pet(Next_customer, Needs_pet_num),
	needs_elevator_above_floor(Next_customer, Needs_elevator_above_floor),
	max_rent_cutoff(Next_customer, Max_rent_cutoff),
	max_rent_for_city_center(Next_customer, Max_rent_for_city_center),
	max_rent_for_suburbs(Next_customer, Max_rent_for_suburbs),
	max_rate_per_extra_area_unit(Next_customer, Max_rate_per_extra_area_unit),
	max_rate_per_yard_area_unit(Next_customer, Max_rate_per_yard_area_unit),
	(Needs_pet_num =:= 1, Needs_pet = yes; Needs_pet_num =:= 0, Needs_pet = no),

	compatible_houses(Min_area, Min_bedrooms, Needs_pet, Needs_elevator_above_floor, Max_rent_cutoff, Max_rent_for_city_center, Max_rent_for_suburbs, Max_rate_per_extra_area_unit, Max_rate_per_yard_area_unit, Houses, Next_compatible_houses),
	length(Next_compatible_houses, Next_compatible_houses_count),
	(Next_compatible_houses_count < 1, Next_best_house = "None"; find_best_house(Next_compatible_houses, Next_best_house)),

	Compatible_houses = [Next_compatible_houses],
	Best_houses = [Next_best_house].

%%% find_bidders/4
%%% find_bidders(Customers, [Next_house|Other_houses], Best_houses, Claims).
%%% Recursively takes lists of customers, houses and best houses for each
%%% customer as input and outputs a list of customers who claim each house.
find_bidders(Customers, [Next_house|Other_houses], Best_houses, Claims) :-
	find_bidders_for_house(Customers, Next_house, Best_houses, Temp_bidders),
	find_bidders(Customers, Other_houses, Best_houses, Temp_claims),
	length(Temp_bidders, Temp_bidders_count),
	(Temp_bidders_count < 1, Claims = Temp_claims; add_to_list([Next_house|Temp_bidders], Temp_claims, Claims)).

%%% find_bidders/4
%%% find_bidders(Customers, [Next_house|[]], Best_houses, Claims).
%%% Base case for the previous predicate with the same name.
find_bidders(Customers, [Next_house|[]], Best_houses, Claims) :-
	find_bidders_for_house(Customers, Next_house, Best_houses, Temp_bidders),
	add_to_list([Next_house|Temp_bidders], [], Claims).

%%% find_best_bidders/2
%%% find_best_bidders([Next_claim|Other_claims], Best_bidders).
%%% Recursively takes a list of claims as input and returns a list of
%%% the best bidder (the customer's name) for each house.
find_best_bidders([Next_claim|Other_claims], Best_bidders) :-
	find_best_bidders(Other_claims, Temp_best_bidders),
	get_best_offer(Next_claim, Highest_bidder, _),
	[Next_house|_] = Next_claim,
	add_to_list([Next_house|Highest_bidder], Temp_best_bidders, Best_bidders).

%%% find_best_bidders/2
%%% find_best_bidders([Next_claim|[]], Best_bidders).
%%% Base case for the previous predicate with the same name.
find_best_bidders([Next_claim|[]], Best_bidders) :-
	get_best_offer(Next_claim, Highest_bidder, _),
	[Next_house|_] = Next_claim,
	add_to_list([Next_house|Highest_bidder], [], Best_bidders).

%%% remove_houses/4
%%% (Best_bidders, Compatible_houses, Updated_compatible_houses,
%%% Updated_best_houses).
%%% Takes lists of the best bidders for each house and the compatible
%%% houses for each customer and returns updated lists of the compatible
%%% houses and the best house for each customer.
remove_houses(Best_bidders, Compatible_houses, Updated_compatible_houses, Updated_best_houses) :-
	findall(Customer_name, customer(Customer_name), Customers),
	remove_bidded_houses(Customers, Best_bidders, Compatible_houses, Temp_updated_compatible_houses),
	remove_other_houses_from_winners(Customers, Best_bidders	, Temp_updated_compatible_houses, Updated_compatible_houses),
	update_best_houses(Customers, Updated_compatible_houses, Updated_best_houses).

%%% refine_houses/5
%%% refine_houses(Customers, Houses, Compatible_houses, Best_houses,
%%% Final_best_houses).
%%% Takes lists of the customers, the houses, the compatible houses and
%%% the best house for each customer and returns a list of the final
%%% best houses (i.e. the final bids of each of the customers).
refine_houses(Customers, Houses, Compatible_houses, Best_houses, Final_best_houses) :-
	find_bidders(Customers, Houses, Best_houses, Claims),
	find_best_bidders(Claims, Best_bidders),
	remove_houses(Best_bidders, Compatible_houses, Updated_compatible_houses, Updated_best_houses),

	are_valid_bids(Claims, Are_valid),
	((Are_valid =:= 1, Final_best_houses = Updated_best_houses) ;
	(Are_valid =:= 0, refine_houses(Customers, Houses, Updated_compatible_houses, Updated_best_houses, Temp_updated_best_houses),
	Final_best_houses = Temp_updated_best_houses)).

%%% offer/9
%%% offer(Min_area, Max_rent_for_city_center, Max_rent_for_suburbs,
%%% Max_rate_per_extra_area_unit, Max_rate_per_yard_area_unit, Area,
%%% Yard_area, In_city_center, Offer)
%%% Takes a list of rent related requirements of a customer and the rent
%%% related properties of a house and returns the highest rent amount
%%% the customer can offer for the house.
offer(Min_area, Max_rent_for_city_center, Max_rent_for_suburbs, Max_rate_per_extra_area_unit, Max_rate_per_yard_area_unit, Area, Yard_area, In_city_center, Offer) :-
	(In_city_center =:= 1, Offer = Max_rent_for_city_center + Max_rate_per_extra_area_unit * (Area - Min_area) + Max_rate_per_yard_area_unit * Yard_area;
	In_city_center =:= 0, Offer = Max_rent_for_suburbs + Max_rate_per_extra_area_unit * (Area - Min_area) + Max_rate_per_yard_area_unit * Yard_area).

/*-------------------------------------------------------------------------------
  This is the end of the predicates you recommended us to use.
--------------------------------------------------------------------------------*/

%%% is_compatible/10
%%% is_compatible(Min_area, Min_bedrooms, Needs_pet,
%%% Needs_elevator_above_floor, Max_rent_cutoff,
%%% Max_rent_for_city_center, Max_rent_for_suburbs,
%%% Max_rate_per_extra_area_unit, Max_rate_per_yard_area_unit, Address).
%%% Takes a list of a customer's requirements and the address of a house
%%% and succeeds if the house meets the customer's requirements. Uses
%%% the predicate compatible_house/18.
is_compatible(Min_area, Min_bedrooms, Needs_pet, Needs_elevator_above_floor, Max_rent_cutoff, Max_rent_for_city_center, Max_rent_for_suburbs, Max_rate_per_extra_area_unit, Max_rate_per_yard_area_unit, Address) :-
	bedrooms(Address, Bedrooms),
	area(Address, Area),
	in_city_center(Address, In_city_center),
	floor_number(Address, Floor_number),
	has_elevator(Address, Has_elevator),
	allows_pets(Address, Allows_pets),
	yard_area(Address, Yard_area),
	rent_amount(Address, Rent_amount),
	compatible_house(Min_area, Min_bedrooms, Needs_pet, Needs_elevator_above_floor, Max_rent_cutoff, Max_rent_for_city_center, Max_rent_for_suburbs, Max_rate_per_extra_area_unit, Max_rate_per_yard_area_unit, Bedrooms, Area, In_city_center, Floor_number, Has_elevator, Allows_pets, Yard_area, Rent_amount, Address).

%%% find_best_house_rec/3
%%% find_best_house_rec([Next_house|Compatible_houses], Prev_Best_House,
%%% Best_house).
%%% Recursively takes a list of compatible houses and the previous best
%%% house for a customer as input and returns the best house for that
%%% customer. This is where find_cheaper, find_biggest_garden and
%%% find_biggest_house would have been used, but I ended up using simple
%%% comparisons instead of exrta predicates.
find_best_house_rec([Next_house|Compatible_houses], Prev_Best_House, Best_house) :-
	rent_amount(Next_house, Next_house_rent),
	rent_amount(Prev_Best_House, Best_house_rent),
	yard_area(Next_house, Next_house_yard_area),
	yard_area(Prev_Best_House, Best_house_yard_area),
	area(Next_house, Next_house_area),
	area(Prev_Best_House, Best_house_area),
	(((Next_house_rent < Best_house_rent); (Next_house_rent =:= Best_house_rent, Next_house_yard_area > Best_house_yard_area); (Next_house_rent =:= Best_house_rent, Next_house_yard_area =:= Best_house_yard_area, Next_house_area > Best_house_area)),
	find_best_house_rec(Compatible_houses, Next_house, Best_house));
	(find_best_house_rec(Compatible_houses, Prev_Best_House, Best_house)).

%%% find_best_house_rec/3
%%% find_best_house_rec([], Prev_Best_House, Best_house).
%%% Base case for the previous predicate with the same name.
find_best_house_rec([], Prev_Best_House, Best_house) :- Best_house = Prev_Best_House.

%%% find_bidders_for_house/4
%%% find_bidders_for_house([Next_customer|Other_customers], House,
%%% [Next_best_house|Other_best_houses], Bidders).
%%% Recursively takes a list of customers, the address of a house and
%%% a list of the best house for each customer as input and returns a
%%% list of bidders for the specific house.
find_bidders_for_house([Next_customer|Other_customers], House, [Next_best_house|Other_best_houses], Bidders) :-
	find_bidders_for_house(Other_customers, House, Other_best_houses, Temp_bidders),
	((House == Next_best_house, add_to_list(Next_customer, Temp_bidders, Bidders)); (Bidders = Temp_bidders)).

%%% find_bidders_for_house/4
%%% find_bidders_for_house([Next_customer|[]], House,
%%% [Next_best_house|[]], Bidders).
%%% Base case for the previous predicate with the same name.
find_bidders_for_house([Next_customer|[]], House, [Next_best_house|[]], Bidders) :-
	((House == Next_best_house, add_to_list(Next_customer, [], Bidders)); (Bidders = [])).

%%% get_best_offer/3
%%% get_best_offer([House|[Next_bidder|Other_bidders]], Highest_bidder,
%%% Highest_bid).
%%% Recursively takes a list with the address of a house in the header
%%% and the names of the customers who have bid on the house in the tail
%%% as input and returns the name of the highest bidder and the amount
%%% of their bid.
get_best_offer([House|[Next_bidder|Other_bidders]], Highest_bidder, Highest_bid) :-
	get_best_offer([House|Other_bidders], Temp_highest_bidder, Temp_highest_bid),
	area(House, Area),
	in_city_center(House, In_city_center),
	yard_area(House, Yard_area),
	min_area(Next_bidder, Min_area),
	max_rent_for_city_center(Next_bidder, Max_rent_for_city_center),
	max_rent_for_suburbs(Next_bidder, Max_rent_for_suburbs),
	max_rate_per_extra_area_unit(Next_bidder, Max_rate_per_extra_area_unit),
	max_rate_per_yard_area_unit(Next_bidder, Max_rate_per_yard_area_unit),
	offer(Min_area, Max_rent_for_city_center, Max_rent_for_suburbs, Max_rate_per_extra_area_unit, Max_rate_per_yard_area_unit, Area, Yard_area, In_city_center, Offer),
	((Offer > Temp_highest_bid, Highest_bid = Offer, Highest_bidder = Next_bidder); (Highest_bid = Temp_highest_bid, Highest_bidder = Temp_highest_bidder)).

%%% get_best_offer/3
%%% get_best_offer([House|[Next_bidder|[]]], Highest_bidder,
%%% Highest_bid).
%%% Base case for the previous predicate with the same name.
get_best_offer([House|[Next_bidder|[]]], Highest_bidder, Highest_bid) :-
	area(House, Area),
	in_city_center(House, In_city_center),
	yard_area(House, Yard_area),
	min_area(Next_bidder, Min_area),
	max_rent_for_city_center(Next_bidder, Max_rent_for_city_center),
	max_rent_for_suburbs(Next_bidder, Max_rent_for_suburbs),
	max_rate_per_extra_area_unit(Next_bidder, Max_rate_per_extra_area_unit),
	max_rate_per_yard_area_unit(Next_bidder, Max_rate_per_yard_area_unit),
	offer(Min_area, Max_rent_for_city_center, Max_rent_for_suburbs, Max_rate_per_extra_area_unit, Max_rate_per_yard_area_unit, Area, Yard_area, In_city_center, Offer),
	Highest_bid = Offer,
	Highest_bidder = Next_bidder.

%%% remove_bidded_houses/4
%%% remove_bidded_houses(Customers,
%%% [Next_best_bidder|Other_best_bidders], Compatible_houses,
%%% Updated_compatible_houses).
%%% Recursively takes lists of customers, the best bidders for each
%%% house and the compatible houses for each customer as input and
%%% returns the list of compatible houses for each customer after
%%% removing the houses that have already gotten their best possible bid
%%% from the compatible houses of the losers of the bidding.
remove_bidded_houses(Customers, [Next_best_bidder|Other_best_bidders], Compatible_houses, Updated_compatible_houses) :-
	remove_bidded_houses(Customers, Other_best_bidders, Compatible_houses, Temp_updated_compatible_houses),
	remove_bidded_house(Next_best_bidder, Customers, Temp_updated_compatible_houses, Updated_compatible_houses).

%%% remove_bidded_houses/4
%%% remove_bidded_houses(Customers, [Next_best_bidder|[]],
%%% Compatible_houses, Updated_compatible_houses).
%%% Base case for the previous predicate with the same name.
remove_bidded_houses(Customers, [Next_best_bidder|[]], Compatible_houses, Updated_compatible_houses) :-
	remove_bidded_house(Next_best_bidder, Customers, Compatible_houses, Updated_compatible_houses).

%%% remove_bidded_house/4
%%% remove_bidded_house(Bid, [Next_customer|Other_customers],
%%% [Next_compatible_houses|Other_compatible_houses],
%%% Updated_compatible_houses).
%%% Recursively takes a bid, lists of customers and compatible houses as
%%% input and removes the house that is included in the bid from the
%%% compatible houses of the customers that lost the bidding on the
%%% house. Returns the updated list of compatible houses.
remove_bidded_house(Bid, [Next_customer|Other_customers], [Next_compatible_houses|Other_compatible_houses], Updated_compatible_houses) :-
	remove_bidded_house(Bid, Other_customers, Other_compatible_houses, Temp_updated_compatible_houses),
	[House|Bidder] = Bid,
	((Bidder == Next_customer, add_to_list(Next_compatible_houses, Temp_updated_compatible_houses, Updated_compatible_houses));
	(exclude(=(House), Next_compatible_houses, New_compatible_houses),
	add_to_list(New_compatible_houses, Temp_updated_compatible_houses, Updated_compatible_houses))).

%%% remove_bidded_house/4
%%% remove_bidded_house(Bid, [Next_customer|[]],
%%% [Next_compatible_houses|[]], Updated_compatible_houses).
%%% Base case for the previous predicate with the same name.
remove_bidded_house(Bid, [Next_customer|[]], [Next_compatible_houses|[]], Updated_compatible_houses) :-
	[House|Bidder] = Bid,
	((Bidder == Next_customer, add_to_list(Next_compatible_houses, [], Updated_compatible_houses));
	(exclude(=(House), Next_compatible_houses, New_compatible_houses),
	add_to_list(New_compatible_houses, [], Updated_compatible_houses))).

%%% remove_other_houses_from_winners/4
%%% remove_other_houses_from_winners(Customers,
%%% [Next_best_bidder|Other_best_bidders], Compatible_houses,
%%% Updated_compatible_houses).
%%% Recursively takes lists of customers, best bids and compatible
%%% houses as input and removes every compatible house from the winners
%%% of the bidding, other than the one house they won. Returns the
%%% updated list of compatible houses.
remove_other_houses_from_winners(Customers, [Next_best_bidder|Other_best_bidders], Compatible_houses, Updated_compatible_houses) :-
	remove_other_houses_from_winners(Customers, Other_best_bidders, Compatible_houses, Temp_updated_compatible_houses),
	remove_other_houses_from_winner(Next_best_bidder, Customers, Temp_updated_compatible_houses, Updated_compatible_houses).

%%% remove_other_houses_from_winners/4
%%% remove_other_houses_from_winners(Customers, [Next_best_bidder|[]],
%%% Compatible_houses, Updated_compatible_houses).
%%% Base case for the previous predicate with the same name.
remove_other_houses_from_winners(Customers, [Next_best_bidder|[]], Compatible_houses, Updated_compatible_houses) :-
	remove_other_houses_from_winner(Next_best_bidder, Customers, Compatible_houses, Updated_compatible_houses).

%%% remove_other_houses_from_winner/4
%%% remove_other_houses_from_winner(Bid,
%%% [Next_customer|Other_customers],
%%% [Next_compatible_houses|Other_compatible_houses],
%%% Updated_compatible_houses).
%%% Recursively takes a bid, lists of customers and compatible houses as
%%% input and only includes the house the customer won the bidding on in
%%% their list of compatible houses, while removing any other listed
%%% houses. Returns the updated list of compatible houses of the
%%% customer included in the bid.
remove_other_houses_from_winner(Bid, [Next_customer|Other_customers], [Next_compatible_houses|Other_compatible_houses], Updated_compatible_houses) :-
	remove_other_houses_from_winner(Bid, Other_customers, Other_compatible_houses, Temp_updated_compatible_houses),
	[House|Bidder] = Bid,
	((Bidder == Next_customer, include(=(House), Next_compatible_houses, New_compatible_houses),
	add_to_list(New_compatible_houses, Temp_updated_compatible_houses, Updated_compatible_houses));
	(add_to_list(Next_compatible_houses, Temp_updated_compatible_houses, Updated_compatible_houses))).

%%% remove_other_houses_from_winner/4
%%% remove_other_houses_from_winner(Bid, [Next_customer|[]],
%%% [Next_compatible_houses|[]], Updated_compatible_houses).
%%% Base case for the previous predicate with the same name.
remove_other_houses_from_winner(Bid, [Next_customer|[]], [Next_compatible_houses|[]], Updated_compatible_houses) :-
	[House|Bidder] = Bid,
	((Bidder == Next_customer, include(=(House), Next_compatible_houses, New_compatible_houses),
	add_to_list(New_compatible_houses, [], Updated_compatible_houses));
	(add_to_list(Next_compatible_houses, [], Updated_compatible_houses))).

%%% update_best_houses/3
%%% update_best_houses([_|Other_customers],
%%% [Next_compatible_houses|Other_compatible_houses],
%%% Updated_best_houses).
%%% Recursively takes lists of customers and compatible houses as input
%%% and returns a list of the best house for each customer.
update_best_houses([_|Other_customers], [Next_compatible_houses|Other_compatible_houses], Updated_best_houses) :-
	update_best_houses(Other_customers, Other_compatible_houses, Temp_updated_best_houses),
	length(Next_compatible_houses, Next_compatible_houses_count),
	(Next_compatible_houses_count < 1, Next_best_house = "None"; find_best_house(Next_compatible_houses, Next_best_house)),
	add_to_list(Next_best_house, Temp_updated_best_houses, Updated_best_houses).

%%% update_best_houses/3
%%% update_best_houses([_|[]], [Next_compatible_houses|[]],
%%% Updated_best_houses).
%%% Base case for the previous predicate with the same name.
update_best_houses([_|[]], [Next_compatible_houses|[]], Updated_best_houses) :-
	length(Next_compatible_houses, Next_compatible_houses_count),
	(Next_compatible_houses_count < 1, Next_best_house = "None"; find_best_house(Next_compatible_houses, Next_best_house)),
	add_to_list(Next_best_house, [], Updated_best_houses).

%%% are_valid_bids/2
%%% are_valid_bids([Next_claim|Other_claims], Are_valid).
%%% Recursively takes a list of claims as input and returns 1 if for
%%% every house there a max of one claim, else returns 0.
are_valid_bids([Next_claim|Other_claims], Are_valid) :-
	are_valid_bids(Other_claims, Temp_are_valid),
	length(Next_claim, Next_claim_length),
	((Temp_are_valid =:= 1, Next_claim_length =:= 2, Are_valid = 1); (Are_valid = 0)).

%%% are_valid_bids/2
%%% are_valid_bids([Next_claim|[]], Are_valid).
%%% Base case for the previous predicate with the same name.
are_valid_bids([Next_claim|[]], Are_valid) :-
	length(Next_claim, Next_claim_length),
	((Next_claim_length =:= 2, Are_valid = 1); (Are_valid = 0)).

%%% add_to_list/3
%%% add_to_list(Item, List, [Item|List]).
%%% Takes an item and a list as input and returns a new list whose head
%%% is the given item and its tail is the given list. Essentially
%%% appends the given item to the start of the given list.
add_to_list(Item, List, [Item|List]).

%%% write_house/8
%%% write_house(Address, Bedrooms, Area, In_city_center, Floor_number,
%%% Has_elevator, Allows_pets, Yard_area, Rent_amount).
%%% Takes the characteristics of a house as input and writes a formatted
%%% message of the house's characteristics.
write_house(Address, Bedrooms, Area, In_city_center, Floor_number, Has_elevator, Allows_pets, Yard_area, Rent_amount) :-
	write('Κατάλληλο σπίτι στην διεύθυνση: '), write(Address), nl,
	write('Υπνοδωμάτια: '), write(Bedrooms), nl,
	write('Εμβαδόν: '), write(Area), nl,
	write('Εμβαδόν κήπου: '), write(Yard_area), nl,
	write('Είναι στο κέντρο της πόλης: '), (In_city_center =:= 1, write('yes'); In_city_center =:= 0, write('no')), nl,
	write('Επιτρέπονται κατοικίδια: '), (Allows_pets =:= 1, write('yes'); Allows_pets =:= 0, write('no')), nl,
	write('Όροφος: '), write(Floor_number), nl,
	write('Ανελκυστήρας: '), (Has_elevator =:= 1, write('yes'); Has_elevator =:= 0, write('no')), nl,
	write('Ενοίκιο: '), write(Rent_amount), nl, nl.

%%% write_houses/1
%%% write_houses([Next_house|Other_houses]).
%%% Recursively takes a list of houses as input and writes a formatted
%%% message of each of the house's characteristics for all the houses
%%% in the list.
write_houses([Next_house|Other_houses]) :-
	address(Next_house, Address),
	bedrooms(Next_house, Bedrooms),
	area(Next_house, Area),
	in_city_center(Next_house, In_city_center),
	floor_number(Next_house, Floor_number),
	has_elevator(Next_house, Has_elevator),
	allows_pets(Next_house, Allows_pets),
	yard_area(Next_house, Yard_area),
	rent_amount(Next_house, Rent_amount),
	write_house(Address, Bedrooms, Area, In_city_center, Floor_number, Has_elevator, Allows_pets, Yard_area, Rent_amount),
	write_houses(Other_houses).

%%% write_houses/1
%%% write_houses([]).
%%% Base case for the previous predicate with the same name.
write_houses([]).

%%% write_batch_results/3
%%% write_batch_results([Next_customer|Other_customers],
%%% [Next_compatible_houses|Other_compatible_houses],
%%% [Next_best_house|Other_best_houses]).
%%% Recursively takes lists of customers, their compatible houses and
%%% their best house and writes formatted messages of each of the
%%% compatible houses' characteristics for each customer as well as
%%% a formatted message for each customer's best house. Is used to write
%%% the batch mode output.
write_batch_results([Next_customer|Other_customers], [Next_compatible_houses|Other_compatible_houses], [Next_best_house|Other_best_houses]) :-
	write_batch_customer_houses(Next_customer, Next_compatible_houses, Next_best_house),
	write_batch_results(Other_customers, Other_compatible_houses, Other_best_houses).

%%% write_batch_results/3
%%% write_batch_results([], [], []).
%%% Base case for the previous predicate with the same name.
write_batch_results([], [], []).

%%% write_batch_customer_houses/3
%%% write_batch_customer_houses(Customer_name, Compatible_houses,
%%% Best_house).
%%% Takes a customer's name, a list of their compatible houses and their
%%% best house as input and writes formatted messages of each of the
%%% compatible houses' characteristics as well as a formatted message
%%% for the customer's best house.
write_batch_customer_houses(Customer_name, Compatible_houses, Best_house) :-
	write('Κατάλληλα διαμερίσματα για τον πελάτη: '), write(Customer_name), write(':'), nl,
	write('======================================='), nl,
	length(Compatible_houses, Compatible_houses_count),
	((Compatible_houses_count =:= 0, write('Δεν υπάρχει κατάλληλο σπίτι!'), nl, nl);
	(write_houses(Compatible_houses),
	write('Προτείνεται η ενοικίαση του διαμερίσματος στην διεύθυνση: '),
	write(Best_house), nl, nl, nl)).

%%% write_auction_final_houses\2
%%% write_auction_final_houses([Next_customer|Other_customers],
%%% [Next_final_best_house|Other_final_best_houses]).
%%% Recusrively takes lists of the customers and their final best houses
%%% as input and writes a formatted message which says which apartment
%%% the customer will rent. Is used to write the auction mode output.
write_auction_final_houses([Next_customer|Other_customers], [Next_final_best_house|Other_final_best_houses]) :-
	((Next_final_best_house == "None", write('Ο πελάτης '), write(Next_customer), write(' δεν θα νοικιάσει κάποιο διαμέρισμα!'), nl);
	(write('Ο πελάτης '), write(Next_customer), write(' θα νοικιάσει το διαμέρισμα στη διεύθυνση: '), write(Next_final_best_house), nl)),
	write_auction_final_houses(Other_customers, Other_final_best_houses).

%%% write_auction_final_houses\2
%%% write_auction_final_houses([], []).
%%% Base case for the previous predicate with the same name.
write_auction_final_houses([], []).
