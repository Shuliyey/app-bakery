checkTermToSVG() {
  local pid=$PPID
  while [ "$pid" != "0" ]; do
    local cmd="$(echo $(ps -ocommand= -p $pid))"

    if echo $cmd | grep -q -E "^\s*/usr/bin/python3\s+/usr/local/bin/termtosvg\s+/tmp/.+\.svg\s*$"; then
      echo true
      return
    fi

    pid=$(echo $(ps -o ppid= $pid))
  done

  echo false
}