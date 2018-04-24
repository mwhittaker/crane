# Setups for echo server.

source configs/default-options.sh
app="echo"                     # app name appears in process list
xtern=1                        # 1 use xtern, 0 otherwise.
proxy=1                        # 1 use proxy, 0 otherwise
sch_paxos=1                    # 1 xtern will schedule with paxos, 0 otherwise
sch_dmt=1                      # 1 libevent_paxos will schedule with DMT, 0 otherwise
enable_lxc="no"
dmt_log_output=0
leader_elect=0                 # 1 enable leader election demo, 0 otherwise
checkpoint=0                   # 1 use checkpoint on relicas, 0 otherwise
checkpoint_period=10           # period of CRIU checkpoint, e.g. 10 seconds
msmr_root_client="$MSMR_ROOT"  # root dir for m-smr
msmr_root_server="$MSMR_ROOT"
input_url="127.0.0.1"          # url for client to query
analysis_tools=""              # for executing analysis tools
num_req=1000
num_thd=8

if [ $1"X" != "X" ]; then
  if [ $1"X" == "joint_schedX" ]; then
    use_joint_scheduling_plan;
    enable_lxc="yes"; # Heming: enable_lxc is tested.
  elif [ $1"X" == "separate_schedX" ]; then
    use_separate_scheduling_plan;
  elif [ $1"X" == "xtern_onlyX" ]; then
    use_xtern_only_plan;
  elif [ $1"X" == "proxy_onlyX" ]; then
    use_proxy_only_plan;
  elif [ $1"X" == "origX" ]; then
    use_orig_plan;
  fi
  echo "The plan to run is: $1";
else
  echo "No plan specified. The default plan to run is: proxy_only";
  use_proxy_only_plan;
fi

client_cmd="hostname"
server_cmd="'python ${msmr_root_server}/apps/echo/server.py'"
