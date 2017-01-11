%%%-------------------------------------------------------------------
%% @doc express_deploy top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(express_deploy_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    {ok, { {one_for_all, 0, 1}, [children()]} }.

%%====================================================================
%% Internal functions
%%====================================================================
-spec children() -> supervisor:child_spec().
children() -> ranch:child_spec(http, 100, ranch_tcp, port(), cowboy_protocol, env()).

port() ->
  [{port, wf:config(n2o,port,8000)}].

env() ->
  [{env, [{dispatch, points()}]}].

points() ->
  cowboy_router:compile([{'_', [
                                {"/static/[...]", n2o_static, static()},
                                {"/n2o/[...]", n2o_static, n2o()},
                                {"/multipart/[...]", n2o_multipart, []},
                                % {"/rest/:resource", rest_cowboy, []},
                                % {"/rest/:resource/:id", rest_cowboy, []},
                                {"/ws/[...]", n2o_stream, []},
                                {'_', n2o_cowboy, []}
                               ]
                         }
                        ]).

static() ->
  {dir, "priv/static", mime()}.

n2o() ->
  {dir, "lib/n2o/priv", mime()}.

mime() ->
  [{mimetypes, cow_mimetypes, all}].
