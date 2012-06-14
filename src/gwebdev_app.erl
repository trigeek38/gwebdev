%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc Callbacks for the gwebdev application.

-module(gwebdev_app).
-author('author <author@example.com>').

-behaviour(application).
-export([start/2,stop/1]).


%% @spec start(_Type, _StartArgs) -> ServerRet
%% @doc application start callback for gwebdev.
start(_Type, _StartArgs) ->
    gwebdev_sup:start_link().

%% @spec stop(_State) -> ServerRet
%% @doc application stop callback for gwebdev.
stop(_State) ->
    ok.
