# Catcher

Telegraf (StatsD) + InfluxDB (storage) + Grafana (dashboard).

一个单机部署的demo，仅供参考。可以自行集群化各组件。

# Help

查看命令帮助信息：

    ./catcher.sh help

程序启动 (./catcher.sh start) 后，可以使用一下命令测试：

    echo "mycounter:10|c" | nc -C -w 1 -u 127.0.0.1 8125

进入shell环境 (./catcher.sh shell)，使用influx命令，你将会在数据库看到一条记录：

    Connected to http://localhost:8086 version 1.5.1
    InfluxDB shell version: 1.5.1
    > use telegraf;
    Using database telegraf
    > show measurements;
    name: measurements
    name
    ----
    cpu
    disk
    diskio
    kernel
    mem
    mycounter
    processes
    swap
    system
    > select * from mycounter;
    name: mycounter
    time                host                    metric_type value
    ----                ----                    ----------- -----
    1523512020000000000 iZ2ze12cw2az4c7fwkbv8lZ counter     10
    >

# 参考

1. [https://www.influxdata.com/blog/getting-started-with-sending-statsd-metrics-to-telegraf-influxdb/](https://www.influxdata.com/blog/getting-started-with-sending-statsd-metrics-to-telegraf-influxdb/)
2. [https://github.com/influxdata/telegraf](https://github.com/influxdata/telegraf)
3. [http://blog.gezhiqiang.com/2017/01/25/statsd-summary/](http://blog.gezhiqiang.com/2017/01/25/statsd-summary/)
4. [https://opsx.alibaba.com/mirror](https://opsx.alibaba.com/mirror)
5. [https://portal.influxdata.com/downloads](https://portal.influxdata.com/downloads)
6. [https://www.influxdata.com/blog/sensu-influxdb-storing-data-metrics-collection-checks/](https://www.influxdata.com/blog/sensu-influxdb-storing-data-metrics-collection-checks/)
7. [https://www.influxdata.com/blog/how-to-use-grafana-with-influxdb-to-monitor-time-series-data/](https://www.influxdata.com/blog/how-to-use-grafana-with-influxdb-to-monitor-time-series-data/)
8. [https://github.com/grafana/grafana](https://github.com/grafana/grafana)
9. [https://grafana.com/grafana/download](https://grafana.com/grafana/download)
