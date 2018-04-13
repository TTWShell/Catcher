# Catcher

Telegraf (StatsD) + InfluxDB (storage) + Grafana (dashboard).一个单机部署的demo，仅供参考。你可以从这个demo学会：

1. 一个业界广泛使用的监控方案；
2. docker的基本使用。

基本原理图（来自参考1）：

![img](https://2bjee8bvp8y263sjpl3xui1a-wpengine.netdna-ssl.com/wp-content/uploads/statsd-telegraf.png)

使用Grafana查询并展示数据。

# Help

## ./catcher.sh

查看命令帮助信息：

    ./catcher.sh help

## 使用教程

1. 程序启动:

        ./catcher.sh start

2. 发送statsd数据到influxdb：

        for i in `seq 1 100`; do echo "mycounter:10|c" | nc -C -w 1 -u 10.30.138.179 8125; done

3. 确认数据入库：

    进入shell环境 (`./catcher.sh shell`)，使用influx命令，你将会在数据库看到记录。

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

4. 进入Grafana Dashboards:

    Grafana服务运行在0.0.0.0:8000，你可以直接展示给内网用户，浏览器访问 http://host:8000 即可。用户名密码默认为admin:admin。

5. 最终效果图:

    ![img](https://user-images.githubusercontent.com/8017604/38741258-20a8a89e-3f6c-11e8-9f1a-6af490af0a21.png)

## Note

1. demo使用的是sqlite3数据库（grafana数据存储）;
2. grafana配置databases（influxdb）需要在Dashboards单独配置，请参考链接10；
3. 1、2中的数据库配置意义不同，一个是grafana web服务自身数据存储，另一个是展示的源数据存储。

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
10. [http://docs.grafana.org/features/datasources/influxdb/](http://docs.grafana.org/features/datasources/influxdb/)
