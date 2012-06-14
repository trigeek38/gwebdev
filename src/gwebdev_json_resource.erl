%% @author author <author@example.com>
%% @copyright YYYY author.
%% @doc Example webmachine_resource.

-module(gwebdev_json_resource).
-export([init/1, content_types_provided/2, to_html/2, to_json/2]).

-include_lib("webmachine/include/webmachine.hrl").

init(State) -> {ok, State}.

content_types_provided(ReqData, Context) ->
   {[{"text/html", to_html}, {"application/json",to_json}], ReqData, Context}.

to_html(ReqData, State) ->
    Content = "<html><body><h1>Sorry</h1></body></html>",
    {Content, ReqData, State}.

to_json(ReqData, State) ->
    RD = wrq:set_resp_header("Content-Type", "application/json", ReqData),
    Params = get_param(State),
%    Params = [{<<"data">>, <<"Jeff">>},{<<"name">>, <<"Bell">>}, {<<"age">>, <<34>>}],
    Content = mochijson2:encode({struct, Params}),
    {Content, RD, State}.

get_param(State) ->
    case proplists:get_value(root, State) of
      undefined -> {Dirs, Files} = {[], []};
      Dir -> {Dirs, Files} = split_dir_files(Dir)
    end,
    [{<<"dirs">>, Dirs}, {<<"files">>, Files}].

split_dir_files(Dir) ->
    {ok, Files} = file:list_dir(Dir),
    split_dir_files(Dir, Files, [], []).

split_dir_files(_Dir, [], D, F) ->
    D1 = [list_to_binary(ND) || ND <- D],
    F1 = [list_to_binary(NF) || NF <- F],
    {D1, F1};

split_dir_files(Dir, [H|T], D, F) ->
    case filelib:is_regular(filename:join([Dir,H])) of
        true -> F1 = [H|F], D1 = D;
        false -> D1 = [H|D], F1 = F
    end,
    split_dir_files(Dir, T, D1, F1).
