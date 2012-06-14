%% @author author <author@example.com>
%% @copyright YYYY author.
%% @doc Example webmachine_resource.

-module(gwebdev_resource).
-export([init/1, to_html/2]).

-include_lib("webmachine/include/webmachine.hrl").

init(State) -> {ok, State}.

to_html(ReqData, State) ->
    Template = proplists:get_value(template, State, base_dtl),
    {ok, Content} = Template:render([{param, get_param(State)}]),
    {Content, ReqData, State}.

%% Support Functions

get_param(State) ->
    From = proplists:get_value(from, State, "Jeff"),
    case proplists:get_value(root, State) of
      undefined -> {Dirs, Files} = {[], []};
      Dir -> {Dirs, Files} = split_dir_files(Dir)
    end,
    [{root, proplists:get_value(root, State)}, {dirs, Dirs}, {files, Files}, {from, From}].

split_dir_files(Dir) ->
    {ok, Files} = file:list_dir(Dir),
    split_dir_files(Dir, Files, [], []).

split_dir_files(_Dir, [], D, F) ->
    {D, F};

split_dir_files(Dir, [H|T], D, F) ->
    case filelib:is_regular(filename:join([Dir,H])) of
        true -> F1 = [H|F], D1 = D;
        false -> D1 = [H|D], F1 = F
    end,
    split_dir_files(Dir, T, D1, F1).
