! Do not edit.  This file has been generated from
! "https://github.com/antirez/redis-doc/raw/master/commands.json".

IN: jp.redis.formatter

: rq2-append           ( key value                  -- request ) "APPEND" 2format-multi ; inline 
: rq2-auth             ( password                   -- request ) "AUTH" 1format-multi ; inline 
: rq2-bgrewriteaof     (                            -- request ) "BGREWRITEAOF" 0format-multi ; inline 
: rq2-bgsave           (                            -- request ) "BGSAVE" 0format-multi ; inline 
: rq2-blpop            ( key timeout                -- request ) "BLPOP" 2format-multi ; inline 
: rq2-brpop            ( key timeout                -- request ) "BRPOP" 2format-multi ; inline 
: rq2-brpoplpush       ( source destination timeout -- request ) "BRPOPLPUSH" 3format-multi ; inline 
: rq2-config-get       ( parameter                  -- request ) "CONFIG GET" 1format-multi ; inline 
: rq2-config-resetstat (                            -- request ) "CONFIG RESETSTAT" 0format-multi ; inline 
: rq2-config-set       ( parameter value            -- request ) "CONFIG SET" 2format-multi ; inline 
: rq2-dbsize           (                            -- request ) "DBSIZE" 0format-multi ; inline 
: rq2-debug-object     ( key                        -- request ) "DEBUG OBJECT" 1format-multi ; inline 
: rq2-debug-segfault   (                            -- request ) "DEBUG SEGFAULT" 0format-multi ; inline 
: rq2-decr             ( key                        -- request ) "DECR" 1format-multi ; inline 
: rq2-decrby           ( key decrement              -- request ) "DECRBY" 2format-multi ; inline 
: rq2-del              ( key                        -- request ) "DEL" 1format-multi ; inline 
: rq2-discard          (                            -- request ) "DISCARD" 0format-multi ; inline 
: rq2-echo             ( message                    -- request ) "ECHO" 1format-multi ; inline 
: rq2-exec             (                            -- request ) "EXEC" 0format-multi ; inline 
: rq2-exists           ( key                        -- request ) "EXISTS" 1format-multi ; inline 
: rq2-expire           ( key seconds                -- request ) "EXPIRE" 2format-multi ; inline 
: rq2-expireat         ( key timestamp              -- request ) "EXPIREAT" 2format-multi ; inline 
: rq2-flushall         (                            -- request ) "FLUSHALL" 0format-multi ; inline 
: rq2-flushdb          (                            -- request ) "FLUSHDB" 0format-multi ; inline 
: rq2-get              ( key                        -- request ) "GET" 1format-multi ; inline 
: rq2-getbit           ( key offset                 -- request ) "GETBIT" 2format-multi ; inline 
: rq2-getrange         ( key start end              -- request ) "GETRANGE" 3format-multi ; inline 
: rq2-getset           ( key value                  -- request ) "GETSET" 2format-multi ; inline 
: rq2-hdel             ( key field                  -- request ) "HDEL" 2format-multi ; inline 
: rq2-hexists          ( key field                  -- request ) "HEXISTS" 2format-multi ; inline 
: rq2-hget             ( key field                  -- request ) "HGET" 2format-multi ; inline 
: rq2-hgetall          ( key                        -- request ) "HGETALL" 1format-multi ; inline 
: rq2-hincrby          ( key field increment        -- request ) "HINCRBY" 3format-multi ; inline 
: rq2-hkeys            ( key                        -- request ) "HKEYS" 1format-multi ; inline 
: rq2-hlen             ( key                        -- request ) "HLEN" 1format-multi ; inline 
: rq2-hmget            ( key field                  -- request ) "HMGET" 2format-multi ; inline 
: rq2-hmset            ( key field-value            -- request ) "HMSET" 2format-multi ; inline 
: rq2-hset             ( key field value            -- request ) "HSET" 3format-multi ; inline 
: rq2-hsetnx           ( key field value            -- request ) "HSETNX" 3format-multi ; inline 
: rq2-hvals            ( key                        -- request ) "HVALS" 1format-multi ; inline 
: rq2-incr             ( key                        -- request ) "INCR" 1format-multi ; inline 
: rq2-incrby           ( key increment              -- request ) "INCRBY" 2format-multi ; inline 
: rq2-info             (                            -- request ) "INFO" 0format-multi ; inline 
: rq2-keys             ( pattern                    -- request ) "KEYS" 1format-multi ; inline 
: rq2-lastsave         (                            -- request ) "LASTSAVE" 0format-multi ; inline 
: rq2-lindex           ( key index                  -- request ) "LINDEX" 2format-multi ; inline 
: rq2-linsert          ( key where pivot value      -- request ) "LINSERT" 4format-multi ; inline 
: rq2-llen             ( key                        -- request ) "LLEN" 1format-multi ; inline 
: rq2-lpop             ( key                        -- request ) "LPOP" 1format-multi ; inline 
: rq2-lpush            ( key value                  -- request ) "LPUSH" 2format-multi ; inline 
: rq2-lpushx           ( key value                  -- request ) "LPUSHX" 2format-multi ; inline 
: rq2-lrange           ( key start stop             -- request ) "LRANGE" 3format-multi ; inline 
: rq2-lrem             ( key count value            -- request ) "LREM" 3format-multi ; inline 
: rq2-lset             ( key index value            -- request ) "LSET" 3format-multi ; inline 
: rq2-ltrim            ( key start stop             -- request ) "LTRIM" 3format-multi ; inline 
: rq2-mget             ( key                        -- request ) "MGET" 1format-multi ; inline 
: rq2-monitor          (                            -- request ) "MONITOR" 0format-multi ; inline 
: rq2-move             ( key db                     -- request ) "MOVE" 2format-multi ; inline 
: rq2-mset             ( key-value                  -- request ) "MSET" 1format-multi ; inline 
: rq2-msetnx           ( key-value                  -- request ) "MSETNX" 1format-multi ; inline 
: rq2-multi            (                            -- request ) "MULTI" 0format-multi ; inline 
: rq2-object           ( subcommand                 -- request ) "OBJECT" 1format-multi ; inline 
: rq2-persist          ( key                        -- request ) "PERSIST" 1format-multi ; inline 
: rq2-ping             (                            -- request ) "PING" 0format-multi ; inline 
: rq2-psubscribe       ( pattern                    -- request ) "PSUBSCRIBE" 1format-multi ; inline 
: rq2-publish          ( channel message            -- request ) "PUBLISH" 2format-multi ; inline 
: rq2-punsubscribe     (                            -- request ) "PUNSUBSCRIBE" 0format-multi ; inline 
: rq2-quit             (                            -- request ) "QUIT" 0format-multi ; inline 
: rq2-randomkey        (                            -- request ) "RANDOMKEY" 0format-multi ; inline 
: rq2-rename           ( key newkey                 -- request ) "RENAME" 2format-multi ; inline 
: rq2-renamenx         ( key newkey                 -- request ) "RENAMENX" 2format-multi ; inline 
: rq2-rpop             ( key                        -- request ) "RPOP" 1format-multi ; inline 
: rq2-rpoplpush        ( source destination         -- request ) "RPOPLPUSH" 2format-multi ; inline 
: rq2-rpush            ( key value                  -- request ) "RPUSH" 2format-multi ; inline 
: rq2-rpushx           ( key value                  -- request ) "RPUSHX" 2format-multi ; inline 
: rq2-sadd             ( key member                 -- request ) "SADD" 2format-multi ; inline 
: rq2-save             (                            -- request ) "SAVE" 0format-multi ; inline 
: rq2-scard            ( key                        -- request ) "SCARD" 1format-multi ; inline 
: rq2-sdiff            ( key                        -- request ) "SDIFF" 1format-multi ; inline 
: rq2-sdiffstore       ( destination key            -- request ) "SDIFFSTORE" 2format-multi ; inline 
: rq2-select           ( index                      -- request ) "SELECT" 1format-multi ; inline 
: rq2-set              ( key value                  -- request ) "SET" 2format-multi ; inline 
: rq2-setbit           ( key offset value           -- request ) "SETBIT" 3format-multi ; inline 
: rq2-setex            ( key seconds value          -- request ) "SETEX" 3format-multi ; inline 
: rq2-setnx            ( key value                  -- request ) "SETNX" 2format-multi ; inline 
: rq2-setrange         ( key offset value           -- request ) "SETRANGE" 3format-multi ; inline 
: rq2-shutdown         (                            -- request ) "SHUTDOWN" 0format-multi ; inline 
: rq2-sinter           ( key                        -- request ) "SINTER" 1format-multi ; inline 
: rq2-sinterstore      ( destination key            -- request ) "SINTERSTORE" 2format-multi ; inline 
: rq2-sismember        ( key member                 -- request ) "SISMEMBER" 2format-multi ; inline 
: rq2-slaveof          ( host port                  -- request ) "SLAVEOF" 2format-multi ; inline 
: rq2-slowlog          ( subcommand                 -- request ) "SLOWLOG" 1format-multi ; inline 
: rq2-smembers         ( key                        -- request ) "SMEMBERS" 1format-multi ; inline 
: rq2-smove            ( source destination member  -- request ) "SMOVE" 3format-multi ; inline 
: rq2-sort             ( key                        -- request ) "SORT" 1format-multi ; inline 
: rq2-spop             ( key                        -- request ) "SPOP" 1format-multi ; inline 
: rq2-srandmember      ( key                        -- request ) "SRANDMEMBER" 1format-multi ; inline 
: rq2-srem             ( key member                 -- request ) "SREM" 2format-multi ; inline 
: rq2-strlen           ( key                        -- request ) "STRLEN" 1format-multi ; inline 
: rq2-subscribe        ( channel                    -- request ) "SUBSCRIBE" 1format-multi ; inline 
: rq2-sunion           ( key                        -- request ) "SUNION" 1format-multi ; inline 
: rq2-sunionstore      ( destination key            -- request ) "SUNIONSTORE" 2format-multi ; inline 
: rq2-sync             (                            -- request ) "SYNC" 0format-multi ; inline 
: rq2-ttl              ( key                        -- request ) "TTL" 1format-multi ; inline 
: rq2-type             ( key                        -- request ) "TYPE" 1format-multi ; inline 
: rq2-unsubscribe      (                            -- request ) "UNSUBSCRIBE" 0format-multi ; inline 
: rq2-unwatch          (                            -- request ) "UNWATCH" 0format-multi ; inline 
: rq2-watch            ( key                        -- request ) "WATCH" 1format-multi ; inline 
: rq2-zadd             ( key score member           -- request ) "ZADD" 3format-multi ; inline 
: rq2-zcard            ( key                        -- request ) "ZCARD" 1format-multi ; inline 
: rq2-zcount           ( key min max                -- request ) "ZCOUNT" 3format-multi ; inline 
: rq2-zincrby          ( key increment member       -- request ) "ZINCRBY" 3format-multi ; inline 
: rq2-zinterstore      ( destination numkeys key    -- request ) "ZINTERSTORE" 3format-multi ; inline 
: rq2-zrange           ( key start stop             -- request ) "ZRANGE" 3format-multi ; inline 
: rq2-zrangebyscore    ( key min max                -- request ) "ZRANGEBYSCORE" 3format-multi ; inline 
: rq2-zrank            ( key member                 -- request ) "ZRANK" 2format-multi ; inline 
: rq2-zrem             ( key member                 -- request ) "ZREM" 2format-multi ; inline 
: rq2-zremrangebyrank  ( key start stop             -- request ) "ZREMRANGEBYRANK" 3format-multi ; inline 
: rq2-zremrangebyscore ( key min max                -- request ) "ZREMRANGEBYSCORE" 3format-multi ; inline 
: rq2-zrevrange        ( key start stop             -- request ) "ZREVRANGE" 3format-multi ; inline 
: rq2-zrevrangebyscore ( key max min                -- request ) "ZREVRANGEBYSCORE" 3format-multi ; inline 
: rq2-zrevrank         ( key member                 -- request ) "ZREVRANK" 2format-multi ; inline 
: rq2-zscore           ( key member                 -- request ) "ZSCORE" 2format-multi ; inline 
: rq2-zunionstore      ( destination numkeys key    -- request ) "ZUNIONSTORE" 3format-multi ; inline 
