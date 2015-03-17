#!/bin/bash
echo "{" > /tmp/sql2guids
mysql ingress -e "select concat (\"'\",nickname,\"':'\",guid,\"',\") from guids;"|grep -v concat |tr "'" '"' >> /tmp/sql2guids
echo "\"huy\":\"0000000\"}" >> /tmp/sql2guids

