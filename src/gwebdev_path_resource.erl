%% @author author <author@example.com>
%% @copyright YYYY author.
%% @doc Example webmachine_resource.

-module(gwebdev_path_resource).
-export([init/1, to_html/2]).

-include_lib("webmachine/include/webmachine.hrl").

init(State) -> {ok, State}.

to_html(ReqData, State) ->
    Template = proplists:get_value(template, State, base_dtl),
    {ok, Content} = Template:render(get_param(ReqData)),
    {Content, ReqData, State}.

%% Support Functions

get_param(ReqData) ->
    Path = wrq:path(ReqData),
    DispPath = wrq:disp_path(ReqData),
    PathInfo = dict:to_list(wrq:path_info(ReqData)),
    Tokens = wrq:path_tokens(ReqData),
    QS = wrq:get_qs_value("name", ReqData),
    [{path, Path}, {disp_path, DispPath}, {path_info, PathInfo}, {tokens, Tokens}, {qs, QS}].
