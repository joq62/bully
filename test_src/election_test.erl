%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description :  1
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(election_test).   
    
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

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
  %  io:format("~p~n",[{"Start setup",?MODULE,?FUNCTION_NAME,?LINE}]),
    ok=setup(),
  %  io:format("~p~n",[{"Stop setup",?MODULE,?FUNCTION_NAME,?LINE}]),

%    io:format("~p~n",[{"Start cluster_start()",?MODULE,?FUNCTION_NAME,?LINE}]),
    ok=cluster_start(),
    io:format("~p~n",[{"Stop cluster_starto()",?MODULE,?FUNCTION_NAME,?LINE}]),


%   io:format("~p~n",[{"Start killnode()",?MODULE,?FUNCTION_NAME,?LINE}]),
    ok=killnode(),
    io:format("~p~n",[{"Stop killnode()",?MODULE,?FUNCTION_NAME,?LINE}]),


%   io:format("~p~n",[{"Start addnodes()",?MODULE,?FUNCTION_NAME,?LINE}]),
    ok=addnodes(),
    io:format("~p~n",[{"Stop addnodes()",?MODULE,?FUNCTION_NAME,?LINE}]),




 %   
      %% End application tests
  %  io:format("~p~n",[{"Start cleanup",?MODULE,?FUNCTION_NAME,?LINE}]),
    ok=cleanup(),
  %  io:format("~p~n",[{"Stop cleaup",?MODULE,?FUNCTION_NAME,?LINE}]),
   
    io:format("------>"++atom_to_list(?MODULE)++" ENDED SUCCESSFUL ---------"),
    ok.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
addnodes()->
    Nodes=nodes(),
    [N2,N3]=Nodes,
    io:format("N2,N3 ~p~n",[{N2,N3,?MODULE,?FUNCTION_NAME,?LINE}]),
    Leader=rpc:call(N2,bully,who_is_leader,[],5*1000),
    io:format("Leader   ~p~n",[{Leader,?MODULE,?FUNCTION_NAME,?LINE}]),
    
    %Add newer node
    HostId=net_adm:localhost(),
    U4=integer_to_list(erlang:system_time(microsecond)),
    N4=list_to_atom(U4++"@"++HostId),
    Cookie=atom_to_list(erlang:get_cookie()),
    Args="-pa ebin -setcookie "++Cookie,
    
    {ok,N4}=slave:start(HostId,U4,Args),
    [net_adm:ping(N)||N<-nodes()],
    ok=rpc:call(N4,application,start,[sd],5*1000),
    ok=rpc:call(N4,application,start,[bully],5*1000),
    timer:sleep(1000),
    [N2,N3,N4]=nodes(),
    Leader=rpc:call(N4,bully,who_is_leader,[],5*1000),

    %Add old node so it becomes leader
    U5=integer_to_list(erlang:system_time(microsecond)-10*10000000),
    N5=list_to_atom(U5++"@"++HostId),
    Cookie=atom_to_list(erlang:get_cookie()),
    Args="-pa ebin -setcookie "++Cookie,
    
    {ok,N5}=slave:start(HostId,U5,Args),
    [net_adm:ping(N)||N<-nodes()],
    ok=rpc:call(N5,application,start,[sd],5*1000),
    ok=rpc:call(N5,application,start,[bully],5*1000),
    timer:sleep(1000),
    [N2,N3,N4,N5]=nodes(),
    N5=rpc:call(N5,bully,who_is_leader,[],5*1000),
    N5=rpc:call(N2,bully,who_is_leader,[],5*1000),
    N5=rpc:call(N3,bully,who_is_leader,[],5*1000),
    N5=rpc:call(N4,bully,who_is_leader,[],5*1000),

    ok.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------



