-module(main_handler).
-behavior(cowboy_handler).

-export([init/2, recurse/3, info/3]).

init(Req, State) ->
	Req2 = cowboy_req:stream_reply(200, #{<<"content-type">> => <<"text/html">>}, Req),
	recurse({["C:/Users/mustafa/Desktop/cowboy_load_html_partially/src"],"hi.html"}, Req2, State),
	{cowboy_loop, Req2, State}.

info(eof, Req, State) ->
	cowboy_req:stream_body("", fin, Req),
    {stop, Req, State};
info({event, Data}, Req, State) ->
	case file:read(Data, 30) of
    {ok, C} -> timer:sleep(100),
	cowboy_req:stream_body(C, nofin, Req),
	info({event, Data}, Req, State);
	_ -> info(eof, Req, State), 
		file:close(Data)
	end,
    {ok, Req, State};
info(_Msg, Req, State) ->
    {ok, Req, State}.

recurse(A, Req, State) ->
	case file:path_open(element(1, A), element(2, A), [read]) of
		{ok, B, _C} -> info({event, B}, Req, State);
		_ -> "nothing"
	end.