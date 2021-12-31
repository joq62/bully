%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description :  1
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(test).   
   
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
%-include_lib("eunit/include/eunit.hrl").
%% --------------------------------------------------------------------

%% External exports
-export([start/0]). 


%% ====================================================================
%% External functions
%% ====================================================================


%% --------------------------------------------------------------------
%% Function:tes cases
%% Description: List of test cases 
%% Returns: non
%% --------------------------------------------------------------------
start()->
    io:format("~p~n",[{"Start setup",?MODULE,?FUNCTION_NAME,?LINE}]),
    ok=setup(),
    io:format("~p~n",[{"Stop setup",?MODULE,?FUNCTION_NAME,?LINE}]),

    io:format("~p~n",[{"Start election_test()",?MODULE,?FUNCTION_NAME,?LINE}]),
    ok=election_test:start(),
    io:format("~p~n",[{"Stop election_test()",?MODULE,?FUNCTION_NAME,?LINE}]),

%    io:format("~p~n",[{"Start pass1()",?MODULE,?FUNCTION_NAME,?LINE}]),
%    ok=pass1(),
%    io:format("~p~n",[{"Stop pass1()",?MODULE,?FUNCTION_NAME,?LINE}]),

   
   
      %% End application tests
    io:format("~p~n",[{"Start cleanup",?MODULE,?FUNCTION_NAME,?LINE}]),
    ok=cleanup(),
    io:format("~p~n",[{"Stop cleaup",?MODULE,?FUNCTION_NAME,?LINE}]),
   
    io:format("------>"++atom_to_list(?MODULE)++" ENDED SUCCESSFUL ---------"),
    ok.


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------

setup()->
    HostId=net_adm:localhost(),
    U1=integer_to_list(erlang:system_time(microsecond)),
    timer:sleep(3),
    U2=integer_to_list(erlang:system_time(microsecond)),
    timer:sleep(3),
    U3=integer_to_list(erlang:system_time(microsecond)),
 
    NodeA=list_to_atom(U1++"@"++HostId),
    NodeB=list_to_atom(U2++"@"++HostId),
    NodeC=list_to_atom(U3++"@"++HostId),    
    Nodes=[NodeA,NodeB,NodeC],
    [rpc:call(Node,init,stop,[])||Node<-Nodes],
    Cookie=atom_to_list(erlang:get_cookie()),
    Args="-pa ebin -setcookie "++Cookie,
    [{ok,NodeA},
     {ok,NodeB},
     {ok,NodeC}]=[slave:start(HostId,NodeName,Args)||NodeName<-[U1,U2,U3]],
    [net_adm:ping(N)||N<-Nodes],
    ok=application:start(sd),
       
    ok.


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------    

cleanup()->
  
  %  application:stop(etcd),
  %  init:stop(),
    ok.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
