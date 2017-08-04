fortress.host.type: ""
#本地文件路径，路径必须存在，fortress进程必须有读写权限。
fortress.local.dir: "/bossbgapp/run/fortress-server/data"
fortress.app.home: "/bossbgapp/AcctMgrBackApp"
fortress.zookeeper.root: "/acctmgr"

java.library.path: ""
#java.ext.dir: "/bossbgapp/fortresslib/lib"

fortress.zookeeper.servers:
 - "10.162.200.215"
 - "10.162.200.216"
 - "10.162.200.217"
 - "10.162.200.218"
 - "10.162.200.219"
fortress.zookeeper.port: 2193
fortress.zookeeper.connection.timeout: 5000
fortress.zookeeper.session.timeout: 5000
#The interval between retries of a Zookeeper operation.
fortress.zookeeper.retry.interval: 1000
#The number of times to retry a Zookeeper operation.
fortress.zookeeper.retry.times: 20
#The ceiling of the interval between retries of a Zookeeper operation.
fortress.zookeeper.retry.intervalceiling.millis: 10000


commander.use.ip: true
commander.service.port: 1000

#强制发起重新分配的超时时间
commander.monitor.reassign.timeout.secs: 1800

#
commander.monitor.freq.secs: 10

#集群的分布式工作模式，取值范围：distributed或local
fortress.cluster.mode: "distributed"

#captain.hostname: ""
captain.use.ip: true

#任务心跳频率设置
task.heartbeat.frequency.secs: 10

#captain的心跳间隔
captain.heartbeat.frequency.secs: 5000

captain.monitor.frequency.secs: 10

#启动初始化的最大时长，如果在captain.worker.start.timeout.secs时间内还没有起来，
#captain将重新启动他。因为在启动的时候，需要配置一些额外的overhead，所以在启动时，
#此值将覆盖captain.worker.timeout.secs值。
#单位秒
captain.worker.start.timeout.secs: 120
#worker的心跳超时时间设置，如果超时captain将重新启动他
captain.worker.timeout.secs: 120

#采样频率：每多少秒产生一次采样，最好是任务心跳频率（task.heartbeat.frequency.secs）的倍数。
job.stats.sample.frequency.secs: 3600

#job的选项格式定义，将在worker启动时使用.
job.worker.childopts: " -Xms2048m -Xmx2048m "

#任务读取数据的延时秒数。
task.fetch.data.delay.secs: 1
