%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(lib_bully).  
   
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-ifdef(unit_test).
-define(get_nodes(),test_get_nodes()).
-else.
-define(get_nodes(),prod_get_nodes()).
-endif.


%%---------------------------------------------------------------------
%% Records for test
%%

%% --------------------------------------------------------------------
-compile(export_all).


%% ====================================================================
%% External functions
%% ====================================================================
get_nodes()->
    ?get_nodes().


prod_get_nodes()->
    lists:delete(node(),sd:get(bully)).

test_get_nodes()->
    lists:delete(node(),sd:get(bully)).


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
