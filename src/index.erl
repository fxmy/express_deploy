-module(index).
-compile(export_all).
-include_lib("nitro/include/nitro.hrl").
-include_lib("n2o/include/wf.hrl").

main() ->
  {{A, B, C, D}, _Port} = wf:peer(?REQ),
  Ip = integer_to_list(A) ++ "." ++
       integer_to_list(B) ++ "." ++
       integer_to_list(C) ++ "." ++
       integer_to_list(D),
  {User, Pass} = case express_deploy_db:get_by_ip(Ip) of
                   notfound ->
                     {<<"未找到，请联系管理员"/utf8>>, <<"未找到，请联系管理员"/utf8>>};
                   {U, P} ->
                     {U, P}
                 end,
  #dtl{file="index",
       app=express_deploy,
       bindings=[{title, title()},
                 {ed_ip, ed_ip(Ip)},
                 {ed_username, ed_username(User)},
                 {ed_password, ed_password(Pass)},
                 {javascript, (?MODULE:(wf:config(n2o,mode,dev)))()}
                ]
      }.

prod() ->   [ #script{src="/static/express_deploy.min.js"} ].
dev()  -> [ [ #script{src=lists:concat(["/n2o/protocols/",X,".js"])} || X <- [bert,nitrogen] ],
            [ #script{src=lists:concat(["/n2o/",Y,".js"])}           || Y <- [bullet,n2o,ftp,utf8,validation] ] ].

title() ->
  wf:config(express_deploy, index_title, "2333").

ed_ip(Ip) ->
  wf:to_binary([<<"您的IP地址:"/utf8>>, Ip]).

ed_username(UserName) ->
  wf:to_binary([<<"您的用户名:"/utf8>>,
                UserName]).

ed_password(Password) ->
  wf:to_binary([<<"您的密码:"/utf8>>,
                Password]).

event(Event) ->
  wf:info(?MODULE,"Event: ~p", [Event]),
  ok.
