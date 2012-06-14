%% @author author <author@example.com>
%% @copyright YYYY author.
%% @doc Example webmachine_resource.

-module(gwebdev_resource).
-export([init/1, to_html/2]).

-include_lib("webmachine/include/webmachine.hrl").

init(State) -> {ok, State}.

to_html(ReqData, State) ->
    From = proplists:get_value(from, State, "Jeff"),
    {ok, Content} = base_dtl:render([{param, From}]),
    {Content, ReqData, State}.
