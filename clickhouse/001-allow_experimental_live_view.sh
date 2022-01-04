#!/bin/bash

DDIR=/etc/clickhouse-server/users.d
[ -d $DDIR ] || mkdir -p $DDIR || exit 1

tee -a $DDIR/allow_experimental_live_view.xml <<-EOXML
<?xml version="1.0"?>
<yandex>
    <profiles>
        <default>
             <allow_experimental_live_view>1</allow_experimental_live_view>
         </default>
    </profiles>
</yandex>
EOXML
