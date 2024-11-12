-module(sevalla_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
	Dispatch = cowboy_router:compile([
		{'_', [{"/hi", main_handler, []}]}
		]),

	{ok, _A} = cowboy:start_clear(my_http_listner,
		[{port, 8080}],
		#{env => #{dispatch => Dispatch}}),
	cowboy_load_html_partially_sup:start_link().

stop(_State) ->
	ok.
