checkScript() {
  local pid=$PPID
  while [ "$pid" != "0" ]; do
    local cmd="$(echo $(ps -ocommand= -p $pid))"

    if echo $cmd | grep -q -E "^\s*script\s+/tmp/.+\.session\.log\s*$"; then
      echo true
      return
    fi

    pid=$(echo $(ps -o ppid= $pid))
  done

  echo false
}