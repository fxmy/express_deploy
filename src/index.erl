-module(index).
-compile(export_all).
-include_lib("nitro/include/nitro.hrl").
-include_lib("n2o/include/wf.hrl").

main() ->
  #dtl{file="index",
       app=express_deploy,
       bindings=[{title, title()},
                 {ed_ip, ed_ip()},
                 {ed_username, ed_username()},
                 {ed_password, ed_password()},
                 {javascript, (?MODULE:(wf:config(n2o,mode,dev)))()}
                ]
      }.

prod() ->   [ #script{src="/static/express_deploy.min.js"} ].
dev()  -> [ [ #script{src=lists:concat(["/n2o/protocols/",X,".js"])} || X <- [bert,nitrogen] ],
            [ #script{src=lists:concat(["/n2o/",Y,".js"])}           || Y <- [bullet,n2o,ftp,utf8,validation] ] ].

title() ->
    "233333333".

ed_ip() ->
  <<"吃特啊"/utf8>>.

ed_username() ->
  <<"吃特啊"/utf8>>.

ed_password() ->
  <<"吃特啊"/utf8>>.

event(Event) ->
  wf:info(?MODULE,"Event: ~p", [Event]),
  ok.