killnode()->
    Nodes=nodes(),
    [N1,N2,N3]=Nodes,
  %  io:format("N1,N2,N3 ~p~n",[{N1,N2,N3,?MODULE,?FUNCTION_NAME,?LINE}]),
    Leader=rpc:call(N1,bully,who_is_leader,[],5*1000),
    
    io:format("Leader   ~p~n",[{Leader,?MODULE,?FUNCTION_NAME,?LINE}]),
    %Kill leader
    rpc:call(Leader,init,stop,[],1000),
    timer:sleep(2000),
    NewLeader=rpc:call(N3,bully,who_is_leader,[],5*1000),
    false=Leader=:=NewLeader,
    io:format("NewLeader   ~p~n",[{NewLeader,?MODULE,?FUNCTION_NAME,?LINE}]),
    ok.    


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
cluster_start()->

 %   io:format("get_nodes()~p~n",[{lib_bully:get_nodes(),
%				 ?MODULE,?FUNCTION_NAME,?LINE}]),
    Nodes=nodes(),
    [N1,N2,N3]=Nodes,
    io:format("N1,N2,N3 ~p~n",[{N1,N2,N3,?MODULE,?FUNCTION_NAME,?LINE}]),
    % Start first node
    ok=rpc:call(N1,application,start,[sd],5*1000),
%    io:format("N1 get_nodes()~p~n",[{rpc:call(N1,lib_bully,get_nodes,[],1000),
%				     ?MODULE,?FUNCTION_NAME,?LINE}]),
    ok=rpc:call(N1,application,start,[bully],5*1000),
    timer:sleep(1000),
%    io:format("N1 get_nodes()~p~n",[{lib_bully:get_nodes(),
%				 ?MODULE,?FUNCTION_NAME,?LINE}]),

    N1=rpc:call(N1,bully,who_is_leader,[],5*1000),
    io:format("N1 leader ~p~n",[{rpc:call(N1,bully,who_is_leader,[],5*1000),
				 ?MODULE,?FUNCTION_NAME,?LINE}]),
    % Start second node
    ok=rpc:call(N2,application,start,[sd],5*1000),
 %   io:format("N2 get_nodes()~p~n",[{rpc:call(N2,lib_bully,get_nodes,[],1000),
%				   ?MODULE,?FUNCTION_NAME,?LINE}]),
    ok=rpc:call(N2,application,start,[bully],5*1000),
    timer:sleep(1000),
 %   io:format("N1,N2 get_nodes()~p~n",[{lib_bully:get_nodes(),
%				     ?MODULE,?FUNCTION_NAME,?LINE}]),
    io:format("N1 leader ~p~n",[{rpc:call(N1,bully,who_is_leader,[],5*1000),
				 ?MODULE,?FUNCTION_NAME,?LINE}]),
    N1=rpc:call(N1,bully,who_is_leader,[],5*1000),
    N1=rpc:call(N2,bully,who_is_leader,[],5*1000),
    
  % Start third node
    ok=rpc:call(N3,application,start,[sd],5*1000),
 %   io:format("N3 get_nodes()~p~n",[{rpc:call(N3,lib_bully,get_nodes,[],1000),
%				     ?MODULE,?FUNCTION_NAME,?LINE}]),
    ok=rpc:call(N3,application,start,[bully],5*1000),
    timer:sleep(1000),
    io:format("N1,N2,N3 get_nodes()~p~n",[{lib_bully:get_nodes(),
					?MODULE,?FUNCTION_NAME,?LINE}]),
    io:format("N1 leader ~p~n",[{rpc:call(N1,bully,who_is_leader,[],5*1000),
				 ?MODULE,?FUNCTION_NAME,?LINE}]),
    N1=rpc:call(N1,bully,who_is_leader,[],5*1000),
    N1=rpc:call(N2,bully,who_is_leader,[],5*1000),
    N1=rpc:call(N3,bully,who_is_leader,[],5*1000),

    
    
    ok.
    
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------


setup()->
  
    ok.


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------    

cleanup()->
  
    ok.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------

