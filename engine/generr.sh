#!/bin/sh

_cvt=`cat <<EOF
err, code = STDIN.read.gsub(/\s+/,":").split(":")[1..2]
_, name = err.split("_")
puts "RDS_#{name} = #{code},"
EOF
`

while read -r l; do
  echo "$l" | ruby -e "$_cvt"
done <<< "$(cat vedis.h | grep "VEDIS_" | grep -E "(SX(RET|ERR)|\(\-\d{2}\))")"
