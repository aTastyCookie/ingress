#!/bin/sh
cat /var/spool/ingress/GET_PAGINATED_PLEXTS/`ls /var/spool/ingress/GET_PAGINATED_PLEXTS/|tail -n 1`|json_xs > /tmp/comm.json
cat /var/spool/ingress/GET_THINNED_ENTITIES/`ls /var/spool/ingress/GET_THINNED_ENTITIES/|tail -n 1`|json_xs > /tmp/thinned.json
cat /var/spool/ingress/GET_PORTAL_DETAILS/`ls /var/spool/ingress/GET_PORTAL_DETAILS/|tail -n 1`|json_xs > /tmp/portal.json
#method=`cat /tmp/comm.json|grep -E '[a-z0-9]{16}" : "[a-z0-9]{16}"'|tr -d '",'|cut -d: -f1|grep -oE "[a-z0-9]{16}"`
method=`cat /tmp/comm.json|grep -E '[a-z0-9]{16}" : "getPlexts"'|tr -d '",'|cut -d: -f1|grep -oE "[a-z0-9]{16}"`
#getPaginatedPlexts=`cat /tmp/comm.json|grep -E '[a-z0-9]{16}" : "[a-z0-9]{16}"'|tr -d '",'|cut -d: -f2|grep -oE "[a-z0-9]{16}"`
getPaginatedPlexts='getPlexts'
version_parameter=`cat /tmp/comm.json|grep -oE "[a-z0-9]{40}"`
desiredNumItems=`cat /tmp/comm.json|grep -E '[a-z0-9]{16}" : 31'|tr -d '",'|cut -d: -f1|grep -oE "[a-z0-9]{16}"`
minTimestampMs=`cat /tmp/comm.json|grep -E '[a-z0-9]{16}" : [a-z0-9]{13}'|tr -d '",'|cut -d: -f1|grep -oE "[a-z0-9]{16}"`
maxTimestampMs=`cat /tmp/comm.json|grep -E '[a-z0-9]{16}" : -1'|tr -d '",'|cut -d: -f1|grep -oE "[a-z0-9]{16}"`
chatTab=`cat /tmp/comm.json|grep -E '[a-z0-9]{16}" : "all"'|tr -d '",'|cut -d: -f1|grep -oE "[a-z0-9]{16}"`
minLatE6=`cat /tmp/comm.json|grep -E '[a-z0-9]{16}" : 568'|tr -d '",'|cut -d: -f1|grep -oE "[a-z0-9]{16}"`
minLngE6=`cat /tmp/comm.json|grep -E '[a-z0-9]{16}" : 238'|tr -d '",'|cut -d: -f1|grep -oE "[a-z0-9]{16}"`
maxLatE6=`cat /tmp/comm.json|grep -E '[a-z0-9]{16}" : 570'|tr -d '",'|cut -d: -f1|grep -oE "[a-z0-9]{16}"`
maxLngE6=`cat /tmp/comm.json|grep -E '[a-z0-9]{16}" : 244'|tr -d '",'|cut -d: -f1|grep -oE "[a-z0-9]{16}"`
minLatE6='minLatE6'
minLngE6='minLngE6'
maxLatE6='maxLatE6'
maxLngE6='maxLngE6'
minTimestampMs='minTimestampMs'
maxTimestampMs='maxTimestampMs'
chatTab='tab'
version='v'
#getThinnedEntities=`cat /tmp/thinned.json|grep -E '[a-z0-9]{16}" : "[a-z0-9]{16}"'|tr -d '",'|cut -d: -f2|grep -oE "[a-z0-9]{16}"`
getThinnedEntities=getEntities
#quadKeys=`cat /tmp/thinned.json|grep -E '[a-z0-9]{16}" : \['|tr -d '",'|cut -d: -f1|grep -oE "[a-z0-9]{16}"`
quadKeys=tileKeys
portalGuid=`cat /tmp/portal.json |grep -E '[a-z0-9]{16}" : "[a-z0-9]{32}.1[1-6]'|tr -d '",'|cut -d: -f1|grep -oE "[a-z0-9]{16}"`
getPortalDetails=`cat /tmp/portal.json|grep -E '[a-z0-9]{16}" : "[a-z0-9]{16}"'|tr -d '",'|cut -d: -f2|grep -oE "[a-z0-9]{16}"`
ascendingTimestampOrder=ascendingTimestampOrder
echo "
  export ascendingTimestampOrder=$ascendingTimestampOrder
  export chatTab=$chatTab
  export getArtifactInfo=$getArtifactInfo
  export getGameScore=$getGameScore
  export getPaginatedPlexts=$getPaginatedPlexts
  export getPortalDetails=$getPortalDetails
  export getThinnedEntities=$getThinnedEntities
  export redeemReward=$redeemReward
  export sendInviteEmail=$sendInviteEmail
  export sendPlext=$sendPlext
  export desiredNumItems=$desiredNumItems
  export portalGuid=$portalGuid
  export inviteeEmailAddress=$inviteeEmailAddress
  export maxLatE6=$maxLatE6
  export maxLngE6=$maxLngE6
  export minTimestampMs=$minTimestampMs
  export message=$message
  export method=$method
  export minLatE6=$minLatE6
  export minLngE6=$minLngE6
  export maxTimestampMs=$maxTimestampMs
  export quadKeys=$quadKeys
  export version=$version
  export version_parameter=$version_parameter"|grep -vE "=$" > mungs.inc
cat mungs.inc|awk '{print $2}' > mungs.inc.pl
